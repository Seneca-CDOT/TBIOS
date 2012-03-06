//
//  PlannedVisit.m
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlannedVisit.h"
#import "Nation.h"


@implementation PlannedVisit
@dynamic Title;
@dynamic FromDate;
@dynamic Notes;
@dynamic ToDate;
@dynamic Nations;

- (void)addNationsObject:(Nation *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Nations"] addObject:value];
    [self didChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeNationsObject:(Nation *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Nations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Nations"] removeObject:value];
    [self didChangeValueForKey:@"Nations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addNations:(NSSet *)value {    
    [self willChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Nations"] unionSet:value];
    [self didChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeNations:(NSSet *)value {
    [self willChangeValueForKey:@"Nations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Nations"] minusSet:value];
    [self didChangeValueForKey:@"Nations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
