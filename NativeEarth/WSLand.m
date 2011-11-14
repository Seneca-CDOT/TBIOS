//
//  WSLand.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSLand.h"
#import "WSContent.h"
#import "WSGreeting.h"
#import "Utility.h"
@implementation WSLand
@synthesize BoundaryW;
@synthesize Language;
@synthesize LandDescriptionEnglish, LandDescriptionFrench;
@synthesize LandName;
@synthesize BoundaryS;
@synthesize Shape;
@synthesize BoundaryN;
@synthesize Coordinates;
@synthesize CenterPoint;
@synthesize DateFrom;
@synthesize DateTo;
@synthesize BoundaryE;
@synthesize LandID;
@synthesize VersionIdentifier;
@synthesize Greetings;
@synthesize Images;


-(void)dealloc{
    
    [self.BoundaryW release];
    [self.Language release];
    [self.LandDescriptionEnglish release];
    [self.LandDescriptionFrench release];
    [self.LandName release];
    [self.BoundaryS release];
    [self.Shape release];
    [self.BoundaryN release];
    [self.Coordinates release];
    [self.CenterPoint release];
    [self.DateFrom release];
    [self.DateTo release];
    [self.BoundaryE release];
    [self.LandID release];
    [self.VersionIdentifier release];
    [self.Greetings release];
    [self.Images release];
    
    [super dealloc];
}

-(id)initWithDictionary:(NSDictionary *)landDict{
    self= [super init];
    if (self) {
        
        self.LandName=[landDict valueForKey:@"LandName"];
        self.Language=[landDict valueForKey:@"Language"];
        self.LandID = [NSNumber numberWithInt:[[landDict valueForKey:@"LandID"]intValue]];
        self.LandDescriptionEnglish = [landDict valueForKey:@"LandDescriptionEnglish"];
        self.LandDescriptionFrench=[landDict valueForKey:@"LandDescriptionFrench"];
       
        self.VersionIdentifier = [NSNumber numberWithInt:[[landDict valueForKey:@"VersionIdentifier"]intValue]];
        self.Shape = [landDict valueForKey:@"Shape"];
        self.CenterPoint = [landDict valueForKey:@"CenterPoint"];
        self.Coordinates = [landDict valueForKey:@"Coordinates"];
       // self.DateFrom = [landDict valueForKey:@"DateFrom"];
        //self.DateTo = [landDict valueForKey:@"DateTo"];
        self.BoundaryE= [NSNumber numberWithDouble:[[landDict valueForKey:@"BoundaryE"]doubleValue]];
        self.BoundaryN=[NSNumber numberWithDouble:[[landDict valueForKey:@"BoundaryN"]doubleValue]];
        self.BoundaryS = [NSNumber numberWithDouble:[[landDict valueForKey:@"BoundaryS"]doubleValue]];
        self.BoundaryW =[NSNumber numberWithDouble:[[landDict valueForKey:@"BoundaryW"]doubleValue]];
        
        NSArray* greetings = [landDict valueForKey:@"Greetings"];
        self.Greetings =[[NSMutableArray alloc] initWithCapacity:[greetings count]];
        for (NSDictionary * dict in greetings) {
            [self.Greetings addObject:[[WSGreeting alloc] initWithDictionary:dict]];
        }
        
        NSArray *images = [landDict valueForKey:@"Images"];
        self.Images = [[NSMutableArray alloc] initWithCapacity:[images count]];
        for (NSDictionary * dict in images) {
            [self.Images addObject:[[WSContent alloc] initWithDictionary:dict]];
        }
        
    }
    return self;
   
}

//it converts itself to a managed land inserted to the context and returns it.
-(Land*)ToManagedLand:(NSManagedObjectContext *)context{
     NSEntityDescription *entity= [NSEntityDescription entityForName:@"Land" inManagedObjectContext:context];
    Land * managedLand = [[Land alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    managedLand.LandName= self.LandName;
   // managedLand.Language= self.Language;
    managedLand.LandID= self.LandID;
    managedLand.LandDescriptionEnglish=self.LandDescriptionEnglish;
    managedLand.LandDescriptionFrench=self.LandDescriptionFrench;
    managedLand.VersionIdentifier= self.VersionIdentifier;
    managedLand.Shape= self.Shape;
    managedLand.CenterPoint=self.CenterPoint;
    managedLand.Coordinates=self.Coordinates;
    managedLand.DateFrom=self.DateFrom;
    managedLand.DateTo= self.DateTo;
    
    NSDictionary * rectInfo = [Utility findOuterRectInfoForPolygonWithCoordinatesString:self.Coordinates];
    NSNumber* north = [rectInfo objectForKey:@"NORTH"];
    NSNumber* south =[rectInfo objectForKey:@"SOUTH"];
    NSNumber* east = [rectInfo objectForKey:@"EAST"];
    NSNumber* west =[rectInfo objectForKey:@"WEST"];

    
    
    managedLand.BoundaryE = east;
    managedLand.BoundaryN=north;
    managedLand.BoundaryS=south;
    managedLand.BoundaryW=west;
    
    NSMutableSet * greetingSet = [[NSMutableSet alloc] init];
    for (WSGreeting * greeting in self.Greetings) {
        [greetingSet addObject:[greeting ToManagedGreeting:context]];
    }
    managedLand.Greetings= greetingSet;
   
    NSMutableSet * imageSet= [[NSMutableSet alloc] init];
    for (WSContent* image in  self.Images) {
        [imageSet addObject:[image ToManagedContent:context]];
    }
    managedLand.Images = imageSet;
    
    return managedLand;
}
@end
