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

#import "AgendaViewController.h"
#import <kc_ios_communicator/CoreDataAccess.h>
#import <kc_ios_communicator/Constants.h>
#import <kc_ios_communicator/Group.h>
#import <kc_ios_communicator/Contact.h>
#import "AgendaTableViewCell.h"
#import "TimelineViewController.h"

@implementation AgendaViewController

static NSFetchedResultsController *_fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error %@", error.description);

        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"agendaToTimelineSegue"]) {
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
    static NSString *CellIdentifier = @"agendaCell";

    AgendaTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AgendaTableViewCell alloc]init];
    }

    if ([_segmentedControl selectedSegmentIndex] == 0) {
        Group *group = [_fetchedResultsController objectAtIndexPath:indexPath];
        [[cell nameLabel]setText:[group name]];
    } else {
        Contact *contact = [_fetchedResultsController objectAtIndexPath:indexPath];
        [[cell nameLabel]setText:[NSString stringWithFormat:@"%@ %@", [contact name], [contact surname]]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![[_fetchedResultsController objectAtIndexPath:indexPath]timeline]) {
        NSLog(@"No timeline found");
    } else {
        [self performSegueWithIdentifier:@"agendaToTimelineSegue" sender:[[_fetchedResultsController objectAtIndexPath:indexPath]timeline]];
    }
}
#pragma mark -

#pragma mark FetchedResultsController methods
- (NSFetchedResultsController *)fetchedResultsController {
    _fetchedResultsController = nil;

    NSManagedObjectContext *context = [CoreDataAccess getCoreDataContext];
    NSFetchedResultsController *theFetchedResultsController = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    if ([_segmentedControl selectedSegmentIndex] == 0) {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:GROUP_ENTITY
                                       inManagedObjectContext:context];
        [fetchRequest setEntity:entity];

        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:NAME_KEY
                                  ascending:YES
                                  selector:@selector(localizedCaseInsensitiveCompare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        [fetchRequest setFetchBatchSize:20];

        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"state != %@", STATE_DELETED]];

        theFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:NAME_KEY
                                                       cacheName:nil];

        _fetchedResultsController = theFetchedResultsController;
        _fetchedResultsController.delegate = self;
    } else {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:CONTACT_ENTITY
                                       inManagedObjectContext:context];
        [fetchRequest setEntity:entity];

        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:NAME_KEY
                                  ascending:YES
                                  selector:@selector(localizedCaseInsensitiveCompare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        [fetchRequest setFetchBatchSize:20];

        theFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:NAME_KEY
                                                       cacheName:nil];

        _fetchedResultsController = theFetchedResultsController;
        _fetchedResultsController.delegate = self;
    }

    return _fetchedResultsController;
}
#pragma mark -

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error %@", error.description);

        return;
    }

    [_tableView reloadData];
}

@end
