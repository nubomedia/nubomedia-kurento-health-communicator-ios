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

#import "RegisterViewController.h"
#import <kc_ios_communicator/Constants.h>
#import <kc_ios_communicator/NSString+MD5.h>
#import <kc_ios_pojo/UserCreate.h>
#import <kc_ios_communicator/UserRESTServices.h>
#import "UIView+Toast.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

#define OFFSET_PADDING 5
#define OFFSET_TOP_VIEW 64

@synthesize nameTextField, surnameTextField, emailTextField, phoneTextField, passwordTextField, repeatPasswordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)registerButtonAction:(UIBarButtonItem *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *autoregister = [prefs objectForKey:ACCOUNT_USER_AUTOREGISTER_KEY];
    if (!autoregister) {        
        [self.view makeToast:@"Wait for account info title"
                    duration:2.0
                    position:CSToastPositionBottom];
        
        return;
    }
    
    if ([autoregister isEqual: @"0"]) {
        [self.view makeToast:NSLocalizedString(@"User autoregister error title", @"")
                    duration:2.0
                    position:CSToastPositionBottom];
        
        return;
    }
    
    if (![self checkMandatoryFields]) {
        [self.view makeToast:NSLocalizedString(@"Field blank error title", @"")
                    duration:2.0
                    position:CSToastPositionBottom];
        
        return;
    }
    
    if (![self checkPassword]) {
        [self.view makeToast:NSLocalizedString(@"Wrong password title", @"")
                    duration:2.0
                    position:CSToastPositionBottom];
        
        return;
    }
    
    UserCreate *newUser = [[UserCreate alloc]init];
    [newUser setPassword:[[passwordTextField text]MD5String]];
    [newUser setName:[nameTextField text]];
    [newUser setEmail:[emailTextField text]];
    
    NSString *surname = [[surnameTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (([surname length]!=0)) {
        [newUser setSurname:[surnameTextField text]];
    }
    
    NSString *phone = [[phoneTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (([phone length]!=0)) {
        [newUser setPhone:[phoneTextField text]];
        [newUser setPhoneRegion:PHONE_REGION_ES];
    }
    
    [UserRESTServices userAutoregister:newUser completionHandler:^(NSNumber *userId, NSString *errorCode) {
        if (userId) {
            [self.view makeToast:@"User created successfully"
                        duration:2.0
                        position:CSToastPositionBottom];
            [self cleanUserData];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.view makeToast:errorCode
                        duration:2.0
                        position:CSToastPositionBottom];
        }
    }];
}

- (BOOL)checkMandatoryFields {
    NSString *password = [[passwordTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordRepeated = [[repeatPasswordTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *name = [[nameTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [[emailTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return (([password length]!=0) &&
            ([passwordRepeated length]!=0) &&
            ([name length]!=0) &&
            ([email length]!=0));
}

- (BOOL)checkPassword {
    return [[passwordTextField text]isEqualToString:[repeatPasswordTextField text]];
}

- (IBAction)cancelButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissKeyboard {
    [passwordTextField resignFirstResponder];
    [repeatPasswordTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    [surnameTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
}

- (void)cleanUserData {
    [passwordTextField setText:@""];
    [nameTextField setText:@""];
    [surnameTextField setText:@""];
    [phoneTextField setText:@""];
    [emailTextField setText:@""];
    [repeatPasswordTextField setText:@""];
}

@end
