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

#import <Foundation/Foundation.h>
#import <KurentoToolbox/KurentoToolbox.h>
#import <WebRTC/RTCPeerConnection.h>

@class RoomManager;
@class RTCMediaStream;
@class NBMRoom;
@class NBMMediaConfiguration;

@protocol RoomManagerDelegate<NSObject>

- (void)roomManagerDidFinish:(RoomManager *)broker;

- (void)roomManager:(RoomManager *)broker didAddLocalStream:(RTCMediaStream *)localStream;

- (void)roomManager:(RoomManager *)broker didRemoveLocalStream:(RTCMediaStream *)localStream;

- (void)roomManager:(RoomManager *)broker didAddStream:(RTCMediaStream *)remoteStream ofPeer:(NBMPeer *)remotePeer;

- (void)roomManager:(RoomManager *)broker didRemoveStream:(RTCMediaStream *)remoteStream ofPeer:(NBMPeer *)remotePeer;

- (void)roomManager:(RoomManager *)broker peerJoined:(NBMPeer *)peer;

- (void)roomManager:(RoomManager *)broker peerLeft:(NBMPeer *)peer;

- (void)roomManager:(RoomManager *)broker roomJoined:(NSError *)error;

- (void)roomManager:(RoomManager *)broker messageReceived:(NSString *)message ofPeer:(NBMPeer *)peer;

- (void)roomManagerPeerStatusChanged:(RoomManager *)broker;

- (void)roomManager:(RoomManager *)broker didFailWithError:(NSError *)error;

- (void)roomManager:(RoomManager *)broker iceStatusChanged:(RTCIceConnectionState)state ofPeer:(NBMPeer *)peer;

@end


@interface RoomManager : NSObject

@property (nonatomic, weak) id<RoomManagerDelegate> delegate;
@property (nonatomic, strong, readonly) RTCMediaStream *localStream;
@property (nonatomic, strong, readonly) NBMPeer *localPeer;
@property (nonatomic, strong, readonly) NSArray *remotePeers;
@property (nonatomic, strong, readonly) NSArray *remoteStreams;
@property (nonatomic, assign, readonly) NBMCameraPosition cameraPosition;

@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, assign, readonly, getter=isJoined) BOOL joined;

@property (nonatomic, strong) NBMRoom *room;

- (instancetype)initWithDelegate:(id<RoomManagerDelegate>)delegate;

- (void)createRoomWithUsername:(NSString*)username roomName:(NSString *)room datachannels:(BOOL)datachannels;

- (void)joinRoomWithConfiguration:(NBMMediaConfiguration *)configuration;

- (void)leaveRoom:(void (^)(NSError *error))block;

- (void)publishVideo:(void (^)(NSError *error))block loopback:(BOOL)doLoopback;

- (void)unpublishVideo:(void (^)(NSError *error))block;

- (void)receiveVideoFromPeer:(NBMPeer *)peer completion:(void (^)(NSError *error))block;

- (void)unsubscribeVideoFromPeer:(NBMPeer *)peer completion:(void (^)(NSError *error))block;

//WebRTC & Media

- (void)selectCameraPosition:(NBMCameraPosition)cameraPosition;

- (BOOL)isVideoEnabled;

- (void)enableVideo:(BOOL)enable;

- (BOOL)isAudioEnabled;

- (void)enableAudio:(BOOL)enable;

- (void)sendDatachannelMessage:(NSString *)message;

@end
