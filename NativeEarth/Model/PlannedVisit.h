//
//  PlannedVisit.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Land;

@interface PlannedVisit : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSDate * FromDate;
@property (nonatomic, retain) NSString * Notes;
@property (nonatomic, retain) NSDate * ToDate;
@property (nonatomic, retain) NSSet* Lands;


- (void)addLandsObject:(Land *)value ;
- (void)removeLandsObject:(Land *)value ;
- (void)addLands:(NSSet *)value ;
- (void)removeLands:(NSSet *)value ;
@end
