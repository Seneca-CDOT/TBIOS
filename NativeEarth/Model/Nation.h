//
//  Nation.h
//  NativeEarth
//
//  Created by Ladan Zahir on 12-05-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Greeting, Land, Map, PlannedVisit;

@interface Nation : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Province;
@property (nonatomic, retain) NSNumber * CenterLat;
@property (nonatomic, retain) NSString * Phone;
@property (nonatomic, retain) NSNumber * Number;
@property (nonatomic, retain) NSString * CommunitySite;
@property (nonatomic, retain) NSString * Address;
@property (nonatomic, retain) NSNumber * CenterLong;
@property (nonatomic, retain) NSString * rowversion;
@property (nonatomic, retain) NSString * OfficialName;
@property (nonatomic, retain) NSString * PostCode;
@property (nonatomic, retain) NSNumber * Distance;
@property (nonatomic, retain) NSSet* Maps;
@property (nonatomic, retain) NSSet* Lands;
@property (nonatomic, retain) Greeting * greeting;
@property (nonatomic, retain) NSSet* PlannedVisits;


- (void)addMapsObject:(Map *)value ;
- (void)removeMapsObject:(Map *)value ;
- (void)addMaps:(NSSet *)value ;
- (void)removeMaps:(NSSet *)value ;
- (void)addLandsObject:(Land *)value ;
- (void)removeLandsObject:(Land *)value ;
- (void)addLands:(NSSet *)value ;
- (void)removeLands:(NSSet *)value ;
- (void)addPlannedVisitsObject:(PlannedVisit *)value ;
- (void)removePlannedVisitsObject:(PlannedVisit *)value ;
- (void)addPlannedVisits:(NSSet *)value ;
- (void)removePlannedVisits:(NSSet *)value ;

@end
