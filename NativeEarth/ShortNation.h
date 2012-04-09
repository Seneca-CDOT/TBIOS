//
//  LandShort.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ShortNation : NSObject {
    NSString *OfficialName;
    NSNumber  * Number;
    NSData *RowVersion;
}

@property (nonatomic, retain) NSString *OfficialName;
@property (nonatomic,retain) NSNumber * Number;
@property (nonatomic,retain) NSData * RowVersion;
-(id) initWithDictionary:(NSDictionary *) dict;
@end
