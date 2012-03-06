//
//  Greeting.h
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Greeting : NSManagedObject {
@private
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
@property (nonatomic, retain) NSSet* Nations;


- (void)addNationsObject:(NSManagedObject *)value; 

- (void)removeNationsObject:(NSManagedObject *)value;

- (void)addNations:(NSSet *)value ;

- (void)removeNations:(NSSet *)value;
@end
