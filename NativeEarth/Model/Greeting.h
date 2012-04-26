//
//  Greeting.h
//  NativeEarth
//
//  Created by Ladan Zahir on 12-04-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Nation;

@interface Greeting : NSManagedObject {
@private
}
@property (nonatomic, retain) NSData * ThankYou;
@property (nonatomic, retain) NSNumber * GreetingID;
@property (nonatomic, retain) NSString * GoodByePronunciation;
@property (nonatomic, retain) NSData * GoodBye;
@property (nonatomic, retain) NSString * ThankYouMIMEType;
@property (nonatomic, retain) NSString * ActorName;
@property (nonatomic, retain) NSString * HelloMIMEType;
@property (nonatomic, retain) NSData * Hello;
@property (nonatomic, retain) NSString * RowVersion;
@property (nonatomic, retain) NSString * HelloPronunciation;
@property (nonatomic, retain) NSString * ThankYouPronunciation;
@property (nonatomic, retain) NSString * GoodByeMIMEType;
@property (nonatomic, retain) NSDate * RecordedOn;
@property (nonatomic, retain) NSSet* Nations;

- (void)addNationsObject:(Nation *)value ;
- (void)removeNationsObject:(Nation *)value ;
- (void)addNations:(NSSet *)value ;
- (void)removeNations:(NSSet *)value ;
@end
