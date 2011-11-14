//
//  Content.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-14.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Greeting, Land;

@interface Content : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * TitleEnglish;
@property (nonatomic, retain) NSString * TitleFrench;
@property (nonatomic, retain) NSString * DataLocation;
@property (nonatomic, retain) NSString * License;
@property (nonatomic, retain) NSString * SynopsisFrench;
@property (nonatomic, retain) NSString * SynopsisEnglish;
@property (nonatomic, retain) NSString * MIMEType;
@property (nonatomic, retain) NSString * ArtistName;
@property (nonatomic, retain) Greeting * Greeting;
@property (nonatomic, retain) Land * Land;

@end
