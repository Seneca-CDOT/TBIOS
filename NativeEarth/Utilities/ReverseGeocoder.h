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
#import <MapKit/MapKit.h>
@interface ReverseGeocoder : NSObject<NSFetchedResultsControllerDelegate> {
    @private
    double curLatitude;
    double curLongitude;
}

@property(nonatomic,retain)  MKMapView * mapView; 
          
- (NSArray *) FindEstimatedMatchingLandsForCoordinateWithLat:(double)lat AndLng: (double) lng;
- (NSArray *) FindLandForCoordinateWithLat:(double)lat AndLng:(double) lng; 
- (NSArray *) FindNearbyLandsForCoordinateWithLat:(double)lat andLng:(double) lng;

//helper methods
- (BOOL)PointWithLatitude: (double) lat AndLongitude:(double)lng BelongsToPolygonWithCoordinates:(NSArray*) coordinates;
- (BOOL)PointWithLatitude:(double)lat AndLongitude:(double)lng IsAVerticeOfPolygonWithCoordinates:(NSArray *)coordinates;
- (BOOL)PointWithLatitude:(double)lat AndLongitude:(double)lng IsOnASideOfMultyLineWithCoordinates:(NSArray *)coordinates;
-(double) DistanceOfPointCWithCLat: (double) cy AndCLng:(double) cx FromLineWithPointALat:(double) ay AndPointALng:(double) ax AndPointBLat:(double) by AndPointBLng:(double)bx;
-(double)KilometerDistanceOfPointAWithLat:(double)latA andLng:(double) lngA fromPointBWithLat:(double)latB andLng:(double)lngB;
-(double)DistanceOfPointCWithCLat:(double)cy AndCLng:(double)cx FromPolygonWithCoordinates:(NSArray *)coordinates;
-(double) RevisedDistanceOfPointC:(CLLocation*) C FromLineWithPointA:(CLLocation *) A AndPointB:(CLLocation*)B;
@end
