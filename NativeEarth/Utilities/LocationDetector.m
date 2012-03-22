 //
//  LocationDetector.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationDetector.h"
#import "JSON.h"
#import <MapKit/MapKit.h>
#import "Utility.h"
#import "ReverseGeocoder.h"

@implementation LocationDetector
@synthesize locationManager;
@synthesize  nations;
@synthesize delegate;

-(id) init{
    self= [super init];
    if(self != nil){
        self.locationManager =[[[CLLocationManager alloc] init] autorelease];
        self.locationManager.desiredAccuracy =kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
       language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    }
    return self;
}
-(id) initWithRetrieveOption:(RetrieveOption) option{
    retriveFlag = option;
    return [self init];
}

-(void) dealloc{
    [nations release];
    [locationManager release];
    [super dealloc];
}


#pragma mark -
#pragma mark Delegate methods

// DELEGATE METHOD - handle a location update
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  
    if (abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120){
         
        [self.delegate locationUpdate:newLocation];
           // Turn off updating
        [self.locationManager stopUpdatingLocation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (retriveFlag == Network) {
            [self getNationsFromWebServiceForLocation:newLocation];
        }else 
            [self getNationsLocallyForLocation:newLocation];

    }  
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      if([self.delegate conformsToProtocol:@protocol(LocationDetectorDelegate)]) {  // Check if the class assigning 
    [self.delegate LocationError:error];
      }
}

#pragma mark - CoreData

-(void)getNationsLocallyForLocation:(CLLocation *)location{
    //must include language
    ReverseGeocoder * rgc = [[ReverseGeocoder alloc] init];
    //retrieve nearby nations
    self.nations=[rgc FindNearbyNationsForCoordinateWithLat:location.coordinate.latitude andLng:location.coordinate.longitude];
  if([self.delegate conformsToProtocol:@protocol(LocationDetectorDelegate)]) {  // Check if the class assigning 
    [self.delegate NationUpdate:self.nations];
  }


}

#pragma mark - Network Operations
-(void) getNationsFromWebServiceForLocation:(CLLocation *)location{
	//Here: we have to pass the location to the webservice:
    
    NSString *url = @"http://localhost/~ladan/AlgonquinOverLap";
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
    
}


//not used
//-(BOOL) GetFileWithID:(NSString*)fileID AndFormat:(NSString *)format FromData:(NSData*) data
//{
//   
//    // save file in documents directory
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];   
//
//    NSString *newFilePath = [documentsDirectory stringByAppendingFormat:@"%@.%@",fileID,format];
//
//   // NSFileManager *fileManager=[NSFileManager defaultManager];
//    NSError *error=[[[NSError alloc]init] autorelease];
//
//    BOOL response = [data writeToFile:newFilePath options:NSDataWritingFileProtectionNone error:&error];
//
//    return response;
//
//    }

#pragma mark - NetworkDataGetterDelegate
-(void)DataUpdate:(id) object{
   self.nations = (NSArray*) object;
      if([self.delegate conformsToProtocol:@protocol(LocationDetectorDelegate)]) {  // Check if the class assigning 
    [self.delegate NationUpdate:self.nations];
      }
}
-(void)DataError:(NSError*) error{
      if([self.delegate conformsToProtocol:@protocol(LocationDetectorDelegate)]) {  // Check if the class assigning 
    [self.delegate LocationError:error];
      }
}
@end
