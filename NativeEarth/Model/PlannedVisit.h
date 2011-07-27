//
//  PlannedVisit.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Land;

@interface PlannedVisit : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * FromDate;
@property (nonatomic, retain) NSDate * ToDate;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * Notes;
@property (nonatomic, retain) NSSet* Lands;

@end
