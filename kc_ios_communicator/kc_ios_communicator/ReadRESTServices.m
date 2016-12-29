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

#import "ReadRESTServices.h"
#import "HTTPConnection.h"
#import "Constants.h"
#import "OCMapper.h"
#import "CoreDataAccess.h"
#import <kc_ios_pojo/CommandReadResponse.h>
#import <kc_ios_pojo/GroupUpdate.h>
#import <kc_ios_pojo/TimelineReadResponse.h>
#import <kc_ios_pojo/MessageReadResponse.h>
#import <kc_ios_pojo/UserReadContactResponse.h>
#import <kc_ios_pojo/GroupInfo.h>
#import <kc_ios_pojo/GroupLeaveRequest.h>
#import <kc_ios_pojo/TimelineCreate.h>
#import <kc_ios_pojo/UserUpdate.h>
#import "KeychainWrapper.h"

@implementation ReadRESTServices {
}

#pragma mark READ_ME
+ (void)readMe:(void (^)(UserReadResponse *user, NSInteger responseCode))completionHandler {
    [HttpConnection sendGetToUrl:[NSURL URLWithString:READ_ME_URL] finishHandler:^
     (NSURLResponse *response, id responseObject, NSError *error) {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         NSLog(@"Response %ld: %@", (long)[httpResponse statusCode], responseObject);

         UserReadResponse *userResponse = nil;
         if (!error) {
             KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
             [keychain resetKeychain];

             userResponse = [[UserReadResponse alloc]initWithDictionary:responseObject error:&error];
             if (error) {
                 completionHandler(nil, [httpResponse statusCode]);
                 return;
             }

             [CoreDataAccess saveUserMe:userResponse];
         }

         completionHandler(userResponse, [httpResponse statusCode]);
     }];
}
#pragma mark -

#pragma mark READ_ACCOUNT_INFO
+ (void)readAccountInfo:(void (^)(AccountReadInfoResponse *account, NSInteger responseCode))completionHandler {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", READ_ACCOUNT_URL, [prefs objectForKey:SETTINGS_ACCOUNT], INFO_URL];

    [HttpConnection sendGetToUrl:[NSURL URLWithString:url] finishHandler:^
     (NSURLResponse *response, id responseObject, NSError *error) {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         NSLog(@"Response %ld: %@", (long)[httpResponse statusCode], responseObject);
         
         AccountReadInfoResponse *accountRead = nil;
         if (!error) {
             KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
             [keychain resetKeychain];

             accountRead = [[AccountReadInfoResponse alloc]initWithDictionary:responseObject error:&error];
             if (error) {
                 completionHandler(nil, [httpResponse statusCode]);
                 return;
             }

             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:[[NSString alloc]initWithFormat:@"%@", [accountRead id]] forKey:SETTINGS_ACCOUNT];
             [prefs setObject:[accountRead name] forKey:ACCOUNT_NAME_KEY];
             [prefs setBool:[accountRead userAutoregister] forKey:ACCOUNT_USER_AUTOREGISTER_KEY];
             [prefs setBool:[accountRead groupAutoregister] forKey:ACCOUNT_GROUP_AUTOREGISTER_KEY];

             [prefs synchronize];
         }

         completionHandler(accountRead, [httpResponse statusCode]);
     }];
}
#pragma mark -

#pragma mark READ_COMMAND
+ (void)readCommand:(void (^)(NSError *error))completionHandler {
    UserMe *me = [CoreDataAccess readUserMe];

    //We must have one User_Me entity.
    if (!me) {
        NSLog(@"User_Me not found");

        return;
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *lastSequence = [prefs objectForKey:LASTSEQUENCE_KEY];
    if (!lastSequence) {
        lastSequence = SEQUENCE_NUMBER_0;
    }

    NSString *stringUrl = [[NSString alloc]initWithFormat:@"%@?channelId=%@&lastSequence=%@", READ_COMMAND_URL, [me channelId], lastSequence];

    [HttpConnection sendGetToUrl:[NSURL URLWithString:stringUrl] finishHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Response %ld", (long)[httpResponse statusCode]);

        if (!error) {
            NSArray *jsonArray = (NSArray *)responseObject;
            for (int i=0; i<jsonArray.count; i++) {
                NSDictionary *commandDict = (NSDictionary *)[jsonArray objectAtIndex:i];

                CommandReadResponse *command = [CommandReadResponse objectFromDictionary:commandDict];
                command.params = [commandDict objectForKey:PARAMS_KEY];
                
                [self executeCommand:command];
            }

            completionHandler(nil);
        } else {
            NSLog(@"Error %@", error);
            completionHandler(error);
        }
    }];
}

+ (void)executeCommand:(CommandReadResponse *)command {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[prefs objectForKey:LASTSEQUENCE_KEY]integerValue] >= [[command sequenceNumber]integerValue]) {
        //If the command we have received is already executed, don't execute it again.
        return;
    }
    [prefs setObject:[command sequenceNumber] forKey:LASTSEQUENCE_KEY];
    [prefs synchronize];

    if ([[command method]isEqualToString:UPDATE_GROUP_METHOD]) {
        GroupUpdate *groupUpdate = [GroupUpdate objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess updateGroup:groupUpdate];
    } else if ([[command method]isEqualToString:UPDATE_TIMELINE_METHOD]) {
        TimelineReadResponse *timeline = [TimelineReadResponse objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess updateTimeline:timeline];
    } else if ([[command method]isEqualToString:UPDATE_MESSAGE_METHOD]) {
        MessageReadResponse *messageUpdate = [MessageReadResponse objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess updateMessage:messageUpdate];
    } else if ([[command method]isEqualToString:UPDATE_CONTACT_METHOD]) {
        UserReadContactResponse *userUpdate = [UserReadContactResponse objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess updateContact:userUpdate];
    } else if ([[command method]isEqualToString:DELETE_GROUP_METHOD]) {
        GroupInfo *group = [GroupInfo objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess deleteGroup:group];
    } else if ([[command method]isEqualToString:ADD_GROUP_MEMBER_METHOD]) {
        GroupLeaveRequest *group = [GroupLeaveRequest objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess addGroupMember:group];
    } else if ([[command method]isEqualToString:ADD_GROUP_ADMIN_METHOD]) {
        GroupLeaveRequest *group = [GroupLeaveRequest objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess addGroupAdmin:group];
    } else if ([[command method]isEqualToString:REMOVE_GROUP_MEMBER_METHOD]) {
        GroupLeaveRequest *group = [GroupLeaveRequest objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess removeGroupMember:group];
    } else if ([[command method]isEqualToString:REMOVE_GROUP_ADMIN_METHOD]) {
        GroupLeaveRequest *group = [GroupLeaveRequest objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess removeGroupMember:group];
    } else if ([[command method]isEqualToString:DELETE_TIMELINE_METHOD]) {
        TimelineCreate *timeline = [TimelineCreate objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess deleteTimeline:timeline];
    } else if ([[command method]isEqualToString:UPDATE_USER_METHOD]) {
        UserUpdate *user = [UserUpdate objectFromDictionary:(NSDictionary *)[command params]];
        [CoreDataAccess updateUser:user];
    } else if ([[command method]isEqualToString:FACTORY_RESET_METHOD]) {
        [CoreDataAccess factoryReset];
    }
}
#pragma mark -

@end
