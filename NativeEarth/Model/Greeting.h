//
//  Greeting.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-12-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Land;

@interface Greeting : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * PhraseEnglish;
@property (nonatomic, retain) NSString * Language;
@property (nonatomic, retain) NSString * PronounciationEnglish;
@property (nonatomic, retain) NSString * PronounciationFrench;
@property (nonatomic, retain) NSString * Type;
@property (nonatomic, retain) NSString * PhraseFrench;
@property (nonatomic, retain) Land * Land;
@property (nonatomic, retain) Content * Content;

@end
