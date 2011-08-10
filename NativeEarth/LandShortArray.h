//
//  LandShortArray.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LandShortArray : NSMutableArray <NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController * fetchedResultsControllerShortLands_;
    NSManagedObjectContext * managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerShortLands;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *) context;



@end
