//
//  Utility+CLLocation.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CLLocation (Utility)
- (CLLocationDirection)directionToLocation:(CLLocation *)location;
- (CLLocation *) destinationWithDistance:(CLLocationDistance) distance andDirection:(CLLocationDirection) direction;
- (CLLocationDistance)distanceFromPathWithStartPoint:(CLLocation *)startPoint andEndPoint :(CLLocation*)endPoint;
- (CLLocation *) destinationWithDistance:(CLLocationDistance) distance andDirection:(CLLocationDirection) direction;
@end
