//
//  LocalLandGetter.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Land.h"

@interface LocalLandGetter : NSObject <NSFetchedResultsControllerDelegate>{

    NSFetchedResultsController * fetchedResultsControllerLands_;
    NSManagedObjectContext * managedObjectContext_;
    int landID;
}
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerLands;

-(Land *)GetLandWithLandID:(int)landId;

@end
