//
//  WSGreetings.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Greeting.h"
@class WSContent;


@interface WSGreeting : NSObject {
    
}
@property(nonatomic, retain)NSString   * Language;

@property (nonatomic, retain) NSString * ActorName;

@property (nonatomic, retain) NSString * PhraseEnglish;
@property (nonatomic, retain) NSString * PhraseFrench;
@property (nonatomic, retain) NSString * PronounciationEnglish;
@property (nonatomic, retain) NSString * PronounciationFrench;

@property (nonatomic, retain) WSContent * Content;


-(id) initWithDictionary:(NSDictionary *) greetingsDict;
-(Greeting*) ToManagedGreeting:(NSManagedObjectContext*) context;

@end
