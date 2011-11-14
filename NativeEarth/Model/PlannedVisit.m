//
//  PlannedVisit.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlannedVisit.h"
#import "Land.h"


@implementation PlannedVisit
@dynamic Title;
@dynamic FromDate;
@dynamic Notes;
@dynamic ToDate;
@dynamic Lands;

- (void)addLandsObject:(Land *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Lands" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Lands"] addObject:value];
    [self didChangeValueForKey:@"Lands" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeLandsObject:(Land *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Lands" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Lands"] removeObject:value];
    [self didChangeValueForKey:@"Lands" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addLands:(NSSet *)value {    
    [self willChangeValueForKey:@"Lands" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Lands"] unionSet:value];
    [self didChangeValueForKey:@"Lands" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeLands:(NSSet *)value {
    [self willChangeValueForKey:@"Lands" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Lands"] minusSet:value];
    [self didChangeValueForKey:@"Lands" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
