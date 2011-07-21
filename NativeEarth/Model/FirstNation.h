//
//  FirstNation.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstNation : NSObject {
    CLLocationCoordinate2D coordinate;
    
    NSString *name;
    NSNumber *latitude;
    NSNumber *longitude; 
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

// the coordinate is a derived property based on the properties latitude and longitude.
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;
@end
////