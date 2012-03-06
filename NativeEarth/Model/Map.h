//
//  Map.h
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Map : NSManagedObject {
@private
}
@property (nonatomic, retain) id Image;
@property (nonatomic, retain) id Thumb;
@property (nonatomic, retain) NSManagedObject * Nation;

@end
