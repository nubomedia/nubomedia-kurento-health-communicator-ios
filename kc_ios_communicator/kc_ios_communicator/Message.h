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
@class Thumbnail;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSNumber *localId;
@property (nonatomic, retain) NSNumber *timestamp;
@property (nonatomic, retain) NSNumber *fromId;
@property (nonatomic, retain) NSString *fromName;
@property (nonatomic, retain) NSString *fromSurname;
@property (nonatomic, retain) NSNumber *fromPicture;
@property (nonatomic, retain) NSNumber *timelineId;
@property (nonatomic, retain) NSString *timelineName;
@property (nonatomic, retain) NSString *timelineType;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSNumber *contentId;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSNumber *contentSize;
@property (nonatomic, retain) NSString *contentUrl;
@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) NSString *appPayload;
@property (nonatomic, retain) NSNumber *uploaded;
@property (nonatomic, retain) NSNumber *downloaded;
@property (nonatomic, retain) Avatar *avatar;
@property (nonatomic, retain) Thumbnail *thumbnail;
@property (nonatomic, retain) NSString *state;

@end
