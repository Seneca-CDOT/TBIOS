//
//  Content.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-05.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Greetings, Land;

@interface Content : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * TitleEnglish;
@property (nonatomic, retain) NSString * TitleFrench;
@property (nonatomic, retain) NSString * DataLocation;
@property (nonatomic, retain) NSString * License;
@property (nonatomic, retain) NSString * SynopsisFrench;
@property (nonatomic, retain) NSString * SynopsisEnglish;
@property (nonatomic, retain) NSString * MIMEType;
@property (nonatomic, retain) Greetings * HelloContentOfGreeting;
@property (nonatomic, retain) Land * MapOfLand;
@property (nonatomic, retain) Greetings * ThankYouContentOfGreeting;
@property (nonatomic, retain) Greetings * LandContentOfGreeting;
@property (nonatomic, retain) Greetings * WelcomeContentOfGreeting;
@property (nonatomic, retain) Land * ImageOfLand;

@end
