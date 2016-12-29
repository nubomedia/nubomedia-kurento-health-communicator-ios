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

#import "VideocallPeerViewCell.h"

@implementation VideocallPeerViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    self.peerLabel.text = @"";
    self.layer.cornerRadius = self.bounds.size.height/4;
    [self.fullScreenImage setHidden:true];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setPeerName:(NSString *)peer {
    self.peerLabel.text = peer;
}

- (void)setVideoView:(UIView *)videoView {
    if (!videoView) {
        [self hideCellSubview:self.videoView];
        return;
    } else if (_videoView != videoView) {
        [_videoView removeFromSuperview];
        _videoView = videoView;
        _videoView.frame = self.bounds;

        [self.containerView insertSubview:_videoView belowSubview:_peerLabel];
        [self showCellSubview:_videoView];
    }
}

- (void)showCellSubview:(UIView *)subView {
    subView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        subView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)hideCellSubview:(UIView *)subView {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        subView.transform = CGAffineTransformMakeScale(0.01, 0.01);;
    } completion:^(BOOL finished) {
        [subView removeFromSuperview];
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [_videoView removeFromSuperview];
    _videoView = nil;
    self.peerLabel.text = @"";
}

@end
