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

#import "SendRESTServices.h"
#import "HttpConnection.h"
#import "Constants.h"

@implementation SendRESTServices

+ (void)sendCommand:(NSString *)bodyString {
    NSString *url = [NSString stringWithFormat:@"%@", SEND_COMMAND_URL];

    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *data = [[NSMutableData alloc]initWithData:body];

    [HttpConnection sendPostToUrl:[NSURL URLWithString:url] withData:data finishHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Response %ld: %@", [httpResponse statusCode], responseObject);
    }];
}

@end
