//
//  WSContent.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSContent.h"


@implementation WSContent

@synthesize  Synopsis;
@synthesize License;
@synthesize Data;
@synthesize MIMEType;
@synthesize Title;


-(void)dealloc{
    
    [self.Synopsis release];
    [self.License release];
    [self.Data release];
    [self.MIMEType release];
    [self.Title release];
    
    [super dealloc];
}

-(id) initWithDictionary:(NSDictionary *) contentDict{
    self=[super init];
    if (self) {
        self.Synopsis = [contentDict valueForKey:@"Synopsis"];
        self.License = [contentDict valueForKey:@"License"];
        self.Data= [contentDict valueForKey:@"Data"];
        self.MIMEType = [contentDict valueForKey:@"MIMEType"];
        self.Title = [contentDict valueForKey:@"Title"];
    }
    return self;
}
@end
