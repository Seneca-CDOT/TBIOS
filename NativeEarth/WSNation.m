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
@synthesize Province;


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
    [self.Province release];
    [super dealloc];
}


-(id)initWithDictionary:(NSDictionary *)nationDict{
    self= [super init];
    if (self) {
        
        self.Number=[NSNumber numberWithInt:[[nationDict valueForKey:@"Number"]intValue]];  
      
        self.RowVersion=[[nationDict valueForKey:@"rowversion"]description];
       // self.OfficialName = [[nationDict valueForKey:@"OfficialName"] description];
         if([nationDict valueForKey:@"OfficialName"] !=[NSNull null])self.OfficialName = [nationDict valueForKey:@"OfficialName"];
        if([nationDict valueForKey:@"CommunitySite"] !=[NSNull null])self.CommunitySite = [nationDict valueForKey:@"CommunitySite"];
        if([nationDict valueForKey:@"Address"] !=[NSNull null])self.Address = [nationDict valueForKey:@"Address"];
        if([nationDict valueForKey:@"Province"] !=[NSNull null])self.Province = [nationDict valueForKey:@"Province"];

        if([nationDict valueForKey:@"PostCode"] !=[NSNull null])self.PostCode=[nationDict valueForKey:@"PostCode"];
        if([nationDict valueForKey:@"Phone"] !=[NSNull null]) self.Phone = [nationDict valueForKey:@"Phone"];
              
        id  centerLatitute= [nationDict valueForKey:@"CenterLat"];
        id  centerLongitute= [nationDict valueForKey:@"CenterLong"];

        if(centerLatitute !=[NSNull null] ) self.CenterLat= [NSNumber numberWithDouble:[centerLatitute doubleValue]];
        if(centerLongitute!=[NSNull null]) self.CenterLong=[NSNumber numberWithDouble:[[nationDict valueForKey:@"CenterLong"]doubleValue]];
        if([nationDict valueForKey:@"tbLands"] !=[NSNull null]){
          NSArray* lands = [nationDict valueForKey:@"tbLands"];
          self.Lands =[[[NSMutableArray alloc] initWithCapacity:[lands count]] autorelease];
          for (NSDictionary * dict in lands) {
            [self.Lands addObject:[[[WSLand alloc] initWithDictionary:dict]autorelease]];
          }
        }
       
        NSDictionary * greetingDict =[nationDict valueForKey:@"tbGreeting"] ;
        if ((NSNull *)greetingDict != [NSNull null]) {
            self.greeting =[[[WSGreeting alloc] initWithDictionary:greetingDict] autorelease];
            
        }
       
    }
    return self;

}
-(Nation*)ToManagedNation:(NSManagedObjectContext *)context{
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Nation" inManagedObjectContext:context];
    Nation * managedNation = [[[Nation alloc] initWithEntity:entity insertIntoManagedObjectContext:context] autorelease];
    

    managedNation.Number= self.Number;
    managedNation.rowversion= self.RowVersion;
    managedNation.OfficialName= self.OfficialName;
    managedNation.Address= self.Address;
    managedNation.PostCode= self.PostCode;
    managedNation.Phone= self.Phone;
    managedNation.CommunitySite= self.CommunitySite;
    managedNation.CenterLat= self.CenterLat;
    managedNation.CenterLong= self.CenterLong;
    managedNation.Province=self.Province;
    for (WSLand* land in  self.Lands) {
        [managedNation addLandsObject:[land ToManagedLand:context ]];
        }
   
    
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    if (self.greeting) {
          
        Greeting * existingGreeting=  [appDelegate.model getGreetingWithGreetingId:[self.greeting.GreetingID intValue]];
    
        if (existingGreeting) {
            [existingGreeting addNationsObject:managedNation]; 
        }else{
            [[self.greeting ToManagedGreeting:context] addNationsObject:managedNation];
        }
    }
    
    return managedNation;

}

@end
