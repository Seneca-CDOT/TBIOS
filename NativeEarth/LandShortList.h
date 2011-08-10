//
//  LandShortArray.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LandShortList : NSMutableArray <NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController * fetchedResultsControllerShortLands_;
    NSManagedObjectContext * managedObjectContext_;
    NSArray * array;
}
@property (nonatomic, retain) NSArray *array;
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerShortLands;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *) context;



@end
