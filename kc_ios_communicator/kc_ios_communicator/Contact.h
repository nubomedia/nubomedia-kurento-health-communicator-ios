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
#import <CoreData/CoreData.h>

@class Avatar;
@class Timeline;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *surname;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *phoneRegion;
@property (nonatomic, retain) NSNumber *picture;
@property (nonatomic, retain) Avatar *avatar;
@property (nonatomic, retain) NSSet *adminGroups;
@property (nonatomic, retain) NSSet *memberGroups;
@property (nonatomic, retain) Timeline *timeline;

@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addAdminGroupsObject:(NSManagedObject *)value;
- (void)removeAdminGroupsObject:(NSManagedObject *)value;
- (void)addAdminGroups:(NSSet *)values;
- (void)removeAdminGroups:(NSSet *)values;

- (void)addMemberGroupsObject:(NSManagedObject *)value;
- (void)removeMemberGroupsObject:(NSManagedObject *)value;
- (void)addMemberGroups:(NSSet *)values;
- (void)removeMemberGroups:(NSSet *)values;

@end
