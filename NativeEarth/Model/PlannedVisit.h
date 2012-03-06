//
//  PlannedVisit.h
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Nation;

@interface PlannedVisit : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSDate * FromDate;
@property (nonatomic, retain) NSString * Notes;
@property (nonatomic, retain) NSDate * ToDate;
@property (nonatomic, retain) NSSet* Nations;

@end
