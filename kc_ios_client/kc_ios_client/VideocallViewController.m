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

#import "VideocallViewController.h"
#import "VideocallPeerViewCell.h"

#import <kc_ios_communicator/RoomManager.h>
#import <kc_ios_communicator/BLEManager.h>

#import <WebRTC/RTCMediaStream.h>
#import <WebRTC/RTCVideoTrack.h>

@interface VideocallViewController () <RoomManagerDelegate, NBMRendererDelegate, VideocallPeerViewCellDelegate, BLEManagerDelegate>

@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@property (nonatomic, strong) RoomManager *roomManager;
@property (nonatomic, strong, readonly) NSArray *allPeers;
@property (nonatomic, strong) NBMMediaConfiguration *mediaConfiguration;
@property (nonatomic, strong) NBMPeer *selectedPeer;

@property (nonatomic, strong) BLEManager *bleManager;

@property (nonatomic, strong) id<NBMRenderer> localRenderer;
@property (nonatomic, strong) NSMutableArray *remoteRenderers;
@property (nonatomic, strong) NSMutableDictionary *peerIdToRenderer;

@property (nonatomic, assign) UIInterfaceOrientation lastInterfaceOrientation;

@property (nonatomic, assign) BOOL publishing;
@property (nonatomic, assign) BOOL unpublishing;
@end

@implementation VideocallViewController {
    NSMutableDictionary *peripheralDict;
    NSArray *peripheralArray;
}

NSString *const kPeerCollectionViewCellIdentifier = @"PeerCollectionViewCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    self.roomManager = [[RoomManager alloc] initWithDelegate:self];
    
    _remoteRenderers = [NSMutableArray array];
    _peerIdToRenderer = [NSMutableDictionary dictionary];
    _mediaConfiguration = [NBMMediaConfiguration defaultConfiguration];
    
    [self.roomManager createRoomWithUsername:_userName roomName:[NSString stringWithFormat:@"%@", [[_timeline partyId]stringValue]] datachannels:true];
    [self.roomManager joinRoomWithConfiguration:nil];
    [self addRoomManagerObservers];
    
    peripheralDict = [[NSMutableDictionary alloc]init];

    self.mainVideoContainerView.layer.cornerRadius = 15;
    self.peripheralView.layer.cornerRadius = 10;
    self.peripheralView.layer.borderWidth = 2;
    self.peripheralView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", [_timeline partyName], [[_timeline partyId]stringValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.roomManager leaveRoom:^(NSError *error) {
    }];
    
    [self removeRoomManagerObservers];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
}

- (void)addRoomManagerObservers {
    [self.roomManager addObserver:self forKeyPath:@"connected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.roomManager addObserver:self forKeyPath:@"joined" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeRoomManagerObservers {
    [self.roomManager removeObserver:self forKeyPath:@"connected"];
    [self.roomManager removeObserver:self forKeyPath:@"joined"];
}

- (void)reloadPeerViews {    
    [self.peersCollectionView reloadData];

    [self.peersCollectionView performBatchUpdates:^{}
                                  completion:^(BOOL finished) {
                                      NBMPeer *peer = self.selectedPeer;
                                      if (!peer) {
                                          peer = self.roomManager.localPeer;
                                      }

                                      id<NBMRenderer> renderer = [self.peerIdToRenderer objectForKey:peer.identifier];

                                      [_mainVideoView removeFromSuperview];
                                      _mainVideoView = renderer.rendererView;
                                      _mainVideoView.frame = self.mainVideoContainerView.bounds;

                                      [self.mainVideoContainerView addSubview:_mainVideoView];
                                      [self.mainVideoContainerView sendSubviewToBack:_mainVideoView];
                                      _mainVideoView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                      [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                          _mainVideoView.transform = CGAffineTransformIdentity;
                                      } completion:nil];

                                      [self updatePeer:peer block:^(VideocallPeerViewCell *cell) {
                                          [cell.fullScreenImage setHidden:false];
                                      }];
                                  }];
}

#pragma mark -

- (id<NBMRenderer>)rendererForStream:(RTCMediaStream *)stream
{
    NSParameterAssert(stream);
    
    id<NBMRenderer> renderer = nil;
    RTCVideoTrack *videoTrack = [stream.videoTracks firstObject];
    NBMRendererType rendererType = self.mediaConfiguration.rendererType;
    
    if (rendererType == NBMRendererTypeOpenGLES) {
        renderer = [[NBMEAGLRenderer alloc] initWithDelegate:self];
    }
    
    renderer.videoTrack = videoTrack;
    
    return renderer;
}

- (void)removeRendererForStream:(RTCMediaStream *)stream
{
    // When checking for an RTCVideoTrack use indexOfObjectIdenticalTo: instead of containsObject:
    // RTCVideoTrack doesn't implement hash or isEqual: which caused false positives.
    
    id <NBMRenderer> rendererToRemove = nil;
    
    NSMutableArray *allRenderers = [NSMutableArray arrayWithArray:self.remoteRenderers];
    if (self.localRenderer) {
        [allRenderers addObject:self.localRenderer];
    }
    
    for (id<NBMRenderer> remoteRenderer in allRenderers) {
        NSUInteger videoTrackIndex = [stream.videoTracks indexOfObjectIdenticalTo:remoteRenderer.videoTrack];
        if (videoTrackIndex != NSNotFound) {
            rendererToRemove = remoteRenderer;
            break;
        }
    }
    
    if (rendererToRemove) {
        [self hideAndRemoveRenderer:rendererToRemove];
    }
    else {
        NSLog(@"No renderer to remove for stream: %@", stream);
    }
}

- (void)hideAndRemoveRenderer:(id<NBMRenderer>)renderer
{
    renderer.videoTrack = nil;
    
    if (renderer == self.localRenderer) {
        self.localRenderer = nil;
    }
    else {
        [self.remoteRenderers removeObject:renderer];
    }
}

- (NSIndexPath *)indexPathOfPeer:(NBMPeer *)peer {
    NSUInteger idx = [self.allPeers indexOfObject:peer];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    
    return indexPath;
}

- (void)updatePeer:(NBMPeer *)peer block:(void(^)(VideocallPeerViewCell* cell))block {
    NSIndexPath *indexPath = [self indexPathOfPeer:peer];
    VideocallPeerViewCell *cell = (id)[self.peersCollectionView cellForItemAtIndexPath:indexPath];
    block(cell);
}

#pragma mark - UICollectionViewDataSource

- (NSArray *)allPeers {
    NSMutableArray *allPeers = [NSMutableArray arrayWithArray:self.roomManager.remotePeers];
    [allPeers insertObject:self.roomManager.room.localPeer atIndex:0];
    
    return [allPeers copy];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPeers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideocallPeerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPeerCollectionViewCellIdentifier
                                                                           forIndexPath:indexPath];
    cell.delegate = self;
    [cell.fullScreenImage setHidden:true];
    
    NBMPeer *peer = self.allPeers[indexPath.row];
    
    id<NBMRenderer> renderer = [self.peerIdToRenderer objectForKey:peer.identifier];
    if (peer != _selectedPeer) {
        [cell setVideoView:renderer.rendererView];

    }
    [cell setPeerName:peer.identifier];
    NBMPeer *localPeer = self.roomManager.localPeer;
    if (renderer && [peer isEqual:localPeer]) {
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.peersCollectionView.frame.size.height, self.peersCollectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NBMPeer *peer = self.allPeers[indexPath.row];
    self.selectedPeer = peer;

    if (!peer) {
        peer = self.roomManager.localPeer;
    }
    
    id<NBMRenderer> renderer = [self.peerIdToRenderer objectForKey:peer.identifier];
    
    [_mainVideoView removeFromSuperview];
    _mainVideoView = renderer.rendererView;
    _mainVideoView.frame = self.mainVideoContainerView.bounds;
    
    [self.mainVideoContainerView addSubview:_mainVideoView];
    [self.mainVideoContainerView sendSubviewToBack:_mainVideoView];
    _mainVideoView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _mainVideoView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [self updatePeer:peer block:^(VideocallPeerViewCell *cell) {
        [cell.fullScreenImage setHidden:false];
    }];
    
    [self reloadPeerViews];
}

# pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"connected"]) {
        BOOL connected = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (connected) {
            [self onConnection];
        } else {
            [self onDisconnection];
        }
    }
    
    if ([keyPath isEqualToString:@"joined"]) {
        BOOL joined = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (joined) {
            [self onRoomJoined];
        }
    }
}

- (void)onConnection {
}

- (void)onDisconnection {
}

- (void)onRoomJoined {
}

#pragma mark - RoomManagerDelegate
- (void)roomManager:(RoomManager *)broker roomJoined:(NSError *)error {
    if (error) {
        [self showErrorAlert:error.localizedDescription action:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];

        NSLog(@"Room join error: %@", error.localizedDescription);
    } else {
        [self reloadPeerViews];
    }
}

- (void)roomManagerDidFinish:(RoomManager *)broker {
}

- (void)roomManager:(RoomManager *)broker didAddLocalStream:(RTCMediaStream *)localStream {
    id<NBMRenderer> renderer = [self rendererForStream:localStream];
    self.localRenderer = renderer;
    [self.peerIdToRenderer setValue:renderer forKey:self.roomManager.room.localPeer.identifier];

    self.selectedPeer = self.roomManager.room.localPeer;
    
    [self updatePeer:self.roomManager.room.localPeer block:^(VideocallPeerViewCell *cell) {
        self.selectedPeer = self.roomManager.room.localPeer;

        [cell.fullScreenImage setHidden:false];
    }];
}

- (void)roomManager:(RoomManager *)broker didRemoveLocalStream:(RTCMediaStream *)localStream {
    [self.peerIdToRenderer removeObjectForKey:self.roomManager.room.localPeer.identifier];
    
    [self hideAndRemoveRenderer:self.localRenderer];
    
    [self updatePeer:self.roomManager.room.localPeer block:^(VideocallPeerViewCell *cell) {
        [cell setVideoView:nil];
    }];
}

- (void)roomManager:(RoomManager *)broker didAddStream:(RTCMediaStream *)remoteStream ofPeer:(NBMPeer *)remotePeer {
    id<NBMRenderer> renderer = [self rendererForStream:remoteStream];
    [self.remoteRenderers addObject:renderer];
    [self.peerIdToRenderer setValue:renderer forKey:remotePeer.identifier];
    
    [self updatePeer:remotePeer block:^(VideocallPeerViewCell *cell) {
        [cell setVideoView:renderer.rendererView];
        //[cell showSpinner];
    }];
}

- (void)roomManager:(RoomManager *)broker didRemoveStream:(RTCMediaStream *)remoteStream ofPeer:(NBMPeer *)remotePeer {
    [self.peerIdToRenderer removeObjectForKey:remotePeer.identifier];
    [self removeRendererForStream:remoteStream];
    
    [self updatePeer:remotePeer block:^(VideocallPeerViewCell *cell) {
        [cell setVideoView:nil];
    }];
}

- (void)roomManager:(RoomManager *)broker peerJoined:(NBMPeer *)peer {
    [self reloadPeerViews];
}

- (void)roomManager:(RoomManager *)broker peerLeft:(NBMPeer *)peer {
    if ([self.selectedPeer isEqual: peer]) {
        self.selectedPeer = nil;
    }

    [self reloadPeerViews];
}

- (void)roomManager:(RoomManager *)broker didFailWithError:(NSError *)error {
    [self showErrorAlert:error.localizedDescription action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)roomManager:(RoomManager *)broker messageReceived:(NSString *)message ofPeer:(NBMPeer *)peer {
}

- (void)roomManagerPeerStatusChanged:(RoomManager *)broker {
    [self reloadPeerViews];
}

- (void)roomManager:(RoomManager *)broker iceStatusChanged:(RTCIceConnectionState)state ofPeer:(NBMPeer *)peer {
    switch (state) {
        case RTCIceConnectionStateConnected:
            break;
        case RTCIceConnectionStateCompleted:
            break;
        case RTCIceConnectionStateClosed:
            break;
        case RTCIceConnectionStateFailed:
            break;
        case RTCIceConnectionStateCount:
            break;
        case RTCIceConnectionStateChecking:
            break;
        case RTCIceConnectionStateNew:
            break;
        case RTCIceConnectionStateDisconnected:
            break;
    }
}

- (void)renderer:(id<NBMRenderer>)renderer streamDimensionsDidChange:(CGSize)dimensions {
}

- (void)rendererDidReceiveVideoData:(id<NBMRenderer>)renderer {
}

- (IBAction)attachBLE:(UIBarButtonItem *)sender {
    [_peripheralView setHidden:false];

    _bleManager = [[BLEManager alloc]init];
    [_bleManager setDelegate:self];

    [_peripheralStateLabel setText:@"Searching peripherals..."];
}

- (IBAction)cancelBLE:(UIButton *)sender {
    [_bleManager stopBLE];
    [_peripheralView setHidden:true];
}

- (void)showErrorAlert:(NSString *)message action:(void(^)())actionToExecute{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionToExecute();
    }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - BLEManagerDelegate
- (void)discoveredPeripheral:(CBPeripheral *)peripheral {
    [peripheralDict setObject:peripheral forKey:[peripheral name]];
    peripheralArray = [peripheralDict allValues];

    [_peripheralTable reloadData];
}

- (void)bleError:(NSString *)error {
    NSLog(@"BLE Error: %@", error);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"BLE Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:alertAction];

    [self presentViewController:alertController animated:true completion:nil];
}

- (void)retrievedData:(NSDictionary *)data {
    //NSString *dataStr = [NSString stringWithFormat:@"Pulse:%@, Oxygen:%@", [data objectForKey:@"Pulse"], [data objectForKey:@"Oxygen"]];
    NSString *dataStr = [NSString stringWithFormat:@"%@", [data objectForKey:@"Pulse"]];
    
    [_dataSentView setHidden:false];
    [_dataSentLabel setText:[NSString stringWithFormat:@"Sending... \"%@\"", dataStr]];
    [_roomManager sendDatachannelMessage:dataStr];
}

- (void)peripheralConnected {
    [_peripheralView setHidden:true];
    [peripheralDict removeAllObjects];
    peripheralArray = [peripheralDict allValues];

    [_peripheralTable reloadData];
}

- (void)peripheralDisconnected {
    [_bleManager stopBLE];
    [_dataSentLabel setText:@""];
    [_dataSentView setHidden:true];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [peripheralArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [[cell textLabel]setText:[[peripheralArray objectAtIndex:indexPath.row]name]];

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_bleManager connectToPeripheral:[peripheralArray objectAtIndex:indexPath.row]];
    [_peripheralStateLabel setText:@"Connecting to peripheral..."];
}

@end
