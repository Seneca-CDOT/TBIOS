//
//  DataCreator.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCreator.h"


@implementation DataCreator


-(void) createData:(NSManagedObjectContext *)context{
    NSString *kmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"kml"];
    kml = [[KMLParser parseKMLAtPath:kmlPath] retain];
   
    NSArray* coordsArray = [kml OuterCoordsStringArray];
    NSArray *overlays = [kml overlays];
    
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"District" inManagedObjectContext:context];
    
          int i=0;   
    for (MKPolygon* polygon in overlays) {
        
        
        NSString * districtName = polygon.title;
        NSString * districtDescription = polygon.subtitle;
        NSString * districtCoordinates =  [[coordsArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
     //   double northLat = [Utility findNorthLatitudeForPoygonCoordinatesString:districtCoordinates]; 
     //   double southLat=[Utility findSouthLatitudeForPoygonCoordinatesString:districtCoordinates];
     //   double westLng=[Utility findWestLongitudeForPoygonCoordinatesString:districtCoordinates];
     //   double eastLng =[Utility findEastLongitudeForPoygonCoordinatesString:districtCoordinates];
       
        NSDictionary * rectInfo = [Utility findOuterRectInfoForPolygonWithCoordinatesString:districtCoordinates];
		NSNumber* north = [rectInfo objectForKey:@"NORTH"];
        NSNumber* south =[rectInfo objectForKey:@"SOUTH"];
        NSNumber* east = [rectInfo objectForKey:@"EAST"];
        NSNumber* west =[rectInfo objectForKey:@"WEST"];
        
        NSManagedObject * district= [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
		
        // Configure it
		
        [district  setValue:districtName forKey:@"DistrictName"];
        [district  setValue:districtDescription forKey:@"Description"];
		
        [district  setValue:districtCoordinates forKey:@"Coordinates"];
		
        
        [district  setValue:north forKey:@"North"];
        [district  setValue:south forKey:@"South"];
        [district  setValue:west forKey:@"West"];
        [district  setValue:east forKey:@"East"];

        
	    NSError *error;
		// Save it
		if (![context save:&error]) {
			NSLog(@"Context save error %@, %@", error, [error userInfo]);
			abort();
		}

        
       
        i++;
    }// end of for
    
   

   
//  NSString* filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"csv"];
// NSString* fileContents = [NSString stringWithContentsOfFile:filePath];
 
}


@end
