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
	Network,
} RetrieveOption;
@protocol LocationDetectorDelegate <NSObject>

@required

-(void)locationUpdate:(CLLocation *)location;
-(void)LocationError:(NSError *)error;
-(void)LandUpdate:(NSArray *)lands;

@end

@interface LocationDetector : NSObject<CLLocationManagerDelegate,NetworkDataGetterDelegate> {
  CLLocationManager *locationManager; 
  id delegate;
    RetrieveOption retriveFlag;
    NSManagedObjectContext * managedObjectContext;
    NSString * language;
}


// The network response data stream
//@property (nonatomic, retain) NSMutableData *dataStream;
//Array of land Results
@property (nonatomic, retain) NSArray *lands;
// retrives data from webservice


@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id delegate;

-(void)getLandsFromWebServiceForLocation:(CLLocation *)location;
-(void)getLandsLocallyForLocation:(CLLocation *)location;
-(id) initWithRetrieveOption:(RetrieveOption) option WithManagedObjectContext:(NSManagedObjectContext *) context ;
//saves Audio files from web service responce data
-(BOOL) GetFileWithID:(NSString*)fileID AndFormat:(NSString *)format FromData:(NSData*) data;
@end

