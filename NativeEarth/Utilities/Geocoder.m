//
//  Geocoder.m
//
//  Created by Randall Brown on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Geocoder.h"
#import "NSString+URLEncoding.h"
#import "JSON.h"

@implementation Geocoder

@synthesize delegate;

-(void)getCoordinateForAddress:(NSString*)address
{
	NSString *escapedAddress = [address encodedURLString];
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", escapedAddress]]
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:60.0];
	
    	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
	NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
	if (theConnection) 
	{
		receivedData=[[NSMutableData alloc] init] ;
	} 
	
}

-(void)dealloc
{
	[receivedData release];
	[super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	NSString *dataString = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];

	NSDictionary *jsonDictionary = [dataString JSONValue];
	NSArray* results = [jsonDictionary objectForKey:@"results"];
  //  NSLog(@"%@",results);

    [delegate locationFound:results];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
@end
