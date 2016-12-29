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

#import "SendCommandService.h"
#import "Constants.h"
#import "SendRESTServices.h"
#import "UserMe.h"
#import "CoreDataAccess.h"
#import <kc_ios_pojo/MessageSend.h>
#import <kc_ios_pojo/CommandSend.h>

@implementation SendCommandService

#pragma mark sendMessageToGroup and sendMessageToUser
+ (void)sendMessage:(NSString *)message toTimeline:(Timeline *)timeline {
    MessageSend *messageSend = [self generateBaseMessage:message toTimeline:timeline];

    NSString *command = @"";
    if ([[timeline partyType]isEqualToString:GROUP_KEY]) {
        command = [self generateCommand:SEND_MESSAGE_TO_GROUP_METHOD withParams:messageSend];
    } else {
        command = [self generateCommand:SEND_MESSAGE_TO_USER_METHOD withParams:messageSend];
    }

    [SendRESTServices sendCommand:command];
}

+ (MessageSend *)generateBaseMessage:(NSString *)message toTimeline:(Timeline *)timeline {
    UserMe *me = [CoreDataAccess readUserMe];

    MessageSend *messageSend = [[MessageSend alloc]init];

    NSString *str = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
    NSArray *components = [str componentsSeparatedByString:@"."];
    NSString *localIdStr = [NSString stringWithFormat:@"%@%@", [components objectAtIndex:0], [components objectAtIndex:1]];
    NSNumber *localId = [NSNumber numberWithLongLong:localIdStr.longLongValue];

    [messageSend setLocalId:localId];
    [messageSend setFrom:[me id]];
    [messageSend setTo:[timeline partyId]];
    [messageSend setBody:message];

    return messageSend;
}

#pragma mark -

+ (NSString *)generateCommand:(NSString *)method  withParams:(id)params {
    UserMe *me = [CoreDataAccess readUserMe];

    //We must have one User_Me entity.
    if (me == nil) {
        NSLog(@"User_Me not found");

        return nil;
    }

    CommandSend *command = [[CommandSend alloc]init];
    [command setChannelId:[me channelId]];
    [command setMethod:method];
    [command setParams:params];

    NSString *str = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
    NSArray *components = [str componentsSeparatedByString:@"."];
    NSString *sequenceStr = [NSString stringWithFormat:@"%@%@", [components objectAtIndex:0], [components objectAtIndex:1]];
    NSNumber *sequence = [NSNumber numberWithInteger:[sequenceStr integerValue]];
    [command setSequenceNumber:sequence];

    return [command toJSONString];
}

@end
