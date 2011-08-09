//
//  Land.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-05.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Land.h"
#import "Content.h"
#import "Greetings.h"
#import "PlannedVisit.h"


@implementation Land
@dynamic BoundaryW;
@dynamic LandDescriptionEnglish;
@dynamic LandName;
@dynamic BoundaryS;
@dynamic Shape;
@dynamic BoundaryN;
@dynamic Coordinates;
@dynamic CenterPoint;
@dynamic DateFrom;
@dynamic LandDescriptionFrench;
@dynamic VersionIdentifier;
@dynamic DateTo;
@dynamic BoundaryE;
@dynamic LandID;
@dynamic Maps;
@dynamic Greetings;
@dynamic PlannedVisits;
@dynamic Images;

- (void)addMapsObject:(Content *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Maps"] addObject:value];
    [self didChangeValueForKey:@"Maps" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMapsObject:(Content *)value {
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


- (void)addImagesObject:(Content *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Images"] addObject:value];
    [self didChangeValueForKey:@"Images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeImagesObject:(Content *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Images" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Images"] removeObject:value];
    [self didChangeValueForKey:@"Images" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addImages:(NSSet *)value {    
    [self willChangeValueForKey:@"Images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Images"] unionSet:value];
    [self didChangeValueForKey:@"Images" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeImages:(NSSet *)value {
    [self willChangeValueForKey:@"Images" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Images"] minusSet:value];
    [self didChangeValueForKey:@"Images" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
