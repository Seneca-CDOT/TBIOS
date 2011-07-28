//
//  WSLand.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSLand.h"
#import "WSContent.h"
#import "WSGreetings.h"

@implementation WSLand
@synthesize BoundryW;
@synthesize Description;
@synthesize Name;
@synthesize BoundryS;
@synthesize Shape;
@synthesize BoundryN;
@synthesize Coordinates;
@synthesize CenterPoint;
@synthesize DateFrom;
@synthesize DateTo;
@synthesize BoundryE;
@synthesize LandID;
@synthesize VersionIdentifier;
@synthesize Greetings;
@synthesize Images;


-(void)dealloc{
    
    [self.BoundryW release];
    [self.Description release];
    [self.Name release];
    [self.BoundryS release];
    [self.Shape release];
    [self.BoundryN release];
    [self.Coordinates release];
    [self.CenterPoint release];
    [self.DateFrom release];
    [self.DateTo release];
    [self.BoundryE release];
    [self.LandID release];
    [self.VersionIdentifier release];
    [self.Greetings release];
    [self.Images release];
    
    [super dealloc];
}

-(id)initWithDictionary:(NSDictionary *)landDict{
    self= [super init];
    if (self) {
        
        [self setName:[landDict valueForKey:@"LandName"]];
        
        self.Description = [landDict valueForKey:@"LandDescription"];
        self.LandID = [landDict valueForKey:@"LandID"];
        self.VersionIdentifier = [landDict valueForKey:@"VersionIdentifier"];
        self.Shape = [landDict valueForKey:@"Shape"];
        self.CenterPoint = [landDict valueForKey:@"CenterPoint"];
        self.Coordinates = [landDict valueForKey:@"Coordinates"];
        self.DateFrom = [landDict valueForKey:@"DateFrom"];
        self.DateTo = [landDict valueForKey:@"DateTo"];
        self.BoundryE= [landDict valueForKey:@"BoundryE"];
        self.BoundryN=[landDict valueForKey:@"BoundryN"];
        self.BoundryS = [landDict valueForKey:@"BoundryS"];
        self.BoundryW =[landDict valueForKey:@"BoundryW"];
        
        NSDictionary * greetings = [landDict valueForKey:@"Greetings"];
        self.Greetings =[[WSGreetings alloc] initWithDictionary:greetings];
        
        NSArray *images = [landDict valueForKey:@"Images"];
        self.Images = [[NSMutableArray alloc] initWithCapacity:[images count]];
        for (NSDictionary * dict in images) {
            [self.Images addObject:[[WSContent alloc] initWithDictionary:dict]];
        }
        
    }
    return self;

}
@end
