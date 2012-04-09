//
//  LandShort.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShortNation.h"


@implementation ShortNation

@synthesize OfficialName, Number, RowVersion;
-(id) initWithDictionary:(NSDictionary *) dict{
    [super init];
    self.Number = [NSNumber numberWithInt:[[dict valueForKey:@"Number"]intValue] ];
    self.OfficialName = [[dict valueForKey:@"OfficialName"] description];
    id version = [dict valueForKey:@"rowversion" ] ;
    if([version isKindOfClass:[NSData class]]){//for local object
        self.RowVersion = (NSData*)version ;   
     
    }else{//for remote object
       
    int len = sizeof(version)*[version count]; 
        self.RowVersion=  [NSData dataWithBytes:version  length:len ] ;
      
    }
    
    return self;
    }
-(void)dealloc {
    [self.OfficialName release];
    [self.Number release];
    [self.RowVersion release];
    [super dealloc];
}
@end
