//
//  Utility+CLLocation.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#define  ERM  6378137 //earth radious in m 
#define RAD_TO_DEG(r) ((r) * (180 / M_PI))
#define DEG_TO_RAD(d) (((d) * M_PI)/180)
@interface CLLocation (Utility)
- (CLLocationDirection)directionToLocation:(CLLocation *)location;
- (CLLocation *) destinationWithDistance:(CLLocationDistance) distance andDirection:(CLLocationDirection) direction;
- (CLLocationDistance)distanceFromPathWithStartPoint:(CLLocation *)startPoint andEndPoint :(CLLocation*)endPoint;

@end
