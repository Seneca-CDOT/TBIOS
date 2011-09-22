//
//  NetworkDataGetter.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@protocol NetworkDataGetterDelegate;


@interface NetworkDataGetter : NSObject {
    NSMutableData *dataStream;
    id dataArray;
    id<NetworkDataGetterDelegate> delegate;
}
@property (nonatomic, retain)  id  dataArray;
@property (nonatomic, retain)  NSMutableData *dataStream;
@property (nonatomic, assign) id<NetworkDataGetterDelegate> delegate;
-(void) GetResultsFromUrl:(NSString*) serviceURL ;
//-(id) GetLandAcyncFromURL:(NSString *) serviceURL;
//-(NSDictionary *) GetLandShortListAcync;
@end


@protocol NetworkDataGetterDelegate <NSObject>
@required
-(void)DataUpdate:(id) object;
-(void)DataError:(NSError*) error;
@end