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
#import <UIKit/UIKit.h>
#import "kc_ios_communicator/Timeline.h"

@interface VideocallViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *peersCollectionView;
@property (weak, nonatomic) IBOutlet UIView *mainVideoContainerView;
@property (weak, nonatomic) UIView *mainVideoView;
@property (nonatomic, strong) Timeline *timeline;
@property (nonatomic, strong) NSString *userName;

@property (weak, nonatomic) IBOutlet UIView *peripheralView;
@property (weak, nonatomic) IBOutlet UITableView *peripheralTable;
@property (weak, nonatomic) IBOutlet UILabel *peripheralStateLabel;

@property (weak, nonatomic) IBOutlet UIView *dataSentView;
@property (weak, nonatomic) IBOutlet UILabel *dataSentLabel;

- (IBAction)attachBLE:(UIBarButtonItem *)sender;
- (IBAction)cancelBLE:(UIButton *)sender;

@end
