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
#import "MessageApp.h"
#import <JSONModel/JSONModel.h>

@interface MessageSend : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *localId;
@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *to;
@property (nonatomic, strong) NSString<Optional> *body;
@property (nonatomic, strong) MessageApp<Optional> *app;
@property (nonatomic, strong) NSNumber<Optional> *timelineId;
@property (nonatomic, strong) NSString<Optional> *contentType;
@property (nonatomic, strong) NSNumber<Optional> *contentSize;
@property (nonatomic, strong) NSString<Optional> *contentUrl;
@property (nonatomic, strong) NSNumber<Optional> *timestamp;

@end
