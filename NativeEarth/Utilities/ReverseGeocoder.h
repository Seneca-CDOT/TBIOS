//
//  ReverseGeocoder.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"
#include <math.h>

@interface ReverseGeocoder : NSObject<NSFetchedResultsControllerDelegate> {
    @private
    NSFetchedResultsController * fetchedResultsController_;
    NSManagedObjectContext * managedObjectContext_;
    double curLatitude;
    double curLongitude;
}
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsController;


- (NSArray *) findNearByLandsForPointWithLat:(double)lat AndLng: (double) lng;
- (NSArray *) findLandForCoordinateWithLat:(double)lat AndLng:(double) lng; 
//helper methods
- (BOOL)PointWithLatitute: (double) lat AndLongitute:(double)lng BelongsToPolygonWithCoordinates:(NSArray*) coordinates;
- (BOOL)PointWithLatitute:(double)lat AndLongitute:(double)lng IsAVerticeOfPolygonWithCoordinates:(NSArray *)coordinates;
- (BOOL)PointWithLatitute:(double)lat AndLongitute:(double)lng IsOnASideOfMultyLineWithCoordinates:(NSArray *)coordinates;
-(double) DistanceOfPointCWithCLat: (double) cy AndCLng:(double) cx FromLineWithPointALat:(double) ay AndPointALng:(double) ax AndPointBLat:(double) by AndPointBLng:(double)bx;

@end
