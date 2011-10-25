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
@synthesize  lands;
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
-(id) initWithRetrieveOption:(RetrieveOption) option WithManagedObjectContext:(NSManagedObjectContext *) context{
    managedObjectContext = context;
    retriveFlag = option;
    return [self init];
}

-(void) dealloc{
    [lands release];
    [locationManager release];
    [super dealloc];
}


#pragma mark -
#pragma mark Delegate methods

// DELEGATE METHOD - handle a location update
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.delegate locationUpdate:newLocation];
   // if (abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120){
        
           // Turn off updating
        [self.locationManager stopUpdatingLocation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (retriveFlag == Network) {
            [self getLandsFromWebServiceForLocation:newLocation];
        }else 
            [self getLandsLocallyForLocation:newLocation];
        
   // }  
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
      if([self.delegate conformsToProtocol:@protocol(LocationDetectorDelegate)]) {  // Check if the class assigning 
    [self.delegate LocationError:error];
      }
}

#pragma mark - CoreData

-(void)getLandsLocallyForLocation:(CLLocation *)location{
    //must include language
    ReverseGeocoder * rgc = [[ReverseGeocoder alloc] init];
    //  self.lands= [rgc FindLandForCoordinateWithLat:location.coordinate.latitude AndLng:location.coordinate.longitude];
    //retrieve nearby lands
    self.lands=[rgc FindNearbyLandsForCoordinateWithLat:location.coordinate.latitude andLng:location.coordinate.longitude];
  if([self.delegate conformsToProtocol:@protocol(LocationDetectorDelegate)]) {  // Check if the class assigning 
    [self.delegate LandUpdate:self.lands];
  }


}

#pragma mark - Network Operations
-(void) getLandsFromWebServiceForLocation:(CLLocation *)location{
	//Here: we have to pass the location to the webservice:
    
    NSString *url = @"http://localhost/~ladan/AlgonquinOverLap";
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
    
}



-(BOOL) GetFileWithID:(NSString*)fileID AndFormat:(NSString *)format FromData:(NSData*) data
{
   
    // save file in documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];   

    NSString *newFilePath = [documentsDirectory stringByAppendingFormat:@"%@.%@",fileID,format];

   // NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error=[[[NSError alloc]init] autorelease];

    BOOL response = [data writeToFile:newFilePath options:NSDataWritingFileProtectionNone error:&error];

    return response;

    }

#pragma mark - NetworkDataGetterDelegate
-(void)DataUpdate:(id) object{
   self.lands = (NSArray*) object;
      if([self.delegate conformsToProtocol:@protocol(LocationDetectorDelegate)]) {  // Check if the class assigning 
    [self.delegate LandUpdate:self.lands];
      }
}
-(void)DataError:(NSError*) error{
      if([self.delegate conformsToProtocol:@protocol(LocationDetectorDelegate)]) {  // Check if the class assigning 
    [self.delegate LocationError:error];
      }
}
@end
