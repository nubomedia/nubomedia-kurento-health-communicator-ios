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

#import "TimelineListViewController.h"
#import <kc_ios_communicator/Constants.h>
#import <kc_ios_communicator/ReadRESTServices.h>
#import <kc_ios_communicator/Timeline.h>
#import <kc_ios_communicator/CoreDataAccess.h>
#import <kc_ios_communicator/WebSocket.h>
#import "TimelineViewController.h"
#import "TimelineListTableViewCell.h"

@implementation TimelineListViewController

static NSFetchedResultsController *_fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];

    [WebSocket initializeWS];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *lastSequence = [prefs objectForKey:LASTSEQUENCE_KEY];
    if (!lastSequence) {
        [prefs setObject:SEQUENCE_NUMBER_0 forKey:LASTSEQUENCE_KEY];
        [prefs synchronize];

        [ReadRESTServices readCommand:^(NSError *error) {
            if (error) {
                NSLog(@"Error %@", error);
            }
        }];
    } else {
        [ReadRESTServices readCommand:^(NSError *error) {
            if (error) {
                NSLog(@"Error %@", error);
            }
        }];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error %@", error.description);

        return;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:TIMELINE_SEGUE]) {
        TimelineViewController *vc = [segue destinationViewController];
        [vc setTimeline:sender];
        [vc setHidesBottomBarWhenPushed:YES];
    }
}

#pragma mark TableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"timelineListCell";

    TimelineListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TimelineListTableViewCell alloc]init];
    }

    Timeline *timeline = [_fetchedResultsController objectAtIndexPath:indexPath];
    [cell setName:[timeline partyName] lastMessage:[timeline lastBody] timestamp:[timeline lastTimestamp]];
    
    if ([timeline contact] != nil) {
        [[cell avatarView]setImage:[UIImage imageNamed:@"ic_profile"]];
    } else {
        [[cell avatarView]setImage:[UIImage imageNamed:@"ic_group"]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self performSegueWithIdentifier:TIMELINE_SEGUE sender:[_fetchedResultsController objectAtIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //TODO: Send deleteTimeline
    }
}

#pragma mark -

#pragma mark FetchedResultsController methods
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSManagedObjectContext *context = [CoreDataAccess getCoreDataContext];
    NSFetchedResultsController *theFetchedResultsController = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:TIMELINE_ENTITY
                                   inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:LAST_TIMESTAMP_KEY
                              ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];

    theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context
                                          sectionNameKeyPath:LAST_TIMESTAMP_KEY
                                                   cacheName:nil];

    _fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;

    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    [self.tableView reloadData];
}
#pragma mark -

@end
