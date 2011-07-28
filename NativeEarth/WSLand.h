//
//  WSLand.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSContent, WSGreetings;

@interface WSLand : NSObject {
    
}
@property (nonatomic, retain) NSNumber * BoundryW;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSNumber * BoundryS;
@property (nonatomic, retain) NSString * Shape;
@property (nonatomic, retain) NSNumber * BoundryN;
@property (nonatomic, retain) NSString * Coordinates;
@property (nonatomic, retain) NSString * CenterPoint;
@property (nonatomic, retain) NSDate * DateFrom;
@property (nonatomic, retain) NSDate * DateTo;
@property (nonatomic, retain) NSNumber * BoundryE;
@property (nonatomic, retain) NSNumber * LandID;
@property (nonatomic, retain) NSNumber * VersionIdentifier;
@property (nonatomic, retain) WSGreetings * Greetings;
@property (nonatomic, retain) NSMutableArray * Images;

-(id)initWithDictionary:(NSDictionary *)landDict;
@end
