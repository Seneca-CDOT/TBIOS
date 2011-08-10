//
//  LocalLandGetter.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocalLandGetter.h"


@implementation LocalLandGetter
@synthesize fetchedResultsControllerLands=fetchedResultsControllerLands_, managedObjectContext=managedObjectContext_;


-(Land *)GetLandWithLandID:(int)landId{
    landID = landId;
    NSError *error;
    if(![[self fetchedResultsControllerLands]performFetch:&error]){
        //handle Error
    }
    
    NSArray * results = [self.fetchedResultsControllerLands fetchedObjects];
    if([results count]>0)
        return [results objectAtIndex:0];
    else
    return nil;
}
#pragma Mark -
#pragma Mark fetchedResultsController delegate method
-(NSFetchedResultsController *) fetchedResultsControllerLands {
    if(fetchedResultsControllerLands_ !=nil){
        return  fetchedResultsControllerLands_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Land" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"LandName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    // set predicate
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"LandID= %d", landID];
    [fetchedRequest setPredicate:predicate];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"Land"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Land"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsControllerLands = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return fetchedResultsControllerLands_;
}


@end
