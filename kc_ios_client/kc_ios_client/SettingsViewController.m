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

#import "SettingsViewController.h"
#import <kc_ios_communicator/Constants.h>

@implementation SettingsViewController {
    UITapGestureRecognizer *tap;
    UITextField *activeField;
}

@synthesize serverLabel, protocolLabel, protocolField, addressLabel, addressTextField, portLabel, portTextField;
@synthesize userLabel, accountLabel, accountTextField, maxMessagesLabel, maxMessagesTextField, maxSpaceLabel, maxSpaceTextField;
@synthesize saveButton, scrollView;

#define OFFSET_TOP_VIEW 64
#define OFFSET_PADDING 5

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *protocolSelected = (NSString *)[prefs objectForKey:SETTINGS_PROTOCOL];
    if ([protocolSelected isEqualToString:HTTPS_PROTOCOL]) {
        [protocolField setSelectedSegmentIndex:1];
    } else {
        [protocolField setSelectedSegmentIndex:0];
    }

    [serverLabel setText:NSLocalizedString(@"Server Preferences", @"Server Preferences")];
    [protocolLabel setText:NSLocalizedString(@"Protocol", @"Protocol")];
    [addressLabel setText:NSLocalizedString(@"Address", @"Address")];
    [addressTextField setText:[prefs objectForKey:SETTINGS_URL]];
    [portLabel setText:NSLocalizedString(@"Port", @"Port")];
    [portTextField setText:[prefs objectForKey:SETTINGS_PORT]];
    [userLabel setText:NSLocalizedString(@"User Preferences", @"User Preferences")];
    [accountLabel setText:NSLocalizedString(@"Account", @"Account")];
    [accountTextField setText:[prefs objectForKey:SETTINGS_ACCOUNT]];
    [maxMessagesLabel setText:NSLocalizedString(@"Max messages", @"Max. number of messages in memory. 0 means infinite.")];
    [maxMessagesTextField setText:[prefs objectForKey:SETTINGS_MAX_MESSAGES]];
    [maxSpaceLabel setText:NSLocalizedString(@"Max space", @"Max. space to save content. 0 means infinite.")];
    [maxSpaceTextField setText:[prefs objectForKey:SETTINGS_MAX_SPACE]];
    [saveButton setTitle:NSLocalizedString(@"Save", @"Save") forState:UIControlStateNormal];

    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)saveButtonAction:(UIButton *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    if([protocolField selectedSegmentIndex] == 0) {
        [prefs setObject:HTTP_PROTOCOL forKey:SETTINGS_PROTOCOL];
    } else {
        [prefs setObject:HTTPS_PROTOCOL forKey:SETTINGS_PROTOCOL];
    }

    [prefs setObject:[addressTextField text] forKey:SETTINGS_URL];
    [prefs setObject:[portTextField text] forKey:SETTINGS_PORT];
    [prefs setObject:[accountTextField text] forKey:SETTINGS_ACCOUNT];
    [prefs setObject:[maxMessagesTextField text] forKey:SETTINGS_MAX_MESSAGES];
    [prefs setObject:[maxSpaceTextField text] forKey:SETTINGS_MAX_SPACE];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Keyboard Control Action

- (void)dismissKeyboard {
    [addressTextField resignFirstResponder];
    [portTextField resignFirstResponder];
    [accountTextField resignFirstResponder];
    [maxMessagesTextField resignFirstResponder];
    [maxSpaceTextField resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    if (!activeField) {
        return;
    }

    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;

    if ([activeField.superview convertPoint:activeField.frame.origin toView:nil].y + activeField.frame.size.height >= aRect.size.height) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];

        CGRect scrolledFrame = self.scrollView.frame;

        scrolledFrame.origin.y -= ([activeField.superview convertPoint:activeField.frame.origin toView:nil].y + activeField.frame.size.height - aRect.size.height) + OFFSET_PADDING;
        self.scrollView.frame = scrolledFrame;

        [UIView commitAnimations];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];

    CGRect scrolledFrame = self.scrollView.frame;

    scrolledFrame.origin.y = self.view.bounds.origin.y + OFFSET_TOP_VIEW;
    self.scrollView.frame = scrolledFrame;

    [UIView commitAnimations];
}

#pragma mark -

#pragma mark TextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

@end
