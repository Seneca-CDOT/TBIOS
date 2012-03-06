//
//  Land.h
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Nation;

@interface Land : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * BoundaryNorth;
@property (nonatomic, retain) NSNumber * BoundaryEast;
@property (nonatomic, retain) NSNumber * BoundarySouth;
@property (nonatomic, retain) NSNumber * RowVersion;
@property (nonatomic, retain) NSNumber * BoundaryWest;
@property (nonatomic, retain) NSString * Number;
@property (nonatomic, retain) NSString * Province;
@property (nonatomic, retain) NSString * Nu;
@property (nonatomic, retain) NSString * Kml;
@property (nonatomic, retain) NSString * Location;
@property (nonatomic, retain) NSDecimalNumber * Hectars;
@property (nonatomic, retain) NSNumber * CenterLat;
@property (nonatomic, retain) NSNumber * CenterLong;
@property (nonatomic, retain) Nation * Nation;

@end
