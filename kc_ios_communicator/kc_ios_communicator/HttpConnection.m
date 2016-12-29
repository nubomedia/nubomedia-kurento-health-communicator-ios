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
#import "HttpConnection.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "NSString+MD5.h"
#import "KeychainWrapper.h"

@implementation HttpConnection {
}

#pragma mark GET methods
+ (void)sendGetToUrl:(NSURL *)_url finishHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))finishHandler {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *urlBase = [NSString stringWithFormat:@"%@://%@:%@", [prefs objectForKey:SETTINGS_PROTOCOL], [prefs objectForKey:SETTINGS_URL], [prefs objectForKey:SETTINGS_PORT]];

    NSString *str = [[NSString alloc]initWithFormat:@"%@%@", urlBase, _url];
    NSURL *finalUrl = [[NSURL alloc]initWithString:str];

    NSLog(@"Send GET to url: %@", finalUrl);

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
    [manager setTaskDidReceiveAuthenticationChallengeBlock:authenticateRequest];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:finalUrl];
    [request setHTTPMethod:GET_HTTP_METHOD];
    [self addCookieToRequest:request];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            [self saveCookie:(NSHTTPURLResponse *)response];
        }

        finishHandler(response, responseObject, error);
    }];
    [dataTask resume];
}

#pragma mark-

#pragma mark POST methods

+ (void)sendPostToUrl:(NSURL *)_url withData:(NSMutableData *)_body finishHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))finishHandler {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *urlBase = [NSString stringWithFormat:@"%@://%@:%@", [prefs objectForKey:SETTINGS_PROTOCOL], [prefs objectForKey:SETTINGS_URL], [prefs objectForKey:SETTINGS_PORT]];

    NSString *str = [[NSString alloc]initWithFormat:@"%@%@", urlBase, _url];
    NSURL *finalUrl = [[NSURL alloc]initWithString:str];

    NSLog(@"Send POST to url: %@. With body: %@", finalUrl, [[NSString alloc]initWithData:_body encoding:NSUTF8StringEncoding]);

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
    [manager setTaskDidReceiveAuthenticationChallengeBlock:authenticateRequest];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:finalUrl];
    [request setHTTPMethod:POST_HTTP_METHOD];
    [request setHTTPBody:_body];
    [request setValue:JSON_TYPE forHTTPHeaderField:CONTENT_TYPE_HDR];
    [self addCookieToRequest:request];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            [self saveCookie:(NSHTTPURLResponse *)response];
        }
        
        finishHandler(response, responseObject, error);
    }];
    [dataTask resume];
}
#pragma mark-

#pragma mark Supporting methods
NSURLSessionAuthChallengeDisposition (^authenticateRequest)(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) = ^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengeUseCredential;
    if ([challenge previousFailureCount] == 0) {
        KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
        [keychain mySetObject:@"" forKey:(__bridge id)kSecAttrService];
        [keychain writeToKeychain];

        NSString *pass = [keychain myObjectForKey:(__bridge id)kSecValueData];
        NSString *user = [keychain myObjectForKey:(__bridge id)kSecAttrAccount];

        *credential = [NSURLCredential credentialWithUser:user
                                                 password:pass
                                              persistence:NSURLCredentialPersistenceForSession];

        [[challenge sender] useCredential:*credential forAuthenticationChallenge:challenge];
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }

    return disposition;
};

+ (void)addCookieToRequest:(NSMutableURLRequest *)request {
    KeychainWrapper *keychain = [[KeychainWrapper alloc] init];

    NSString *cookie = [keychain myObjectForKey:(__bridge id)kSecAttrService];

    if ([cookie isEqualToString:@""]) {
        return;
    }

    [request setValue:cookie forHTTPHeaderField:COOKIE_HDR];
}

+ (void)saveCookie:(NSHTTPURLResponse *)httpResponse {
    NSDictionary *headerDict = [httpResponse allHeaderFields];

    NSString *fullCookie = [headerDict objectForKey:@"Set-Cookie"];
    NSArray *components = [fullCookie componentsSeparatedByString: @";"];

    NSString *simpleCookie = (NSString*) [components objectAtIndex:0];
    if (simpleCookie == nil) {
        return;
    }

    KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
    [keychain mySetObject:simpleCookie forKey:(__bridge id)kSecAttrService];
    [keychain writeToKeychain];
}
#pragma mark -

@end
