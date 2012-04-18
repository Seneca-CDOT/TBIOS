//
//  WSLand.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Land.h"
#import "Nation.h"
@class  WSGreetings;

@interface WSLand : NSObject {
    
}
@property (nonatomic, retain) NSNumber * BoundaryNorth;
@property (nonatomic, retain) NSNumber * BoundaryEast;
@property (nonatomic, retain) NSNumber * BoundarySouth;
@property (nonatomic, retain) NSString * RowVersion;
@property (nonatomic, retain) NSNumber * BoundaryWest;
@property (nonatomic, retain) NSString * Number;
@property (nonatomic, retain) NSString * Province;
@property (nonatomic, retain) NSString * LandName_ENG;
@property (nonatomic, retain) NSString * LandName_FRA;
@property (nonatomic, retain) NSString * Kml;
@property (nonatomic, retain) NSString * Location;
@property (nonatomic, retain) NSNumber * Hectars;
@property (nonatomic, retain) NSNumber * CenterLat;
@property (nonatomic, retain) NSNumber * CenterLong;



-(id)initWithDictionary:(NSDictionary *)landDict;
-(Land*)ToManagedLand:(NSManagedObjectContext *)context;
@end
