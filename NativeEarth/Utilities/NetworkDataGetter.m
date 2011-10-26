//
//  NetworkDataGetter.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkDataGetter.h"
#import "WSLand.h"
#import "JSON.h"
@implementation NetworkDataGetter

@synthesize dataArray;
@synthesize dataStream;
@synthesize delegate;


#pragma mark - Network operations
-(void) GetResultsFromUrl:(NSString*) serviceURL{
   
    // Prepare the NSMutableData receiver
    dataStream = [[NSMutableData alloc] init];
	
	// Create a URL // we should be able to pass language and locationManager.coordinate latitude and longitude here:
    
    NSURL *url = [NSURL URLWithString:serviceURL];
    
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
    
    
    //deal with 404 here
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
	
	// Load the response data string into the districts array
	
	 self.dataArray = [response JSONValue];
    if([self.delegate conformsToProtocol:@protocol(NetworkDataGetterDelegate)]) {  // Check if the class assigning 
       [self.delegate DataUpdate:self.dataArray];
     }
  
} 


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	// Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	  if([self.delegate conformsToProtocol:@protocol(NetworkDataGetterDelegate)]) {  // Check if the class assigning 
	[self.delegate DataError:error];
      }
}

-(void)dealloc{
    [self.dataStream release];
    [self.dataArray release];
    [super dealloc];
}


@end
