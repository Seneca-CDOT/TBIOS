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
@synthesize dataStream;
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
    [dataStream release];
    [lands release];
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
        if (retriveFlag == Network) {
            [self getLandsFromWebServiceForLocation:newLocation];
        }else 
            [self getLandsLocallyForLocation:newLocation];
        
    }  
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.delegate LocationError:error];
}

#pragma mark - CoreData

-(void)getLandsLocallyForLocation:(CLLocation *)location{
    //must include language
    ReverseGeocoder * rgc = [[ReverseGeocoder alloc] init];
     rgc.managedObjectContext = managedObjectContext;
      self.lands= [rgc findLandForCoordinateWithLat:location.coordinate.latitude AndLng:location.coordinate.longitude];

    [self.delegate LandUpdate:self.lands];


}

#pragma mark - Network Operations
-(void) getLandsFromWebServiceForLocation:(CLLocation *)location{
	
	// Prepare the NSMutableData receiver
    dataStream = [[NSMutableData alloc] init];
	
	// Create a URL // we should be able to pass language and locationManager.coordinate latitude and longitude here:
	NSURL *url = [NSURL URLWithString:@"http://localhost/~ladan/Algonquin.txt"];// fake webservice URL
	//NSURL *url = [NSURL URLWithString:@"http://localhost/~ladan/SampleJSON.txt"];// fake webservice URL
	// Create a request
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
	// Create a connection
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    
	// Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	// Release the objects
    [request release];
	[connection release];
    
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// Implement this if you want
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// Append the incoming data to the data stream object
	[dataStream appendData:data]; 
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
	// Convert the data stream object to a string
	NSString *response = [[NSString alloc] initWithData:dataStream encoding:NSUTF8StringEncoding];
	
	
	// Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	// Load the response data string into the lands array
	
	self.lands = [response JSONValue];
//    for (NSDictionary*  lnd in lands) {
//        NSDictionary* greetings =[ dist valueForKey:@"Greetings"];
//        
//        [self GetFileWithID:[greetings valueForKey:@"HelloAudioID"] AndFormat:@"Wav" FromData:[greetings valueForKey:@"HelloAudioData"]];
//        [self GetFileWithID:[greetings valueForKey:@"WelcomeAudioID"] AndFormat:@"Wav" FromData:[greetings valueForKey:@"WelcomeAudioData"]];
//        [self GetFileWithID:[greetings valueForKey:@"GoodbyeAudioID"] AndFormat:@"Wav" FromData:[greetings valueForKey:@"GoodbyeAudioData"]];
//    }
//
    
      [self.delegate LandUpdate:self.lands];
    
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	// Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"%@", [error description]);
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


@end
