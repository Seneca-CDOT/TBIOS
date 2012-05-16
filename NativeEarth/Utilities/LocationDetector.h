//
//  LocationDetector.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "NetworkDataGetter.h"

typedef enum {
	Locally,
	Network
} RetrieveOption;

@protocol LocationDetectorDelegate <NSObject>
@required
-(void)locationUpdate:(CLLocation *)location;
-(void)LocationError:(NSError *)error;
-(void)NationUpdate:(NSArray *)nations;
@end

@interface LocationDetector : NSObject<CLLocationManagerDelegate,NetworkDataGetterDelegate> {
  CLLocationManager *locationManager; 
  id delegate;
    RetrieveOption retriveFlag;
    NSString * language;
}



//Array of land Results
@property (nonatomic, retain) NSArray *nations;
// retrives data from webservice


@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id delegate;


-(void)getNationsLocallyForLocation:(CLLocation *)location;
-(id) initWithRetrieveOption:(RetrieveOption) option;

@end

