//
//  Nation.m
//  NativeEarth
//
//  Created by Ladan Zahir on 12-04-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Nation.h"
#import "Greeting.h"
#import "Land.h"
#import "Map.h"
#import "PlannedVisit.h"


@implementation Nation
@dynamic CenterLat;
@dynamic Phone;
@dynamic Number;
@dynamic Address;
@dynamic CenterLong;
@dynamic CommunitySite;
@dynamic rowversion;
@dynamic OfficialName;
@dynamic PostCode;
@dynamic Province;
@dynamic Maps;
@dynamic Lands;
@dynamic greeting;
@dynamic PlannedVisits;

- (void)addMapsObject:(Map *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Maps"] addObject:value];
    [self didChangeValueForKey:@"Maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMapsObject:(Map *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Maps" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Maps"] removeObject:value];
    [self didChangeValueForKey:@"Maps" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMaps:(NSSet *)value {    
    [self willChangeValueForKey:@"Maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Maps"] unionSet:value];
    [self didChangeValueForKey:@"Maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMaps:(NSSet *)value {
    [self willChangeValueForKey:@"Maps" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Maps"] minusSet:value];
    [self didChangeValueForKey:@"Maps" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


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



- (void)addPlannedVisitsObject:(PlannedVisit *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"PlannedVisits" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"PlannedVisits"] addObject:value];
    [self didChangeValueForKey:@"PlannedVisits" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePlannedVisitsObject:(PlannedVisit *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"PlannedVisits" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"PlannedVisits"] removeObject:value];
    [self didChangeValueForKey:@"PlannedVisits" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPlannedVisits:(NSSet *)value {    
    [self willChangeValueForKey:@"PlannedVisits" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"PlannedVisits"] unionSet:value];
    [self didChangeValueForKey:@"PlannedVisits" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePlannedVisits:(NSSet *)value {
    [self willChangeValueForKey:@"PlannedVisits" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"PlannedVisits"] minusSet:value];
    [self didChangeValueForKey:@"PlannedVisits" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
