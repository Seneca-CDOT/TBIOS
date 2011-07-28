 //
//  Land.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Land.h"
#import "Content.h"
#import "Greetings.h"
#import "PlannedVisit.h"


@implementation Land
@dynamic BoundryW;
@dynamic Description;
@dynamic Name;
@dynamic BoundryS;
@dynamic Shape;
@dynamic BoundryN;
@dynamic Coordinates;
@dynamic CenterPoint;
@dynamic DateFrom;
@dynamic DateTo;
@dynamic BoundryE;
@dynamic LandID;
@dynamic VersionIdentifier;
@dynamic PlannedVisits;
@dynamic Greetings;
@dynamic Map;


//-(id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context WithDictionary:(NSDictionary *) landDict{
//
//    self=[super initWithEntity:entity insertIntoManagedObjectContext:context];
//    if (self) {
//        
//    [self setName:[landDict valueForKey:@"LandName"]];
//
//    self.Description = [landDict valueForKey:@"LandDescription"];
//    self.LandID = [landDict valueForKey:@"LandID"];
//    self.VersionIdentifier = [landDict valueForKey:@"VersionIdentifier"];
//    self.Shape = [landDict valueForKey:@"Shape"];
//    self.CenterPoint = [landDict valueForKey:@"CenterPoint"];
//    self.Coordinates = [landDict valueForKey:@"Coordinates"];
//    self.DateFrom = [landDict valueForKey:@"DateFrom"];
//    self.DateTo = [landDict valueForKey:@"DateTo"];
//    self.BoundryE= [landDict valueForKey:@"BoundryE"];
//    self.BoundryN=[landDict valueForKey:@"BoundryN"];
//    self.BoundryS = [landDict valueForKey:@"BoundryS"];
//    self.BoundryW =[landDict valueForKey:@"BoundryW"];
//    
//    NSDictionary * greetings = [landDict valueForKey:@"Greetings"];
//    self.Greetings =[[Greetings alloc] initWithDictionary:greetings ForLand:self];
//        
//    self.Map = nil;
//    }
//    return self;
//}

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
