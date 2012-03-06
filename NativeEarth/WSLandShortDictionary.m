//
//  LandShortArray.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSLandShortDictionary.h"
#import "WSLandShort.h"

@implementation WSLandShortDictionary
#pragma Mark -
#pragma Mark Properties 
@synthesize fetchedResultsControllerShortLands=fetchedResultsControllerShortLands_, managedObjectContext=managedObjectContext_;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *) context{
    [super init];
    self.managedObjectContext = context;
    NSError *error;
    if(![[self fetchedResultsControllerShortLands]performFetch:&error]){
        //handle Error
    }
    NSArray * results =[self.fetchedResultsControllerShortLands fetchedObjects];
    int count = [results count];
    self = [[NSMutableDictionary alloc] initWithCapacity:count];
    if (self) {
    
    for (NSDictionary * land  in results) {
        LandShort * landShort = [[LandShort alloc] initWithDictionary:land];        
        [self setObject:landShort forKey:[NSString stringWithFormat:@"%d",[ landShort.landId intValue]]];
       
    }
    }
    [results release];
    return  self;
}

#pragma Mark -
#pragma Mark fetchedResultsController delegate method
-(NSFetchedResultsController *) fetchedResultsControllerShortLands {
    if(fetchedResultsControllerShortLands_ !=nil){
        return  fetchedResultsControllerShortLands_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Land" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"LandName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    // set expression
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression1 = [NSExpression expressionForKeyPath:@"LandID"];
      // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription1 = [[NSExpressionDescription alloc] init];
    [expressionDescription1 setName:@"LandID"];
    [expressionDescription1 setExpression:keyPathExpression1];
    [expressionDescription1 setExpressionResultType:NSInteger32AttributeType];
    
    // NSExpression *keyPathExpression2 = [NSExpression expressionForKeyPath:@"LandName"];
    NSExpressionDescription *expressionDescription2 = [[NSExpressionDescription alloc] init];
    [expressionDescription2 setName:@"LandName"];
    [expressionDescription2 setExpression:keyPathExpression1];
    [expressionDescription2 setExpressionResultType:NSInteger32AttributeType];

    
    
    // NSExpression *keyPathExpression3 = [NSExpression expressionForKeyPath:@"VersionIdentifier"];
    NSExpressionDescription *expressionDescription3 = [[NSExpressionDescription alloc] init];
    [expressionDescription3 setName:@"VersionIdentifier"];
    [expressionDescription3 setExpression:keyPathExpression1];
    [expressionDescription3 setExpressionResultType:NSInteger32AttributeType];


    
    // Set the request's properties to fetch just the property represented by the expressions.
    [fetchedRequest setPropertiesToFetch:[NSArray arrayWithObjects:expressionDescription1,expressionDescription2,expressionDescription3, nil]];

    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"ShortLand"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"ShortLand"];
    aFetchedResultsController.delegate = self;
    
    self.fetchedResultsControllerShortLands = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return fetchedResultsControllerShortLands_;
}

@end
