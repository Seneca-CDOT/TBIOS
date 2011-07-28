//
//  Content.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Content.h"
#import "Greetings.h"
#import "Land.h"


@implementation Content
@dynamic Synopsis;
@dynamic License;
@dynamic Data;
@dynamic MIMEType;
@dynamic Title;
@dynamic HelloContentOfGreeting;
@dynamic ThankYouContentOfGreeting;
@dynamic LandContentOfGreeting;
@dynamic MapContentOf;


//-(id) initWithDictionary:(NSDictionary *) contentDict AsMapOfLand:(Land *)land orHelloContentOfGreeting:(Greetings *) helloContentOf orThankYouContentOfGreeting:(Greetings*) thankYouContentOf orLandContentOfGreeting:(Greetings *) landContentOf{
//    
//    self=[super init];
//    if (self) {
//    self.Synopsis = [contentDict valueForKey:@"Synopsis"];
//    self.License = [contentDict valueForKey:@"License"];
//    self.Data= [contentDict valueForKey:@"Data"];
//    self.MIMEType = [contentDict valueForKey:@"MIMEType"];
//    self.Title = [contentDict valueForKey:@"Title"];
//    
//    self.HelloContentOfGreeting = helloContentOf;
//    self.ThankYouContentOfGreeting = thankYouContentOf;
//    self.LandContentOfGreeting = landContentOf;
//    self.MapContentOf = land;
//    }
//    return self;
//}


@end
