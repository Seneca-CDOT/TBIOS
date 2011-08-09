//
//  DataCreator.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCreator.h"
#import "Land.h"
#import "WSLand.h"
@implementation DataCreator

-(id) initWithContext:(NSManagedObjectContext*) context{
    [super init];
    managedObjectContext = context;
    return self;
}

-(void) createDataFromKML{
    NSString *kmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"kml"];
    kml = [[KMLParser parseKMLAtPath:kmlPath] retain];
   
    NSArray* coordsArray = [kml OuterCoordsStringArray];
    NSArray *overlays = [kml overlays];
    
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Land" inManagedObjectContext:managedObjectContext];
    
          int i=0;   
    for (MKPolygon* polygon in overlays) {
        
        
        NSString * landName = polygon.title;
        NSString * landDescription = polygon.subtitle;
        NSString * landCoordinates =  [[coordsArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
       
        NSDictionary * rectInfo = [Utility findOuterRectInfoForPolygonWithCoordinatesString:landCoordinates];
		NSNumber* north = [rectInfo objectForKey:@"NORTH"];
        NSNumber* south =[rectInfo objectForKey:@"SOUTH"];
        NSNumber* east = [rectInfo objectForKey:@"EAST"];
        NSNumber* west =[rectInfo objectForKey:@"WEST"];
        
        Land * land= [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
		
        // Configure it
        
        land.LandName = landName;
        land.LandDescriptionEnglish = landDescription;
        land.Coordinates = landCoordinates;
        land.BoundaryN = north;
        land.BoundaryS = south;
        land.BoundaryE = east;
        land.BoundaryW = west;
        land.Shape = @"Polygon";
        land.VersionIdentifier=[NSNumber numberWithInt: 1];
        
	    NSError *error;
		// Save it
		if (![managedObjectContext save:&error]) {
			NSLog(@"Context save error %@, %@", error, [error userInfo]);
			abort();
		}
       
        i++;
    }// end of for
    
 
}

-(void) createDataFromWebServive{
   NSString * urlString = @"http://localhost/~ladan/AlgonquinOverLap";
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc] init];
    dataGetter.delegate = self;
    [dataGetter GetResultsFromUrl:urlString];
}

-(void)DataUpdate:(id)object{
    NSError *error;
    NSArray * landArray = (NSArray*)object;
    for (NSDictionary * landDict  in landArray) {
        WSLand *wsland = [[WSLand alloc] initWithDictionary:landDict];
        [wsland ToManagedLand:managedObjectContext];
        if(! [managedObjectContext save:&error]){
            NSLog(@"Context save error %@, %@", error, [error userInfo]);
			abort();
        }
         
    }
}
-(void)DataError:(NSError *)error{
    
}
@end
