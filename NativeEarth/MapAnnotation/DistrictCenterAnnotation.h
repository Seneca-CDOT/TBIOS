//
//  DistrictCenterAnotation.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DistrictCenterAnnotation : NSObject <MKAnnotation>{
    CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;

    NSString * title;
    NSString * subTitle;
    
}
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


@property(nonatomic, retain) NSString * title;
@property(nonatomic, retain) NSString * subTitle;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
@end
