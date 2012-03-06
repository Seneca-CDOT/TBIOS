//
//  LandShort.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSLandShort.h"


@implementation WSLandShort

@synthesize landName, landId, versionIdentifier;
-(id) initWithDictionary:(NSDictionary *) dict{
    [super init];
    self.landId = [NSNumber numberWithInt:[[dict valueForKey:@"LandID"]intValue] ];
    self.landName = [dict valueForKey:@"LandName"];
    self.versionIdentifier =[NSNumber numberWithInt:[[dict valueForKey:@"VersionIdentifier"]intValue] ];
    return self;
    }
-(void)dealloc {
    [self.landName release];
    [self.landId release];
    [self.versionIdentifier release];
    [super dealloc];
}
@end
