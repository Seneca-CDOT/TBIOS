//
//  WSLand.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSLand.h"

#import "WSGreeting.h"
#import "Utility.h"
@implementation WSLand
@synthesize  BoundaryNorth;
@synthesize BoundaryEast;
@synthesize BoundarySouth;
@synthesize RowVersion;
@synthesize BoundaryWest;
@synthesize Number;
@synthesize Province;
@synthesize LandName_ENG;
@synthesize LandName_FRA;
@synthesize Kml;
@synthesize Location;
@synthesize Hectars;
@synthesize CenterLat;
@synthesize CenterLong;


-(void)dealloc{
    [self.BoundaryEast release];
    [self.BoundarySouth release];
    [self.BoundaryWest release];
    [self.BoundaryNorth release];
    [self.RowVersion release];
    [self.Number release];
    [self.Province release];
    [self.LandName_ENG release];
    [self.LandName_FRA release];
    [self.Kml release];
    [self.Location release];
    [self.Hectars release];
    [self.CenterLat release];
    [self.CenterLong release];
        
    [super dealloc];
}

-(id)initWithDictionary:(NSDictionary *)landDict{
    self= [super init];
    if (self) {
       
        self.BoundaryEast= [NSNumber numberWithDouble:[[landDict valueForKey:@"BoundaryEast"]doubleValue]];
        self.BoundaryNorth=[NSNumber numberWithDouble:[[landDict valueForKey:@"BoundaryNorth"]doubleValue]];
        self.BoundarySouth = [NSNumber numberWithDouble:[[landDict valueForKey:@"BoundarySouth"]doubleValue]];
        self.BoundaryWest =[NSNumber numberWithDouble:[[landDict valueForKey:@"BoundaryWest"]doubleValue]];
        self.Hectars= [NSNumber numberWithDouble:[[landDict valueForKey:@"Hectars"]doubleValue]];
        self.CenterLat =[NSNumber numberWithDouble:[[landDict valueForKey:@"CenterLat"]doubleValue]];
        self.CenterLong =[NSNumber numberWithDouble:[[landDict valueForKey:@"CenterLong"]doubleValue]];
        
//        int rvLen= sizeof([landDict valueForKey:@"rowversion" ]) * [[landDict valueForKey:@"rowversion" ] count]; 
//        self.RowVersion= [NSData dataWithBytes:[landDict valueForKey:@"rowversion" ]  length: rvLen];
        
        self.RowVersion=[[landDict valueForKey:@"rowversion"] description];
        self.Number= [landDict valueForKey:@"Number"];
        self.LandName_ENG=[[landDict valueForKey:@"LandName_ENG"] description];
        self.LandName_FRA=[[landDict valueForKey:@"LandName_FRA"] description];
        if ([landDict valueForKey:@"Province"] !=[NSNull null]) {
             self.Province=[landDict valueForKey:@"Province"];
        }
      
        self.Kml = [landDict valueForKey:@"KML"];
        self.Location=[landDict valueForKey:@"Location"];

                
    }
    return self;
   
}

//it converts itself to a managed land inserted to the context and returns it.
-(Land*)ToManagedLand:(NSManagedObjectContext *)context {
     NSEntityDescription *entity= [NSEntityDescription entityForName:@"Land" inManagedObjectContext:context];
    Land * managedLand = [[Land alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    managedLand.LandName_ENG= self.LandName_ENG;
    managedLand.LandName_FRA=self.LandName_FRA;
    managedLand.BoundaryEast= self.BoundaryEast ;
    managedLand.BoundaryNorth= self.BoundaryNorth;
    managedLand.BoundarySouth=self.BoundarySouth;
    managedLand.BoundaryWest=self.BoundaryWest;
    managedLand.RowVersion= self.RowVersion;
    managedLand.Number= self.Number;
    managedLand.Province=self.Province;
    managedLand.Kml=self.Kml;
    managedLand.Location=self.Location;
    managedLand.Hectars=self.Hectars;
    managedLand.CenterLong=self.CenterLong;
    managedLand.CenterLat=self.CenterLat;
   
    return managedLand;

    
  }
@end
