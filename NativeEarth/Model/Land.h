//
//  Land.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Greetings, PlannedVisit;

@interface Land : NSManagedObject {
@private
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
@property (nonatomic, retain) NSSet* PlannedVisits;
@property (nonatomic, retain) Greetings * Greetings;
@property (nonatomic, retain) Content * Map;

@end
