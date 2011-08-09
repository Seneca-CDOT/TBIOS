//
//  Land.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-05.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Greetings, PlannedVisit;

@interface Land : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * BoundaryW;
@property (nonatomic, retain) NSString * LandDescriptionEnglish;
@property (nonatomic, retain) NSString * LandName;
@property (nonatomic, retain) NSNumber * BoundaryS;
@property (nonatomic, retain) NSString * Shape;
@property (nonatomic, retain) NSNumber * BoundaryN;
@property (nonatomic, retain) NSString * Coordinates;
@property (nonatomic, retain) NSString * CenterPoint;
@property (nonatomic, retain) NSDate * DateFrom;
@property (nonatomic, retain) NSString * LandDescriptionFrench;
@property (nonatomic, retain) NSNumber * VersionIdentifier;
@property (nonatomic, retain) NSDate * DateTo;
@property (nonatomic, retain) NSNumber * BoundaryE;
@property (nonatomic, retain) NSNumber * LandID;
@property (nonatomic, retain) NSSet* Maps;
@property (nonatomic, retain) Greetings * Greetings;
@property (nonatomic, retain) NSSet* PlannedVisits;
@property (nonatomic, retain) NSSet* Images;

- (void)addMapsObject:(Content *)value;
@end
