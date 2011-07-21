//
//  DistrictCenterAnotation.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DistrictCenterAnnotation.h"


@implementation DistrictCenterAnnotation

@synthesize   title;
@synthesize   subTitle;

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude {
	
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self;

}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}
@end
