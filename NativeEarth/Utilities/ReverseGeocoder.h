//
//  ReverseGeocoder.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface ReverseGeocoder : NSObject<NSFetchedResultsControllerDelegate> {
    @private
    double curLatitude;
    double curLongitude;
}

          

-(NSArray *) FindNearbyNationsForCoordinateWithLat:(double)lat andLng:(double) lng;

@end
