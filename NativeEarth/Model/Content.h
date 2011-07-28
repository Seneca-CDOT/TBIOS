//
//  Content.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Greetings.h"
@class Greetings, Land;

@interface Content : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Synopsis;
@property (nonatomic, retain) NSString * License;
@property (nonatomic, retain) NSData * Data;
@property (nonatomic, retain) NSString * MIMEType;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) Greetings * HelloContentOfGreeting;
@property (nonatomic, retain) Greetings * ThankYouContentOfGreeting;
@property (nonatomic, retain) Greetings * LandContentOfGreeting;
@property (nonatomic, retain) Land * MapContentOf;

//-(id) initWithDictionary:(NSDictionary *) contentDict AsMapOfLand:(Land *)land orHelloContentOfGreeting:(Greetings *) helloContentOf orThankYouContentOfGreeting:(Greetings*) thankYouContentOf orLandContentOfGreeting:(Greetings *) landContentOf;

@end
