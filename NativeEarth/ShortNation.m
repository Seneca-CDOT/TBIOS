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
    self.OfficialName = [dict valueForKey:@"OfficialName"];
    self.RowVersion =[NSNumber numberWithInt:[[dict valueForKey:@"RowVersion"]intValue] ];
    return self;
    }
-(void)dealloc {
    [self.OfficialName release];
    [self.Number release];
    [self.RowVersion release];
    [super dealloc];
}
@end
