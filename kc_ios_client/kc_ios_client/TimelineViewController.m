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

#import "TimelineViewController.h"
#import "VideocallViewController.h"
#import <kc_ios_communicator/CoreDataAccess.h>
#import <kc_ios_communicator/Constants.h>
#import <kc_ios_communicator/SendCommandService.h>
#import <kc_ios_pojo/MessageSend.h>

@interface TimelineViewController ()

@end

@implementation TimelineViewController

@synthesize messageBody;

static NSFetchedResultsController *_myFetchedResultsController;
static UserMe *me;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.prompt = NSLocalizedString(@"Messages", @"Messages");
    self.navigationItem.title = self.timeline.partyName;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    me = [CoreDataAccess readUserMe];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error %@", error.description);

        return;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
    if ([[_myFetchedResultsController sections]count]>0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:[[_myFetchedResultsController sections]count]-1];
        [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissKeyboard {
    [messageBody resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"roomSegue"]) {
        UserMe *me = [CoreDataAccess readUserMe];

        VideocallViewController *vc = [segue destinationViewController];
        [vc setTimeline: _timeline];
        [vc setUserName:[NSString stringWithFormat:@"%@%@", me.name, me.surname]];
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;

    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];

    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else
        frame.size.height -= keyboardBounds.size.width;

    // Apply new size of table view
    self.tableView.frame = frame;

    // Scroll the table view to see the TextField just above the keyboard
    CGRect textFieldRect = [self.tableView convertRect:self.messageBody.bounds fromView:self.messageBody];
    [self.tableView scrollRectToVisible:textFieldRect animated:NO];

    [self.messageView setFrame:CGRectMake(self.messageView.frame.origin.x, self.messageView.frame.origin.y-keyboardBounds.size.height, self.messageView.frame.size.width, self.messageView.frame.size.height)];

    if ([[_myFetchedResultsController sections]count]>0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:[[_myFetchedResultsController sections]count]-1];
        [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];

    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];

    // Increase size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else
        frame.size.height += keyboardBounds.size.width;

    // Apply new size of table view
    self.tableView.frame = frame;
    [self.messageView setFrame:CGRectMake(self.messageView.frame.origin.x, self.messageView.frame.origin.y+keyboardBounds.size.height, self.messageView.frame.size.width, self.messageView.frame.size.height)];

    [UIView commitAnimations];
}

#pragma mark TableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_myFetchedResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Message *message = [_myFetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [message body];
    if ([message.fromId isEqualToNumber:me.id]) {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    

    return cell;
}
#pragma mark -

#pragma mark FetchedResultsController methods
- (NSFetchedResultsController *)fetchedResultsController {
    NSManagedObjectContext *context = [CoreDataAccess getCoreDataContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:MESSAGE_ENTITY
                                   inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timelineId = %@", [self.timeline id]];
    [fetchRequest setPredicate:predicate];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:TIMESTAMP_KEY ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];

    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context
                                          sectionNameKeyPath:TIMESTAMP_KEY
                                                   cacheName:nil];

    _myFetchedResultsController = theFetchedResultsController;
    _myFetchedResultsController.delegate = self;

    return _myFetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.tableView reloadData];
    if ([[_myFetchedResultsController sections]count]>0) {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:[[_myFetchedResultsController sections]count]-1];
        [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
#pragma mark -

- (IBAction)sendMessageAction:(UIButton *)sender {
    if (![messageBody hasText]) {
        return;
    }

    [SendCommandService sendMessage:[messageBody text] toTimeline:self.timeline];

    [messageBody setText:@""];
}

@end
