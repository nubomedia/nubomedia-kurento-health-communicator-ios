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
#import "CoreDataAccess.h"
#import "CoreDataStack.h"
#import <CoreData/CoreData.h>
#import "Constants.h"

@implementation CoreDataAccess

static dispatch_queue_t queue;
static CoreDataStack *coreDataStack;

+ (void)init {
    queue = dispatch_queue_create("kurento.kc-ios-communicator", DISPATCH_QUEUE_SERIAL);
    coreDataStack = [CoreDataStack getInstance];
}

+ (NSManagedObjectContext *)getCoreDataContext {
    if (!queue) {
        [self init];
    }

    return [coreDataStack managedObjectContext];
}

+ (UserMe *)readUserMe {
    if (!queue) {
        [self init];
    }

    __block UserMe *user = nil;
    dispatch_barrier_sync(queue, ^{
        NSManagedObjectContext *context = [coreDataStack managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ME_ENTITY
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            user = nil;
        }

        if ([fetchedObjects count] > 0) {
            user = [fetchedObjects objectAtIndex:0];
        }
    });

    return user;
}

+ (void)readUserMe:(void(^)(UserMe *user))userRecoveredHandler {
    if (!queue) {
        [self init];
    }

    dispatch_barrier_sync(queue, ^{
        NSManagedObjectContext *context = [coreDataStack managedObjectContext];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ME_ENTITY
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        UserMe * user = nil;

        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            userRecoveredHandler(user);
        }

        if ([fetchedObjects count] != 0) {
            user = [fetchedObjects objectAtIndex:0];
        }
        userRecoveredHandler(user);
    });
}

+ (void)saveUserMe:(UserReadResponse *)user {
    if (!queue) {
        [self init];
    }

    dispatch_barrier_sync(queue, ^{
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator = [coreDataStack persistentStoreCoordinator];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ME_ENTITY
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Error %@", error.description);

            return;
        }

        // If entity UserMe doesn't exist, save it into database.
        if ([fetchedObjects count]==0) {
            UserMe *me = [NSEntityDescription insertNewObjectForEntityForName:USER_ME_ENTITY
                                                       inManagedObjectContext:context];
            [me setId:[user id]];
            [me setName:[user name]];
            [me setSurname:[user surname]];
            [me setPhone:[user phone]];
            [me setEmail:[user email]];
            [me setPicture:[user picture]];

            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Error %@", error.description);
            }
        }
    });
}

+ (void)updateChannel:(ChannelCreateResponse *)channel {
    if (!queue) {
        [self init];
    }

    dispatch_barrier_sync(queue, ^{
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator = [coreDataStack persistentStoreCoordinator];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ME_ENTITY
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Error %@", error.description);
            
            return;
        }

        if ([fetchedObjects count]==0) {
            NSLog(@"User_Me not found");

            return;
        }

        UserMe *me = [fetchedObjects objectAtIndex:0];
        [me setChannelId:[channel channelId]];

        NSError *error2 = nil;
        if (![context save:&error2]) {
            NSLog(@"Error %@", error2.description);
        }
    });
}

+ (void)updateGroup:(GroupUpdate *)groupUpdate {
    if (!queue) {
        [self init];
    }

    dispatch_barrier_sync(queue, ^{
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator = [coreDataStack persistentStoreCoordinator];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:GROUP_ENTITY
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"localId == %@", [groupUpdate localId]]];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Error %@", error.description);

            return;
        }

        Group *group = nil;
        if ([fetchedObjects count]>0) {
            group = [fetchedObjects objectAtIndex:0];
        } else {
            group = [NSEntityDescription insertNewObjectForEntityForName:GROUP_ENTITY
                                                  inManagedObjectContext:context];
        }

        if ([groupUpdate id] != nil) {
            [group setId:[groupUpdate id]];
        }
        if ([groupUpdate localId] != nil) {
            [group setLocalId:[groupUpdate localId]];
        }
        if ([groupUpdate name] != nil) {
            [group setName:[groupUpdate name]];
        }
        if ([groupUpdate canLeave]) {
            [group setCanLeave:[NSNumber numberWithBool:[groupUpdate canLeave]]];
        }
        if ([groupUpdate admin]) {
            [group setAdmin:[NSNumber numberWithBool:[groupUpdate admin]]];
        }

        [group setState:STATE_ACTIVE];

        NSError *error2 = nil;
        if (![context save:&error2]) {
            NSLog(@"Error %@", error2.description);
        }
    });
}

+ (void)updateTimeline:(TimelineReadResponse *)timelineUpdate {
    if (!queue) {
        [self init];
    }

    dispatch_barrier_sync(queue, ^{
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator = [coreDataStack persistentStoreCoordinator];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:TIMELINE_ENTITY
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"partyId == %@", [[timelineUpdate party]id]]];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Error %@", error.description);

            return;
        }

        Timeline *timeline = nil;
        if ([fetchedObjects count]>0) {
            timeline = [fetchedObjects objectAtIndex:0];
        }else{
            timeline = [NSEntityDescription insertNewObjectForEntityForName:TIMELINE_ENTITY
                                                     inManagedObjectContext:context];

            [timeline setMessagesToRead:[NSNumber numberWithInt:0]];
            [timeline setLastTimestamp:ZERO_NUMBER];
        }

        if ([timelineUpdate id] != nil) {
            [timeline setId:[timelineUpdate id]];
        }
        if ([timelineUpdate ownerId] != nil) {
            [timeline setOwnerId:[timelineUpdate ownerId]];
        }
        if ([[timelineUpdate party]id] != nil) {
            [timeline setPartyId:[[timelineUpdate party]id]];
        }
        if ([[timelineUpdate party]type] != nil) {
            [timeline setPartyType:[[timelineUpdate party]type]];
        }

        if ([[[timelineUpdate party]type]isEqualToString:GROUP_KEY]) {
            //Find group with this party id.
            NSEntityDescription *entity = [NSEntityDescription entityForName:GROUP_ENTITY
                                                      inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [[timelineUpdate party]id]]];
            NSError *error;
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (error) {
                NSLog(@"Error %@", error.description);

                return;
            }

            if ([fetchedObjects count] == 0) {
                NSLog(@"Group not found");

                return;
            }

            Group *group = [fetchedObjects objectAtIndex:0];
            [timeline setGroup:group];
            [group setTimeline:timeline];

        } else if ([[timeline partyType]isEqualToString:USER_KEY]) {
            //Find user with this party id.
            NSEntityDescription *entity = [NSEntityDescription entityForName:CONTACT_ENTITY
                                                      inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [[timelineUpdate party]id]]];
            NSError *error;
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (error) {
                NSLog(@"Error %@", error.description);

                return;
            }

            if ([fetchedObjects count] == 0) {
                NSLog(@"Contact not found");

                return;
            }

            Contact *contact = [fetchedObjects objectAtIndex:0];
            [timeline setContact:contact];
            [contact setTimeline:timeline];
        }

        if ([[timelineUpdate party]name] != nil) {
            [timeline setPartyName:[[timelineUpdate party]name]];
        }

        
        NSError *error2 = nil;
        if (![context save:&error2]) {
            NSLog(@"Error %@", error2.description);
        }
    });
}

+ (void)updateMessage:(MessageReadResponse *)messageUpdate {
    if (!queue) {
        [self init];
    }

    dispatch_barrier_sync(queue, ^{
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator = [coreDataStack persistentStoreCoordinator];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:MESSAGE_ENTITY
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"localId == %@", [messageUpdate localId]]];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Error %@", error.description);

            return;
        }

        Message *message = nil;
        if ([fetchedObjects count]>0) {
            message = [fetchedObjects objectAtIndex:0];
            if ([message id] == nil) {
                [self setMessage:message withResponse:messageUpdate];
            }
            [message setState:STATE_NEW_MINE];
        } else {
            message = [NSEntityDescription insertNewObjectForEntityForName:MESSAGE_ENTITY
                                                    inManagedObjectContext:context];
            [self setMessage:message withResponse:messageUpdate];
            [message setLocalId:[messageUpdate localId]];

            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ME_ENTITY
                                                      inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            NSError *error;
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (error) {
                NSLog(@"Error %@", error.description);

                return;
            }

            if ([fetchedObjects count] == 0) {
                NSLog(@"User_Me not found");

                return;
            }

            UserMe *me = [fetchedObjects objectAtIndex:0];
            if ([me id]==[message fromId]) {
                [message setState:STATE_NEW_MINE];
            } else {
                [message setState:STATE_NEW_OTHER];
            }
        }
        
        NSError *error2 = nil;
        if (![context save:&error2]) {
            NSLog(@"Error %@", error2.description);
        }

        [self updateTimeline:[message timelineId] withTimestamp:[message timestamp] withBody:[message body]];
    });
    
}

+ (void)setMessage:(Message *)message withResponse:(MessageReadResponse *)messageUpdate {
    [message setId:[messageUpdate id]];
    [message setTimestamp:[messageUpdate timestamp]];
    [message setFromId:[[messageUpdate from]id]];
    [message setFromName:[[messageUpdate from]name]];
    [message setFromSurname:[[messageUpdate from]surname]];
    [message setFromPicture:[[messageUpdate from]picture]];
    [message setTimelineId:[[messageUpdate timeline]id]];
    [message setBody:[messageUpdate body]];
    [message setContentId:[[messageUpdate content]id]];
    [message setContentType:[[messageUpdate content]contentType]];
    [message setContentSize:[[messageUpdate content]contentSize]];
}

+ (void)updateTimeline:(NSNumber *)timelineId withTimestamp:(NSNumber *)timestamp withBody:(NSString *)body {
    if (!queue) {
        [self init];
    }

    dispatch_barrier_async(queue, ^{
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator = [coreDataStack persistentStoreCoordinator];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:TIMELINE_ENTITY
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", timelineId]];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Error %@", error.description);

            return;
        }

        if ([fetchedObjects count] == 0) {
            return;
        }

        Timeline *timeline = [fetchedObjects objectAtIndex:0];
        [timeline setLastTimestamp:timestamp];
        [timeline setMessagesToRead:[NSNumber numberWithInt:[[timeline messagesToRead]intValue]+1]];
        [timeline setLastBody:body];

        //[coreDataStack saveContext];
        NSError *error2 = nil;
        if (![context save:&error2]) {
            NSLog(@"Error %@", error2.description);
        }
    });
}

+ (void)updateContact:(UserReadContactResponse *)contactUpdate {
    if (!queue) {
        [self init];
    }

    dispatch_barrier_sync(queue, ^{
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator = [coreDataStack persistentStoreCoordinator];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:CONTACT_ENTITY
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [contactUpdate id]]];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Error %@", error.description);

            return;
        }

        Contact *contact = nil;
        if ([fetchedObjects count]>0) {
            contact = [fetchedObjects objectAtIndex:0];
        }else{
            contact = [NSEntityDescription insertNewObjectForEntityForName:CONTACT_ENTITY
                                                    inManagedObjectContext:context];
        }

        if ([contactUpdate id] != nil) {
            [contact setId:[contactUpdate id]];
        }
        if ([contactUpdate name] != nil) {
            [contact setName:[contactUpdate name]];
        }
        if ([contactUpdate surname] != nil) {
            [contact setSurname:[contactUpdate surname]];
        }
        if ([contactUpdate phone] != nil) {
            [contact setPhone:[contactUpdate phone]];
        }

        NSError *error2 = nil;
        if (![context save:&error2]) {
            NSLog(@"Error %@", error2.description);
        }
    });
}

+ (void)deleteGroup:(GroupInfo *)group {
}

+ (void)addGroupMember:(GroupLeaveRequest *)group {
}

+ (void)addGroupAdmin:(GroupLeaveRequest *)group {
}

+ (void)removeGroupMember:(GroupLeaveRequest *)group {
}

+ (void)removeGroupAdmin:(GroupLeaveRequest *)group {
}

+ (void)deleteTimeline:(TimelineCreate *)timelineCreate {
}

+ (void)updateUser:(UserUpdate *)userUpdate {
}

+ (void)factoryReset {
}

@end
