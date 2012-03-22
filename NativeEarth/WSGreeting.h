//
//  WSGreetings.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Greeting.h"


@interface WSGreeting : NSObject {
    
}

@property (nonatomic, retain) NSString * HelloPronounciation;
@property (nonatomic, retain) NSNumber * RowVersion;
@property (nonatomic, retain) NSNumber * GreetingID;
@property (nonatomic, retain) NSString * ThankYouPronounciation;
@property (nonatomic, retain) NSString * WelcomePronounciation;
@property (nonatomic, retain) NSString * ActorName;
@property (nonatomic, retain) NSDate * RecordedOn;
@property (nonatomic, retain) NSString * HelloMIMEType;
@property (nonatomic, retain) NSString * WelcomeMIMEType;
@property (nonatomic, retain) NSString * ThankYouMIMEType;
@property (nonatomic, retain) NSData * Hello;
@property (nonatomic, retain) NSData * Welcome;
@property (nonatomic, retain) NSData * ThankYou;

-(id) initWithDictionary:(NSDictionary *) greetingsDict;
-(Greeting*) ToManagedGreeting:(NSManagedObjectContext*) context;

@end
