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

#import "AppDelegate.h"
#import <kc_ios_communicator/Constants.h>
#import <kc_ios_communicator/CoreDataAccess.h>
#import <kc_ios_communicator/KeychainWrapper.h>

#import <kc_ios_communicator/ReadRESTServices.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Register for push notifications
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;

    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];

    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    NSString *settingsBundle = [[NSBundle mainBundle]pathForResource:SETTINGS_RESOURCE ofType:SETTINGS_TYPE];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:SETTINGS_PLIST]];

    NSArray *preferences = [settings objectForKey:SETTINGS_PREFERENCES];

    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:SETTINGS_KEY];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:SETTINGS_VALUE] forKey:key];
        }
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs registerDefaults:defaultsToRegister];
    [prefs synchronize];

    UserMe *me = [CoreDataAccess readUserMe];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = nil;
    if (me == nil) {
        viewController = [storyboard instantiateViewControllerWithIdentifier:CREDENTIALS_VIEW_ID];
    } else {
        viewController = [storyboard instantiateViewControllerWithIdentifier:INITIAL_TABBAR_ID];
    }

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *stringToken = [deviceToken description];
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@">" withString:@""];

    [prefs setObject:stringToken forKey:APNS_TOKEN];
    [prefs synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}


@end
