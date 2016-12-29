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

#import <kc_ios_pojo/UserReadResponse.h>
#import <kc_ios_pojo/ChannelCreateResponse.h>
#import <kc_ios_pojo/GroupUpdate.h>
#import <kc_ios_pojo/TimelineReadResponse.h>
#import <kc_ios_pojo/MessageReadResponse.h>
#import <kc_ios_pojo/UserReadContactResponse.h>
#import <kc_ios_pojo/GroupInfo.h>
#import <kc_ios_pojo/GroupLeaveRequest.h>
#import <kc_ios_pojo/TimelineCreate.h>
#import <kc_ios_pojo/UserUpdate.h>
#import "Avatar.h"
#import "Command.h"
#import "Contact.h"
#import "Group.h"
#import "Message.h"
#import "Thumbnail.h"
#import "Timeline.h"
#import "UserMe.h"

@interface CoreDataAccess : NSObject

+ (NSManagedObjectContext *)getCoreDataContext;
+ (UserMe *)readUserMe;
+ (void)readUserMe:(void(^)(UserMe *user))userRecoveredHandler;
+ (void)saveUserMe:(UserReadResponse *)user;
+ (void)updateChannel:(ChannelCreateResponse *)channel;
+ (void)updateGroup:(GroupUpdate *)groupUpdate;
+ (void)updateTimeline:(TimelineReadResponse *)timelineUpdate;
+ (void)updateMessage:(MessageReadResponse *)messageUpdate;
+ (void)updateContact:(UserReadContactResponse *)contactUpdate;
+ (void)deleteGroup:(GroupInfo *)group;
+ (void)addGroupMember:(GroupLeaveRequest *)group;
+ (void)addGroupAdmin:(GroupLeaveRequest *)group;
+ (void)removeGroupMember:(GroupLeaveRequest *)group;
+ (void)removeGroupAdmin:(GroupLeaveRequest *)group;
+ (void)deleteTimeline:(TimelineCreate *)timelineCreate;
+ (void)updateUser:(UserUpdate *)userUpdate;
+ (void)factoryReset;

@end
