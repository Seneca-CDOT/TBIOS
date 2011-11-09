//
//  StringUtility.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>
@interface Utility : NSObject {
    
}

+ (NSArray*) parseCoordinatesStringAsCLLocation:(NSString *) coordinates ;
+ (double) findNorthLatitudeForPoygonCoordinatesString: (NSString*)coordinates;
+ (double) findSouthLatitudeForPoygonCoordinatesString: (NSString*)coordinates;
+ (double) findEastLongitudeForPoygonCoordinatesString: (NSString*)coordinates;
+ (double) findWestLongitudeForPoygonCoordinatesString: (NSString*)coordinates;
+(NSDictionary *)findOuterRectInfoForPolygonWithCoordinatesString:(NSString*) coordinates;
@end

static CLLocationCoordinate2D * parseCoordinatesStringAsCLLocationCoordinate2D(NSString * coordinates, NSUInteger * Coords2DLengthOut){
    
    
    NSUInteger read = 0, space = 10;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * space);
    
    NSArray *tuples = [coordinates componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for (NSString *tuple in tuples) {
        if (read == space) {
            space *= 2;
            coords = realloc(coords, sizeof(CLLocationCoordinate2D) * space);
        }
        
        double lat, lon;
        NSScanner *scanner = [[NSScanner alloc] initWithString:tuple];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@","]];
        BOOL success = [scanner scanDouble:&lon];
        if (success) 
            success = [scanner scanDouble:&lat];
        if (success) {
            CLLocationCoordinate2D c = CLLocationCoordinate2DMake(lat, lon);
           if (CLLocationCoordinate2DIsValid(c))
                coords[read++] = c;
       
        }
        [scanner release];
    }
    
    *Coords2DLengthOut = read;
    return coords;
}
