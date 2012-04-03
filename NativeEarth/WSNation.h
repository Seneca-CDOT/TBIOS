//
//  WSNation.h
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-06.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Nation.h"
@class WSGreeting;

@interface WSNation : NSObject {
    
}


@property (nonatomic, retain) NSNumber * Number;
@property (nonatomic, retain) NSNumber * RowVersion;
@property (nonatomic, retain) NSString * OfficialName;
@property (nonatomic, retain) NSString * Address;
@property (nonatomic, retain) NSString * PostCode;
@property (nonatomic, retain) NSString * Phone;
@property (nonatomic, retain) NSString * CommunitySite;
@property (nonatomic, retain) NSNumber * CenterLat;
@property (nonatomic, retain) NSNumber * CenterLong;
@property (nonatomic, retain) NSMutableArray* Lands;
@property (nonatomic, retain) WSGreeting * greeting;
@property (nonatomic, retain) NSMutableArray* PlannedVisits;
@property (nonatomic, retain) NSMutableArray* Maps;


-(id)initWithDictionary:(NSDictionary *)nationDict;
-(Nation*)ToManagedNation:(NSManagedObjectContext *)context;
@end
