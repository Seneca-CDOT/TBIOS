//
//  WSLand.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Land.h"
@class WSContent, WSGreetings;

@interface WSLand : NSObject {
    
}
@property (nonatomic, retain) NSNumber * LandID;
@property (nonatomic, retain) NSString * LandName;
@property (nonatomic, retain) NSString * LandDescriptionEnglish;
@property (nonatomic, retain) NSString * LandDescriptionFrench;
@property (nonatomic, retain) NSString * Shape;
@property (nonatomic, retain) NSNumber * BoundaryN;
@property (nonatomic, retain) NSNumber * BoundaryS;
@property (nonatomic, retain) NSNumber * BoundaryE;
@property (nonatomic, retain) NSNumber * BoundaryW;
@property (nonatomic, retain) NSString * Coordinates;
@property (nonatomic, retain) NSString * CenterPoint;
@property (nonatomic, retain) NSDate * DateFrom;
@property (nonatomic, retain) NSDate * DateTo;
@property (nonatomic, retain) NSNumber * VersionIdentifier;

@property (nonatomic, retain) WSGreetings * Greetings;
@property (nonatomic, retain) NSMutableArray * Images;

-(id)initWithDictionary:(NSDictionary *)landDict;
-(Land*)ToManagedLand:(NSManagedObjectContext *)context;
@end
