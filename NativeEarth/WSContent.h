//
//  WSContent.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"

@interface WSContent : NSObject {
    
}
@property (nonatomic, retain) NSString * ArtistName;
@property (nonatomic, retain) NSString * SynopsisEnglish;
@property (nonatomic, retain) NSString * SynopsisFrench;
@property (nonatomic, retain) NSString * License;
@property (nonatomic, retain) NSString * DataLocation;
@property (nonatomic, retain) NSString * MIMEType;
@property (nonatomic, retain) NSString * TitleEnglish;
@property (nonatomic, retain) NSString * TitleFrench;

-(id) initWithDictionary:(NSDictionary *) contentDict;
-(Content *) ToManagedContent:(NSManagedObjectContext*) context;
@end
