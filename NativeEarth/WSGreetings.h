//
//  WSGreetings.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WSContent;

@interface WSGreetings : NSObject {
    
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
@property (nonatomic, retain) WSContent * HelloContent;
@property (nonatomic, retain) WSContent * LandContent;
@property (nonatomic, retain) WSContent * ThankYouContent;

-(id) initWithDictionary:(NSDictionary *) greetingsDict;

@end
