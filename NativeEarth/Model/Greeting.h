//
//  Greetings.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Land;

@interface Greeting : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * PronounciationFrench;
@property (nonatomic, retain) NSString * Phrase;
@property (nonatomic, retain) NSString * Language;
@property (nonatomic, retain) NSString * PronounciationEnglish;
@property (nonatomic, retain) NSString * Type;
@property (nonatomic, retain) Content * Content;
@property (nonatomic, retain) Land * Land;

@end
