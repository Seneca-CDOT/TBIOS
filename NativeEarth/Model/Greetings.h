//
//  Greetings.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Land;

@interface Greetings : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * LandPhrase;
@property (nonatomic, retain) NSString * HelloPronounciationFrench;
@property (nonatomic, retain) NSString * LandPronounciationFrench;
@property (nonatomic, retain) NSString * ActorName;
@property (nonatomic, retain) NSString * HelloPhrase;
@property (nonatomic, retain) NSString * ThankYouPhrase;
@property (nonatomic, retain) NSString * LandPronounciationEnglish;
@property (nonatomic, retain) NSString * HelloPronounciationEnglish;
@property (nonatomic, retain) NSString * ThankYouPronounciationEnglish;
@property (nonatomic, retain) NSString * ThankYouPronounciationFrench;
@property (nonatomic, retain) Content * HelloContent;
@property (nonatomic, retain) Content * LandContent;
@property (nonatomic, retain) Content * ThankYouContent;
@property (nonatomic, retain) Land * Land;

@end
