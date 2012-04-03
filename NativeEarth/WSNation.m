//
//  WSNation.m
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-06.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WSNation.h"
#import "Land.h"
#import "WSLand.h"
#import "Greeting.h"
#import "WSGreeting.h"
#import "NativeEarthAppDelegate_iPhone.h"
@implementation WSNation

@synthesize Number;
@synthesize RowVersion;
@synthesize OfficialName;
@synthesize Address;
@synthesize PostCode;
@synthesize Phone;
@synthesize CommunitySite;
@synthesize CenterLat;
@synthesize CenterLong;
@synthesize Lands;
@synthesize greeting;
@synthesize PlannedVisits;
@synthesize Maps;


-(void)dealloc{
    
    [self.Number release];
    [self.RowVersion release];
    [self.OfficialName release];
    [self.Address release];
    [self.PostCode release];
    [self.Phone release];
    [self.CommunitySite release];
    [self.CenterLat release];
    [self.CenterLong release];
    [self.Lands release];
    [self.greeting release];
    [self.PlannedVisits release];
    [self.Maps release];
    
    [super dealloc];
}


-(id)initWithDictionary:(NSDictionary *)nationDict{
    self= [super init];
    if (self) {
        
        self.Number=[NSNumber numberWithInt:[[nationDict valueForKey:@"Number"]intValue]];  
        self.RowVersion = [NSNumber numberWithInt:[[nationDict valueForKey:@"rowrersion"]intValue]];
        self.OfficialName = [nationDict valueForKey:@"OfficialName"];
        
        if([nationDict valueForKey:@"Address"] !=[NSNull null])self.Address = [nationDict valueForKey:@"Address"];
        if([nationDict valueForKey:@"PostCode"] !=[NSNull null])self.PostCode=[nationDict valueForKey:@"PostCode"];
       
        if([nationDict valueForKey:@"Phone"] !=[NSNull null]) self.Phone = [nationDict valueForKey:@"Phone"];
        if([nationDict valueForKey:@"CenterPoint"] !=[NSNull null]) self.CommunitySite = [nationDict valueForKey:@"CenterPoint"];
       
        id  centerLatitute= [nationDict valueForKey:@"CenterLat"];
        id  centerLongitute= [nationDict valueForKey:@"CenterLong"];

        if(centerLatitute !=[NSNull null] ) self.CenterLat= [NSNumber numberWithDouble:[centerLatitute doubleValue]];
        if(centerLongitute!=[NSNull null]) self.CenterLong=[NSNumber numberWithDouble:[[nationDict valueForKey:@"CenterLong"]doubleValue]];
        if([nationDict valueForKey:@"tbLands"] !=[NSNull null]){
        NSArray* lands = [nationDict valueForKey:@"tbLands"];
        self.Lands =[[NSMutableArray alloc] initWithCapacity:[lands count]];
        for (NSDictionary * dict in lands) {
            [self.Lands addObject:[[WSLand alloc] initWithDictionary:dict]];
        }
            NSDictionary * greetingDict =[nationDict valueForKey:@"tbGreeting"];
        if (greetingDict != [NSNull null] ) {
            self.greeting =[[WSGreeting alloc] initWithDictionary:greetingDict];
        }
            
        }
       
    }
    return self;

}
-(Nation*)ToManagedNation:(NSManagedObjectContext *)context{
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Nation" inManagedObjectContext:context];
    Nation * managedNation = [[Nation alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    

    managedNation.Number= self.Number;
    managedNation.RowVersion= self.RowVersion;
    managedNation.OfficialName= self.OfficialName;
    managedNation.Address= self.Address;
    managedNation.PostCode= self.PostCode;
    managedNation.Phone= self.Phone;
    managedNation.CommunitySite= self.CommunitySite;
    managedNation.CenterLat= self.CenterLat;
    managedNation.CenterLong= self.CenterLong;
    
    NSMutableSet * landSet= [[NSMutableSet alloc] init];
    for (WSLand* land in  self.Lands) {
        [landSet addObject:[land ToManagedLand:context]];
    }
    managedNation.Lands = landSet;
    
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
  Greeting * existingGreeting=  [appDelegate.model getGreetingWithGreetingId:[self.greeting.GreetingID intValue]];
    
    if (existingGreeting) {
        managedNation.greeting = existingGreeting; 
    }else{
        managedNation.greeting=[self.greeting ToManagedGreeting:context];
    }
    
    
    return managedNation;

}

@end
