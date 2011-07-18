//
//  StringUtility.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

typedef enum {
	ParsAsCLLocationArray = 0,
	ParsAsCLLocationCoordinate2DArray = 1,
} CoordinateStringParsingOption;

@implementation Utility

+ (NSArray*) parseCoordinatesStringAsCLLocation:(NSString *) coordinates {
    coordinates = [coordinates stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray* pointStrings = [coordinates  componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray* points = [[NSMutableArray alloc] initWithCapacity:pointStrings.count]; 

    for(int i = 0; i < pointStrings.count; i++)
    {
        // break the string down even further to latitude and longitude fields. 
        NSString* currentPointString = [pointStrings objectAtIndex:i];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        CLLocationDegrees lng  = [[latLonArr objectAtIndex:0] doubleValue];
        
        CLLocationDegrees lat = [[latLonArr objectAtIndex:1] doubleValue];
        
        //	NSString *latStr = [latLonArr objectAtIndex:1];
        CLLocation* point = [[[CLLocation alloc] initWithLatitude:lat longitude:lng] autorelease];
        
        [points addObject:point];
    }
    return  points;
}


#pragma Mark -
#pragma Mark Polygon Rect Info

+ (double) findNorthLatitudeForPoygonCoordinatesString: (NSString*)coordinates
{
    coordinates = [coordinates stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray* pointStrings = [coordinates  componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray *latArray =[NSMutableArray arrayWithCapacity:[pointStrings count]];
    for(int i = 0; i < pointStrings.count; i++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:i];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
        [latArray addObject:[latLonArr objectAtIndex:1]];
	}
	double northLat= [[latArray objectAtIndex:0] doubleValue] ;
    for (int j=1; j< [latArray count]; j++) {
        if(northLat<[[latArray objectAtIndex:j] doubleValue])
            northLat=[[latArray objectAtIndex:j] doubleValue];
    }
    return northLat + 0.00001;
}


+ (double) findSouthLatitudeForPoygonCoordinatesString: (NSString*)coordinates
{
    coordinates = [coordinates stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray* pointStrings = [coordinates  componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
   
    NSMutableArray *latArray =[NSMutableArray arrayWithCapacity:[pointStrings count]];
    for(int i = 0; i < pointStrings.count; i++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:i];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
        [latArray addObject:[latLonArr objectAtIndex:1]];		
	}
	double southLat= [[latArray objectAtIndex:0] doubleValue] ;
    for (int j=1; j< [latArray count]; j++) {
        if(southLat>[[latArray objectAtIndex:j] doubleValue])
            southLat=[[latArray objectAtIndex:j] doubleValue];
    }
    return southLat- 0.00001;

}


+ (double) findEastLongitudeForPoygonCoordinatesString: (NSString*)coordinates
{
    coordinates = [coordinates stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray* pointStrings = [coordinates  componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *lngArray =[NSMutableArray arrayWithCapacity:[pointStrings count]];
    
    for(int i = 0; i < pointStrings.count; i++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:i];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
		[lngArray addObject:[latLonArr objectAtIndex:0]];
	}
    
    double eastLng= [[lngArray objectAtIndex:0] doubleValue] ;
    for (int j=1; j< [lngArray count]; j++) {
        if(eastLng<[[lngArray objectAtIndex:j] doubleValue])
            eastLng=[[lngArray objectAtIndex:j] doubleValue];
    }
    return eastLng +0.00001;


}


+ (double) findWestLongitudeForPoygonCoordinatesString: (NSString*)coordinates
{
    
    coordinates = [coordinates stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray* pointStrings = [coordinates  componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *lngArray =[NSMutableArray arrayWithCapacity:[pointStrings count]];
    

    for(int i = 0; i < pointStrings.count; i++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:i];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
		[lngArray addObject:[latLonArr objectAtIndex:0]];	
	}
    double westLng= [[lngArray objectAtIndex:0] doubleValue] ;
    for (int j=1; j< [lngArray count]; j++) {
        if(westLng>[[lngArray objectAtIndex:j] doubleValue])
           westLng=[[lngArray objectAtIndex:j] doubleValue];
    }
    return westLng - 0.00001;
   
    
}

+(NSDictionary *)findOuterRectInfoForPolygonWithCoordinatesString:(NSString*) coordinates{
    
    coordinates = [coordinates stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray* pointStrings = [coordinates  componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *latArray =[NSMutableArray arrayWithCapacity:[pointStrings count]];
    NSMutableArray *lngArray =[NSMutableArray arrayWithCapacity:[pointStrings count]];
    
        
    for(int i = 0; i < pointStrings.count; i++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:i];
		NSArray* latLngArray = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
		[lngArray addObject:[latLngArray objectAtIndex:0]];
        [latArray addObject:[latLngArray objectAtIndex:1]];
	}
    
    double westLng= [[lngArray objectAtIndex:0] doubleValue] ;
    double eastLng= [[lngArray objectAtIndex:0] doubleValue];
    double northLat = [[latArray objectAtIndex:0]doubleValue];
    double southLat = [[latArray objectAtIndex:0]doubleValue];
    
    for (int j=1; j< [pointStrings count]; j++) {
        double curLng = [[lngArray objectAtIndex:j] doubleValue];
        double curLat = [[latArray objectAtIndex:j] doubleValue];
        
        if(westLng>curLng)
            westLng= curLng;        
        if(eastLng <curLng) 
            eastLng =curLng;
        if(northLat<curLat)
            northLat= curLat;
        if(southLat>curLat)
            southLat = curLat;
        
    }
    
    NSNumber * west = [NSDecimalNumber numberWithDouble:westLng- 0.00001];
    NSNumber * east = [NSNumber numberWithDouble:eastLng + 0.00001];
    NSNumber * north = [NSNumber numberWithDouble:northLat +0.00001];
    NSNumber * south = [NSNumber numberWithDouble:southLat - 0.00001];
    
    NSDictionary * infoDict = [[NSDictionary alloc]initWithObjectsAndKeys:west, @"WEST", east, @"EAST", north, @"NORTH", south, @"SOUTH", nil];

    return infoDict;
}

@end
