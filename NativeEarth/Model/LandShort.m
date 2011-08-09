//
//  FirstNation.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LandShort.h"


@implementation LandShort

@synthesize name, landId, versionIdentifier;
-(id) initWithDictionary:(NSDictionary *) dict{
    [super init];
    self.name = [dict valueForKey:@"Name"];
    self.landId = [NSNumber numberWithInt:[[dict valueForKey:@"LandID"]intValue] ];
    self.versionIdentifier =[NSNumber numberWithInt:[[dict valueForKey:@"VersionIdentifier"]intValue] ];
    return self;
    }
-(void)dealloc {
    [self.name release];
    [self.landId release];
    [self.versionIdentifier release];
    [super dealloc];
}
@end
