//
//  Land.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Greetings, Map, PlannedVisit;

@interface Land : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * BoundaryN;
@property (nonatomic, retain) NSString * LandDescriptionEnglish;
@property (nonatomic, retain) NSString * LandName;
@property (nonatomic, retain) NSNumber * BoundaryE;
@property (nonatomic, retain) NSString * Shape;
@property (nonatomic, retain) NSString * Coordinates;
@property (nonatomic, retain) NSNumber * BoundaryS;
@property (nonatomic, retain) NSDate * DateFrom;
@property (nonatomic, retain) NSString * CenterPoint;
@property (nonatomic, retain) NSNumber * VersionIdentifier;
@property (nonatomic, retain) NSString * LandDescriptionFrench;
@property (nonatomic, retain) NSNumber * BoundaryW;
@property (nonatomic, retain) NSDate * DateTo;
@property (nonatomic, retain) NSNumber * LandID;
@property (nonatomic, retain) Greetings * Greetings;
@property (nonatomic, retain) NSSet* PlannedVisits;
@property (nonatomic, retain) NSSet* Images;
@property (nonatomic, retain) NSSet* Maps;


- (void)addPlannedVisitsObject:(PlannedVisit *)value;
- (void)removePlannedVisitsObject:(PlannedVisit *)value;
- (void)addPlannedVisits:(NSSet *)value;
- (void)removePlannedVisits:(NSSet *)value;
- (void)addImagesObject:(Content *)value;
- (void)removeImagesObject:(Content *)value ;
- (void)addImages:(NSSet *)value ;
- (void)removeImages:(NSSet *)value;
- (void)addMapsObject:(Map *)value;
- (void)removeMapsObject:(Map *)value ;
- (void)addMaps:(NSSet *)value ;
- (void)removeMaps:(NSSet *)value;
@end
