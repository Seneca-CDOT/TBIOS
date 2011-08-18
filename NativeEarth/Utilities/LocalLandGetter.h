//
//  LocalLandGetter.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Land.h"
#import "LandShort.h"

@interface LocalLandGetter : NSObject <NSFetchedResultsControllerDelegate>{

    NSFetchedResultsController * fetchedResultsControllerLand_;
    NSFetchedResultsController * fetchedResultsControllerShortLands_;
    NSManagedObjectContext * managedObjectContext_;
    int landID;
}
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerLand;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerShortLands;

-(id) initWithManagedObjectContext:(NSManagedObjectContext* ) context;
-(Land *)GetLandWithLandID:(int)landId;
-(NSDictionary *)GetLandShortsDictionary;
@end
