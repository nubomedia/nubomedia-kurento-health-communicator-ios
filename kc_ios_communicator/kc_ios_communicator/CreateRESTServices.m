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


#import "CreateRESTServices.h"
#import "CoreDataAccess.h"
#import "UserMe.h"
#import "Constants.h"
#import <kc_ios_pojo/ChannelCreate.h>
#import <UIKit/UIKit.h>
#import "HttpConnection.h"
#import "OCMapper.h"

@implementation CreateRESTServices {
}

#pragma mark CREATE_CHANNEL
+ (void)createChannel:(void (^)(ChannelCreateResponse *channelResponse, NSInteger responseCode))completionHandler {
    UserMe *me = [CoreDataAccess readUserMe];
    
    //We must have one User_Me entity.
    if (!me) {
        NSLog(@"User_Me not found");
        
        return;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *channelInstanceId = [prefs objectForKey:APNS_TOKEN];
    
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    NSString *deviceId = [identifierForVendor UUIDString];
    
    ChannelCreate *channel = [[ChannelCreate alloc]init];
    [channel setUserId:[me id]];
    [channel setRegisterId:channelInstanceId];
    [channel setRegisterType:APNS_SERVICE];
    [channel setInstanceId:deviceId];
    [channel setLocale:[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0]];
    
    NSMutableDictionary *channelDict = [[NSMutableDictionary alloc]init];
    [channelDict setObject:[channel userId] forKey:USER_ID_KEY];
    [channelDict setObject:[channel registerId] forKey:REGISTER_ID_KEY];
    [channelDict setObject:[channel registerType] forKey:REGISTER_TYPE_KEY];
    [channelDict setObject:[channel instanceId] forKey:INSTANCE_ID_KEY];
    [channelDict setObject:[channel locale] forKey:LOCALE_KEY];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:channelDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSMutableData *data = [[NSMutableData alloc]initWithData:jsonData];
    
    [HttpConnection sendPostToUrl:[NSURL URLWithString:CREATE_CHANNEL_URL] withData:data finishHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Response %ld: %@", (long)[httpResponse statusCode], responseObject);
        
        ChannelCreateResponse *channelResponse = nil;
        if (!error) {            
            channelResponse = [ChannelCreateResponse objectFromDictionary:responseObject];
            [CoreDataAccess updateChannel:channelResponse];
        }
        
        completionHandler(channelResponse, [httpResponse statusCode]);
    }];
}
#pragma mark -

@end

