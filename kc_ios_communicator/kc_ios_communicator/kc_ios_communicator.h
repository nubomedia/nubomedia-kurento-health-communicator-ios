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

#import <UIKit/UIKit.h>

//! Project version number for kc_ios_communicator.
FOUNDATION_EXPORT double kc_ios_communicatorVersionNumber;

//! Project version string for kc_ios_communicator.
FOUNDATION_EXPORT const unsigned char kc_ios_communicatorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <kc_ios_communicator/PublicHeader.h>

#import <kc_ios_communicator/Constants.h>
#import <kc_ios_communicator/KeychainWrapper.h>
#import <kc_ios_communicator/CoreDataAccess.h>
#import <kc_ios_communicator/ReadRESTServices.h>
#import <kc_ios_communicator/UserRESTServices.h>
#import <kc_ios_communicator/CreateRESTServices.h>
#import <kc_ios_communicator/NSString+MD5.h>
#import <kc_ios_communicator/WebSocket.h>
#import <kc_ios_communicator/SendCommandService.h>
#import <kc_ios_communicator/RoomManager.h>
#import <kc_ios_communicator/BLEManager.h>
