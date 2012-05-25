//
//  LandShort.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ShortNation : NSObject 

@property (nonatomic, copy) NSString *OfficialName;
@property (nonatomic, copy) NSNumber *Number;
@property (nonatomic, copy) NSString *RowVersion;
@property (nonatomic, copy) NSString *Province;

-(id) initWithDictionary:(NSDictionary *) dict;

@end




