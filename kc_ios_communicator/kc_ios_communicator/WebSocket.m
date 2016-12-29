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

#import "WebSocket.h"
#import "Constants.h"
#import "CoreDataAccess.h"
#import "WebSocket.h"
#import <kc_ios_pojo/WebSocketRequest.h>
#import <kc_ios_pojo/WebSocketResponse.h>
#import "OCMapper.h"
#import "UserMe.h"
#import "ReadRESTServices.h"

@implementation WebSocket {
    SRWebSocket *srWebSocket;
}

static WebSocket *instanceWS;
static int ident = 0;

+ (void)initializeWS {
    UserMe *me = [CoreDataAccess readUserMe];
    //We must have one User_Me entity.
    if (!me) {
        NSLog(@"User_Me not found");

        return;
    }

    if (instanceWS == nil) {
        instanceWS = [[WebSocket alloc]init];
    }
}

+ (void)closeWS {
    if (instanceWS == nil) {
        return;
    }

    [instanceWS close];
    instanceWS = nil;
}

- (WebSocket *)init {
    if (srWebSocket != nil) {
        [srWebSocket close];
        srWebSocket.delegate = nil;
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *urlBase = [NSString stringWithFormat:@"%@://%@:%@", [prefs objectForKey:SETTINGS_PROTOCOL], [prefs objectForKey:SETTINGS_URL], [prefs objectForKey:SETTINGS_PORT]];

    NSString *str = [[NSString alloc]initWithFormat:@"%@%@", urlBase, WEBSOCKET_URL];

    srWebSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    srWebSocket.delegate = self;

    [srWebSocket open];

    return self;
}

- (void)close {
    if (srWebSocket != nil) {
        [srWebSocket close];
        [srWebSocket setDelegate:nil];
    }
}

#pragma mark SRWebSocketDelegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSString *messageRecv = [NSString stringWithFormat:@"%@", message];
    NSData *messageData = [messageRecv dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error;
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:messageData options:0 error:&error];

    if (error) {
        NSLog(@"JSON parsing error");
        return;
    }

    WebSocketResponse *wsResponse = [WebSocketResponse objectFromDictionary:dictResponse];

    if ([wsResponse result]) {
        [self parseResultResponse:[wsResponse result]];
    } else if ([wsResponse error]){
        [self parseErrorResponse:[wsResponse error]];
    } else {
        [self parseReceivedMessage:wsResponse];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    UserMe *me = [CoreDataAccess readUserMe];
    //We must have one User_Me entity.
    if (!me) {
        NSLog(@"User_Me not found");

        return;
    }

    ident ++;

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[me channelId] forKey:CHANNEL_ID_KEY];

    WebSocketRequest *webSocketReq = [[WebSocketRequest alloc]init];
    [webSocketReq setId:[NSNumber numberWithInt:ident]];
    [webSocketReq setJsonrpc:JSONRPC_VERSION];
    [webSocketReq setMethod:JSONRPC_METHOD_REGISTER];
    [webSocketReq setParams:params];

    NSData *jsonData = [webSocketReq toJSONData];
    [srWebSocket send:[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Websocket closed. Code: %ld, Reason: %@, Clean:%@", (long)code, reason, wasClean?@"YES":@"NO");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Websocket error %@", error.description);
}
#pragma mark -

- (void)parseResultResponse:(WebSocketResponseResult *)wsResponseResult {
}

- (void)parseErrorResponse:(WebSocketResponseResult *)wsResponseError {
    if ([[wsResponseError code]isEqualToString:JSONRPC_CODE_PARSE_ERROR]) {
        //Code parse error.
        //TODO: Manage error.
    } else {
        //Other error.
        //TODO: Manage error.
    }
}

- (void)parseReceivedMessage:(WebSocketResponse *)wsResponse {
    if ([[wsResponse method]isEqualToString:JSONRPC_METHOD_SYNC]) {
        WebSocketResponseResult *ackResult = [[WebSocketResponseResult alloc]init];
        [ackResult setCode:JSONRPC_CODE_OK];

        WebSocketResponse *ackResponse = [[WebSocketResponse alloc]init];
        [ackResponse setId:[wsResponse id]];
        [ackResponse setJsonrpc:JSONRPC_VERSION];
        [ackResponse setResult:ackResult];

        NSData *jsonData = [ackResponse toJSONData];
        [srWebSocket send:[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]];

        [ReadRESTServices readCommand:^(NSError *error) {
            if (error) {
                NSLog(@"Error reading commands... %@", error);
            }
        }];
    }
}

@end
