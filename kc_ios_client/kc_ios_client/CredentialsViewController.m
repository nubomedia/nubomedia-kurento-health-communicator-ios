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

#import "CredentialsViewController.h"
#import <kc_ios_communicator/ReadRESTServices.h>
#import <kc_ios_communicator/CreateRESTServices.h>
#import <kc_ios_communicator/Constants.h>
#import <kc_ios_communicator/KeychainWrapper.h>
#import <kc_ios_communicator/NSString+MD5.h>
#import "UIView+Toast.h"

@interface CredentialsViewController ()

@end

@implementation CredentialsViewController

@synthesize nameField, passField, enterButton, settingsButton, registerLabel, registerButton, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    [nameField setPlaceholder:NSLocalizedString(@"Email", @"Email")];
    [passField setPlaceholder:NSLocalizedString(@"Password", @"Password")];
    [enterButton setTitle:NSLocalizedString(@"Log in", @"Log in") forState:UIControlStateNormal];
    [registerLabel setText:NSLocalizedString(@"Register text", @"Don't you have an account?")];
    [registerButton setTitle:NSLocalizedString(@"Register", @"Register") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self readAccountInfo];
}

- (void)dismissKeyboard {
    [nameField resignFirstResponder];
    [passField resignFirstResponder];
}

- (void)readAccountInfo {
    [self enableView:false];

    [ReadRESTServices readAccountInfo:^(AccountReadInfoResponse *account, NSInteger responseCode) {
        if (account == nil) {
            [self showWrongAccountAlert];
        } else {
            [self enableView:true];
        }
    }];
}

- (void)showWrongAccountAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Account error title", @"Account Error") message:NSLocalizedString(@"Account error message", @"You need an account to continue") preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Accept", @"Accept") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:alert.textFields.firstObject.text forKey:SETTINGS_ACCOUNT];
        
        [prefs synchronize];

        [self readAccountInfo];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", @"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"settingsSegue" sender:self];
    }];

    [alert addAction:action1];
    [alert addAction:action2];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:NSLocalizedString(@"Account", @"Account")];
    }];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)enableView:(BOOL)enable {
    [enterButton setHidden:!enable];
    [nameField setEnabled:enable];
    [passField setEnabled:enable];
    [settingsButton setEnabled:enable];
    [registerButton setEnabled:enable];
    [activityIndicator setHidden:enable];
}

- (IBAction)settingsButtonAction:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

- (IBAction)enterButtonAction:(UIButton *)sender {
    [self enableView:false];

    KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
    [keychain resetKeychain];

    [keychain mySetObject:[[[self passField]text]MD5String] forKey:(__bridge id)kSecValueData];

    [keychain mySetObject:[[self nameField]text] forKey:(__bridge id)kSecAttrAccount];
    [keychain writeToKeychain];

    [ReadRESTServices readMe:^(UserReadResponse *user, NSInteger responseCode) {
        if (user != nil) {
            [CreateRESTServices createChannel:^(ChannelCreateResponse *channelResponse, NSInteger responseCode) {
                if (channelResponse != nil) {
                    [self performSegueWithIdentifier:@"initialSegue" sender:self];
                } else {
                    [self.view makeToast:@"Channel registration failed"
                                duration:2.0
                                position:CSToastPositionBottom];
                }
            }];
        } else {
            [self.view makeToast:@"Login user failed"
                        duration:2.0
                        position:CSToastPositionBottom];
        }

        [self enableView:true];
    }];
}

@end
