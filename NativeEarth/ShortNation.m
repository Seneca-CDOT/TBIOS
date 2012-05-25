//
//  LandShort.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShortNation.h"


@implementation ShortNation

@synthesize OfficialName, Number, RowVersion,Province;

-(id) initWithDictionary:(NSDictionary *) dict{
    [super init];
    self.Number = [NSNumber numberWithInt:[[dict valueForKey:@"Number"]intValue]];
    self.OfficialName = [[dict valueForKey:@"OfficialName"] description];
    self.RowVersion =[[dict valueForKey:@"rowversion"] description];
    if([dict valueForKey:@"Province"] !=nil)   
        self.Province =[[dict valueForKey:@"Province"] description];
    
    return self;
}

-(void)dealloc {
    [OfficialName release];
    [Number release];
    [RowVersion release];
    [Province release];
    [super dealloc];
}

@end

