//
//  Map.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Land;

@interface Map : NSManagedObject {
@private
}
@property (nonatomic, retain) id Image;
@property (nonatomic, retain) Land * Land;

@end
