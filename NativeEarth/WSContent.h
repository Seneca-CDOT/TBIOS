//
//  WSContent.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WSContent : NSObject {
    
}
@property (nonatomic, retain) NSString * Synopsis;
@property (nonatomic, retain) NSString * License;
@property (nonatomic, retain) NSData * Data;
@property (nonatomic, retain) NSString * MIMEType;
@property (nonatomic, retain) NSString * Title;

-(id) initWithDictionary:(NSDictionary *) contentDict;
@end
