// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.


#import "RoomManager.h"
#import "Constants.h"
#import <KurentoToolbox/WebRTC/RTCPeerConnection.h>
#import <KurentoToolbox/WebRTC/RTCSessionDescription.h>
#import <KurentoToolbox/WebRTC/RTCDataChannel.h>

#import <Reachability.h>

static NSUInteger kConnectionMaxIceAttempts = 3;

typedef void(^ErrorBlock)(NSError *error);

@interface RoomManager () <NBMWebRTCPeerDelegate, NBMRoomClientDelegate>

@property (nonatomic, strong) NBMRoomClient *roomClient;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign) BOOL loopBack;
@property (nonatomic, strong, readonly) NSSet *allPeers;
@property (nonatomic, strong) NBMWebRTCPeer *webRTCPeer;
@property (nonatomic, strong) NSMutableArray *mutableRemoteStreams;
@property (nonatomic, strong, readonly) NSString *localConnectionId;
@property (nonatomic, assign) NSUInteger retryCount;
@property (nonatomic, assign) BOOL useDataChannels;
@property (nonatomic, strong) RTCDataChannel *dataChannel;

@property (nonatomic, copy) ErrorBlock publishVideoBlock;
@property (nonatomic, copy) ErrorBlock unpublishVideo;

@end

@implementation RoomManager

#pragma mark - Init & Dealloc

- (instancetype)initWithDelegate:(id<RoomManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _mutableRemoteStreams = [NSMutableArray array];
    }
    return self;
}


- (void)createRoomWithUsername:(NSString*)username roomName:(NSString *)room datachannels:(BOOL)datachannels{
    NSURL *roomURL = [NSURL URLWithString:ROOM_URL];
    self.useDataChannels = datachannels;
    self.room = [[NBMRoom alloc] initWithUsername:username roomName:room roomURL:roomURL dataChannels:self.useDataChannels];
}

#pragma mark - Public

- (void)joinRoomWithConfiguration:(NBMMediaConfiguration *)configuration {
    NSParameterAssert(self.room);
    
    [self setupRoomClient:self.room];
    
    [self setupReachability];
    
    [self setupWebRTCSession];
}

- (void)leaveRoom:(void (^)(NSError *))block {
    [self.roomClient leaveRoom:^(NSError *error) {
        
    }];
}

- (void)publishVideo:(void (^)(NSError *))block loopback:(BOOL)doLoopback {
    BOOL alreadyPublished = [self peerHasPublishedMedia:[self localPeer]];
    if (alreadyPublished) {
        if (block) {
            block(nil);
        }
        return;
    }
    self.loopBack = doLoopback;
    NSString *connectionId = [self localConnectionId];
    BOOL started = [self.webRTCPeer startLocalMedia];
    if (started) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate roomManager:self didAddLocalStream:self.localStream];
        });
        
        [self.webRTCPeer generateOffer:connectionId completion:^(NSString *sdpOffer, NBMPeerConnection *connection) {
            [self.roomClient publishVideo:(sdpOffer) loopback:NO completion:^(NSString *sdpAnswer, NSError *error) {
                if (block) {
                    block(error);
                }
                [self.webRTCPeer processAnswer:sdpAnswer connectionId:connection.connectionId];
            }];
        }];
    } else {
        //show error
        if (block) {
            NSError *error = [NSError errorWithDomain:@"" code:1 userInfo:nil];
            block(error);
        }
    }
}

- (void)unpublishVideo:(void (^)(NSError *))block {
    [self.webRTCPeer stopLocalMedia];
    [self.delegate roomManager:self didRemoveLocalStream:self.localStream];
    [self.webRTCPeer closeConnectionWithConnectionId:[self localConnectionId]];
    [self.roomClient unpublishVideo:^(NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

- (void)receiveVideoFromPeer:(NBMPeer *)peer completion:(void (^)(NSError *error))block {
    NSString *connectionId = [self connectionIdOfPeer:peer];
    [self.webRTCPeer generateOffer:connectionId completion:^(NSString *sdpOffer, NBMPeerConnection *connection) {
        [self.roomClient receiveVideoFromPeer:peer offer:sdpOffer.description completion:^(NSString *sdpAnswer, NSError *error) {
            [self.webRTCPeer processAnswer:sdpAnswer connectionId:connection.connectionId];
        }];
    }];
}

- (void)unsubscribeVideoFromPeer:(NBMPeer *)peer completion:(void (^)(NSError *))block {
    NSString *connectionId = [self connectionIdOfPeer:peer];
    [self.webRTCPeer closeConnectionWithConnectionId:connectionId];
    [self.roomClient unsubscribeVideoFromPeer:peer completion:^(NSString *sdpAnswer, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

- (void)selectCameraPosition:(NBMCameraPosition)cameraPosition {
    [self.webRTCPeer selectCameraPosition:cameraPosition];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate roomManager:self didAddLocalStream:self.localStream];
    });
}

- (BOOL)isVideoEnabled {
    return [self.webRTCPeer isVideoEnabled];
}

- (void)enableVideo:(BOOL)enable {
    [self.webRTCPeer enableVideo:enable];
}

- (BOOL)isAudioEnabled {
    return [self.webRTCPeer isAudioEnabled];
}

- (void)enableAudio:(BOOL)enable {
    [self.webRTCPeer enableAudio:enable];
}

- (void)disconnect {
    [self teardownRoomClient];
    [self teardownWebRTCSession];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.delegate roomManagerDidFinish:self];
    });
}

- (BOOL)isConnected {
    return self.roomClient.connected;
}

- (BOOL)isJoined {
    return self.roomClient.joined;
}

+ (NSSet *)keyPathsForValuesAffectingConnected {
    return [NSSet setWithObjects:@"self.roomClient.connected", nil];
}

+ (NSSet *)keyPathsForValuesAffectingJoined {
    return [NSSet setWithObjects:@"self.roomClient.joined", nil];
}

- (NBMPeer *)localPeer {
    return self.roomClient.room.localPeer;
}

- (RTCMediaStream *)localStream
{
    return self.webRTCPeer.localStream;
}

- (NSArray *)remotePeers {
    return [self.roomClient.peers copy];
}

- (NSArray *)remoteStreams
{
    return [self.mutableRemoteStreams copy];
}

- (NBMCameraPosition)cameraPosition {
    return self.webRTCPeer.cameraPosition;
}

- (void)sendDatachannelMessage:(NSString *)message {
    if (self.dataChannel) {
        NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
        RTCDataBuffer *buffer = [[RTCDataBuffer alloc]initWithData:messageData isBinary:false];

        [self.dataChannel sendData:buffer];
    }
}

#pragma mark - Private

- (void)setupRoomClient:(NBMRoom *)room {
    self.roomClient = [[NBMRoomClient alloc] initWithRoom:room delegate:self];
}

- (void)manageRoomClientConnection {
    BOOL isReachable = self.reachability.isReachable;
    BOOL retryAllowed = self.retryCount < 3;
    
    if (retryAllowed && isReachable) {
        self.retryCount++;
        [self.roomClient connect];
    }
    else if (!retryAllowed || !isReachable) {
        NSLog(@"Impossible to establish connection");
        NSError *retryError = [NSError errorWithDomain:@"it.nubomedia.NBMRoomManager"
                                                  code:0
                                              userInfo:@{NSLocalizedDescriptionKey: @"Impossible to establish WebSocket connection to Room Server, check internet connection"}];
        [self.delegate roomManager:self didFailWithError:retryError];
    }
}

- (void)retryRoomClientConnect {
    self.retryCount++;
    [self.roomClient connect];
}

- (void)setupWebRTCSession {
    NBMMediaConfiguration *defaultConfig = [NBMMediaConfiguration defaultConfiguration];
    NBMWebRTCPeer *webRTCManager = [[NBMWebRTCPeer alloc] initWithDelegate:self configuration:defaultConfig];
    
    if (!webRTCManager) {
        NSError *retryError = [NSError errorWithDomain:@"it.nubomedia.NBMRoomManager"
                                                  code:0
                                              userInfo:@{NSLocalizedDescriptionKey: @"Impossible to setup local media stream, check AUDIO & VIDEO permission"}];
        [self.delegate roomManager:self didFailWithError:retryError];
        return;
    }
    
    self.webRTCPeer = webRTCManager;
    
    BOOL started = [self.webRTCPeer startLocalMedia];
    
    if (started) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate roomManager:self didAddLocalStream:self.localStream];
        });
    }
}

- (void)setupReachability
{
    self.reachability = [Reachability reachabilityWithHostName:[self.roomClient.room.url absoluteString]];
    
    __weak typeof(self) weakSelf = self;
    
    self.reachability.reachableBlock = ^(Reachability *reach) {
        if (weakSelf.roomClient.connectionState == NBMRoomClientConnectionStateClosed) {
            [weakSelf.roomClient connect];
        }
    };
    
    [self.reachability startNotifier];
}

- (void)teardownRoomClient {
    self.roomClient = nil;
    self.retryCount = 0;
}

- (void)teardownWebRTCSession {
    [self.mutableRemoteStreams removeAllObjects];
    [self.webRTCPeer stopLocalMedia];
}

- (void)joinToRoom {
    [self.roomClient joinRoomWithDataChannels:self.useDataChannels];
}

- (void)generateLocalOffer {
    [self generateOfferForPeer:[self localPeer]];
}

- (void)generateOfferForPeer:(NBMPeer *)peer {
    NSString *connectionId = [self connectionIdOfPeer:peer];
    [self.webRTCPeer generateOffer:connectionId withDataChannels:self.useDataChannels];
}

- (void)safeICERestartForRemotePeer:(NBMPeer *)remotePeer {
    [self.roomClient unsubscribeVideoFromPeer:remotePeer completion:^(NSString *sdpAnswer, NSError *error) {
        [self generateOfferForPeer:remotePeer];
    }];
}

- (void)safeICERestartForLocalPeer {
    [self.roomClient unpublishVideo:^(NSError *error) {
        [self generateLocalOffer];
    }];
}

- (void)safeRestore {
    [self.roomClient leaveRoom:^(NSError *error) {
        [self joinToRoom];
    }];
}

- (void)restoreConnections {
    //Local peer
    BOOL restoreLocalPeer = [self peerIsRestorable:[self localPeer]];
    if (restoreLocalPeer) {
        [self safeICERestartForLocalPeer];
    }
    
    //Remote peers
    NSArray *remotePeers = [self.roomClient peers];
    for (NBMPeer *peer in remotePeers) {
        BOOL restoreRemotePeer = [self peerIsRestorable:peer];
        if (restoreRemotePeer) {
            [self safeICERestartForRemotePeer:peer];
        }
    }
}

- (BOOL)peerIsRestorable:(NBMPeer *)peer {
    NBMPeerConnection *localPeerConnection = [self connectionOfPeer:peer];
    BOOL isInactive = ![self isActiveConnection:localPeerConnection];
    BOOL hasPublishedStream = peer.streams.count > 0;
    
    return isInactive & hasPublishedStream;
}

- (BOOL)peerHasPublishedMedia:(NBMPeer *)peer {
    return peer.streams.count > 0 ? YES : NO;
}

#pragma mark - Peers & Connections

- (NSSet *)allPeers {
    NSMutableSet *allPeers = [NSMutableSet setWithArray:self.remotePeers];
    [allPeers addObject:[self localPeer]];
    
    return [allPeers copy];
}

- (NSString *)localConnectionId {
    NBMPeer *localPeer = [self localPeer];
    return [self connectionIdOfPeer:localPeer];
}

- (NBMPeer *)peerOfConnection:(NBMPeerConnection *)connection {
    NSString *connectionId = connection.connectionId;
    __block NBMPeer *peer;
    [self.allPeers enumerateObjectsUsingBlock:^(NBMPeer *aPeer, BOOL  *stop) {
        NSString *connectionIdOfPeer = [self connectionIdOfPeer:aPeer];
        if ([connectionIdOfPeer isEqualToString:connectionId]) {
            peer = aPeer;
            *stop = YES;
        }
    }];
    
    return peer;
}

- (NBMPeerConnection *)connectionOfPeer:(NBMPeer *)peer {
    NSString *connectionId = [self connectionIdOfPeer:peer];
    NBMPeerConnection *connection = [self.webRTCPeer connectionWithConnectionId:connectionId];
    
    return connection;
}

- (NSString *)connectionIdOfPeer:(NBMPeer *)peer {
    if (!peer) {
        peer = [self localPeer];
    }
    NSString *connectionId = peer.identifier;
    
    return connectionId;
}

- (BOOL)isActiveConnection:(NBMPeerConnection *)connection {
    RTCPeerConnection *rtcConnection = connection.peerConnection;
    if (rtcConnection.signalingState == RTCSignalingStateStable && rtcConnection.iceConnectionState != RTCIceConnectionStateFailed) {
        return YES;
    }
    return NO;
}

#pragma mark - NBMRoomDelegate

//Room Connection

- (void)client:(NBMRoomClient *)client isConnected:(BOOL)connected {
    if (connected) {
        self.retryCount = 0;
        if (!self.joined) {
            [self joinToRoom];
        }
    }
    else {
        [self manageRoomClientConnection];
    }
}

- (void)client:(NBMRoomClient *)client didFailWithError:(NSError *)error {
    [self.delegate roomManager:self didFailWithError:error];
}

//Room API

- (void)client:(NBMRoomClient *)client didJoinRoom:(NSError *)error {
    [self.delegate roomManager:self roomJoined:(NSError *)error];
    
    //publish video
    if (!error) {
        [self generateLocalOffer];
        //receive remote peers media
        NSArray *remotePeers = [self.roomClient peers];
        for (NBMPeer *peer in remotePeers) {
            NBMPeerConnection *peerConnection = [self connectionOfPeer:peer];
            if (!peerConnection && peer.streams.count > 0) {
                [self generateOfferForPeer:peer];
            }
        }
    }
}

- (void)client:(NBMRoomClient *)client didLeaveRoom:(NSError *)error {
    
}

//Room Events

- (void)client:(NBMRoomClient *)client participantJoined:(NBMPeer *)peer {
    [self.delegate roomManager:self peerJoined:peer];
}

- (void)client:(NBMRoomClient *)client participantLeft:(NBMPeer *)peer {
    NSString *connectionId = [self connectionIdOfPeer:peer];
    [self.webRTCPeer closeConnectionWithConnectionId:connectionId];
    [self.delegate roomManager:self peerLeft:peer];
}

- (void)client:(NBMRoomClient *)client participantEvicted:(NBMPeer *)peer {
    [self.delegate roomManagerPeerStatusChanged:self];
}

- (void)client:(NBMRoomClient *)client participantPublished:(NBMPeer *)peer {
    NBMPeerConnection *peerConnection = [self connectionOfPeer:peer];
    if (!peerConnection && peer.streams.count > 0) {
        [self generateOfferForPeer:peer];
    }
}

- (void)client:(NBMRoomClient *)client participantUnpublished:(NBMPeer *)peer {
    NSString *connectionId = [self connectionIdOfPeer:peer];
    [self.webRTCPeer closeConnectionWithConnectionId:connectionId];
}

- (void)client:(NBMRoomClient *)client didReceiveICECandidate:(RTCIceCandidate *)candidate fromParticipant:(NBMPeer *)peer {
    NSString *connectionId =[self connectionIdOfPeer:peer];
    [self.webRTCPeer addICECandidate:candidate connectionId:connectionId];
}

- (void)client:(NBMRoomClient *)client didReceiveMessage:(NSString *)message fromParticipant:(NBMPeer *)peer {
    [self.delegate roomManager:self messageReceived:message ofPeer:peer];;
}

- (void)client:(NBMRoomClient *)client mediaErrorOccurred:(NSError *)error {
    
}

- (void)client:(NBMRoomClient *)client roomWasClosed:(NBMRoom *)room {
    
}

#pragma mark - NBMWebRTCPeerDelegate

- (void)webRTCPeer:(NBMWebRTCPeer *)peer didGenerateAnswer:(RTCSessionDescription *)sdpAnswer forConnection:(NBMPeerConnection *)connection {
    
}

- (void)webRTCPeer:(NBMWebRTCPeer *)peer didGenerateOffer:(RTCSessionDescription *)sdpOffer forConnection:(NBMPeerConnection *)connection {
    NBMPeerConnection *localConnection = [self connectionOfPeer:[self localPeer]];
    if ([connection isEqual:localConnection]) {
        [self.roomClient publishVideo:(sdpOffer.description) loopback:NO completion:^(NSString *sdpAnswer, NSError *error) {
            [self.webRTCPeer processAnswer:sdpAnswer connectionId:connection.connectionId];
        }];
    } else {
        NBMPeer *remotePeer = [self peerOfConnection:connection];
        [self.roomClient receiveVideoFromPeer:remotePeer offer:sdpOffer.description completion:^(NSString *sdpAnswer, NSError *error) {
            [self.webRTCPeer processAnswer:sdpAnswer connectionId:connection.connectionId];
        }];
    }
}

- (void)webRTCPeer:(NBMWebRTCPeer *)peer didAddStream:(RTCMediaStream *)remoteStream ofConnection:(NBMPeerConnection *)connection {
    [self.mutableRemoteStreams addObject:remoteStream];
    NBMPeer *remotePeer = [self peerOfConnection:connection];
    if ([remotePeer isEqual:[self localPeer]] && !self.loopBack) {
        return;
    }
    [self.delegate roomManager:self didAddStream:remoteStream ofPeer:remotePeer];
}

- (void)webRTCPeer:(NBMWebRTCPeer *)peer didRemoveStream:(RTCMediaStream *)remoteStream ofConnection:(NBMPeerConnection *)connection {
    [self.mutableRemoteStreams removeObject:remoteStream];
    NBMPeer *remotePeer = [self peerOfConnection:connection];
    //error if remotepeer = nil, if partecipant left is nil
    if (!remotePeer) {
        //peer has left
        return;
    }
    [self.delegate roomManager:self didRemoveStream:remoteStream ofPeer:remotePeer];
}

- (void)webRTCPeer:(NBMWebRTCPeer *)peer hasICECandidate:(RTCIceCandidate *)candidate forConnection:(NBMPeerConnection *)connection {
    NBMPeer *remotePeer = [self peerOfConnection:connection];
    [self.roomClient sendICECandidate:candidate forPeer:remotePeer];
}

- (void)webrtcPeer:(NBMWebRTCPeer *)peer iceStatusChanged:(RTCIceConnectionState)state ofConnection:(NBMPeerConnection *)connection {
    switch (state) {
        case RTCIceConnectionStateNew:
        case RTCIceConnectionStateChecking:
        case RTCIceConnectionStateCompleted:
        case RTCIceConnectionStateCount:
        case RTCIceConnectionStateConnected:
            break;
        case RTCIceConnectionStateClosed:
        {
            [self.webRTCPeer closeConnectionWithConnectionId:connection.connectionId];
            break;
        }
        case RTCIceConnectionStateDisconnected:
        {
            break;
        }
        case RTCIceConnectionStateFailed:
        {
            // The connection failed during the ICE candidate phase.
            // While the peer is available on the signaling server we should retry with an ice-restart.
            BOOL canAttemptRestart = connection.iceAttempts <= kConnectionMaxIceAttempts; // && self.connected
            
            [self.webRTCPeer closeConnectionWithConnectionId:connection.connectionId];
            
            if (self.connected && self.mutableRemoteStreams.count == 0) {
                NSError *iceFailedError = [NSError errorWithDomain:@"it.nubomedia.NBMRoomManager"
                                                              code:0
                                                          userInfo:@{NSLocalizedDescriptionKey: @"Connection failed during ICE candidate phase"}];
                [self.delegate roomManager:self didFailWithError:iceFailedError];
            }
            
            break;
        }
    }
    
    NBMPeer *remotePeer = [self peerOfConnection:connection];
    [self.delegate roomManager:self iceStatusChanged:state ofPeer:remotePeer];
}

- (void)webRTCPeer:(NBMWebRTCPeer *)peer didAddDataChannel:(RTCDataChannel *)dataChannel {
    self.dataChannel = dataChannel;
}

@end
