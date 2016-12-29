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
#import <CoreData/CoreData.h>

@class Command;

@interface OrderedCommands : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *commandsOrdered;
@end

@interface OrderedCommands (CoreDataGeneratedAccessors)

- (void)insertObject:(Command *)value inCommandsOrderedAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommandsOrderedAtIndex:(NSUInteger)idx;
- (void)insertCommandsOrdered:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommandsOrderedAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommandsOrderedAtIndex:(NSUInteger)idx withObject:(Command *)value;
- (void)replaceCommandsOrderedAtIndexes:(NSIndexSet *)indexes withCommandsOrdered:(NSArray *)values;
- (void)addCommandsOrderedObject:(Command *)value;
- (void)removeCommandsOrderedObject:(Command *)value;
- (void)addCommandsOrdered:(NSOrderedSet *)values;
- (void)removeCommandsOrdered:(NSOrderedSet *)values;

@end
