//
//  FirstNation.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LandShort : NSObject {
    NSNumber * landId;
    NSString *name;
    NSNumber *versionIdentifier;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic,retain) NSNumber * landId;
@property (nonatomic,retain) NSNumber * versionIdentifier;
-(id) initWithDictionary:(NSDictionary *) dict;
@end
