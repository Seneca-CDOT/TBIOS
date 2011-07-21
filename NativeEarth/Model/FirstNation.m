//
//  FirstNation.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstNation.h"


@implementation FirstNation

@synthesize name, latitude, longitude;
// Implementing this method ensures the Key-Value observers will be notified when the properties
// from which coordinate is derived have changed.
//
+ (NSSet *)keyPathsForValuesAffectingCoordinate
{
    return [NSSet setWithObjects:@"latitude", @"longitude", nil];
}

// derive the coordinate property.
- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = self.latitude.doubleValue;
    coordinate.longitude = self.longitude.doubleValue;
    return coordinate;
}

@end
