//
//  Land.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Greeting, Map, PlannedVisit;

@interface Land : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * BoundaryN;
@property (nonatomic, retain) NSString * LandDescriptionEnglish;
@property (nonatomic, retain) NSString * LandName;
@property (nonatomic, retain) NSString * Language;
@property (nonatomic, retain) NSNumber * BoundaryE;
@property (nonatomic, retain) NSString * Shape;
@property (nonatomic, retain) NSString * LandDescriptionFrench;
@property (nonatomic, retain) NSNumber * BoundaryS;
@property (nonatomic, retain) NSString * Coordinates;
@property (nonatomic, retain) NSNumber * VersionIdentifier;
@property (nonatomic, retain) NSString * CenterPoint;
@property (nonatomic, retain) NSNumber * BoundaryW;
@property (nonatomic, retain) NSNumber * LandID;
@property (nonatomic, retain) NSSet* Maps;
@property (nonatomic, retain) NSSet* Greetings;
@property (nonatomic, retain) NSSet* PlannedVisits;
@property (nonatomic, retain) NSSet* Images;


- (void)addMapObject:(Map *)value; 
- (void)removeMapObject:(Map *)value ;
- (void)addMaps:(NSSet *)value ;
- (void)removeMaps:(NSSet *)value ;
- (void)addGreetingObject:(Greeting *)value ;
- (void)removeGreetingObject:(Greeting *)value ;
- (void)addGreetings:(NSSet *)value ;
- (void)removeGreetings:(NSSet *)value ;
- (void)addPlannedVisitsObject:(PlannedVisit *)value ;
- (void)removePlannedVisitsObject:(PlannedVisit *)value ;
- (void)addPlannedVisits:(NSSet *)value ;
- (void)removePlannedVisits:(NSSet *)value ;
- (void)addImagesObject:(Content *)value ;
- (void)removeImagesObject:(Content *)value ;
- (void)addImages:(NSSet *)value ;
- (void)removeImages:(NSSet *)value ;
@end
