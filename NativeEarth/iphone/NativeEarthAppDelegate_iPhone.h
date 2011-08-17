//
//  NativeEarthAppDelegate_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NativeEarthAppDelegate.h"
#import "LauncherViewController_iPhone.h"
#import "NetworkDataGetter.h"

@interface NativeEarthAppDelegate_iPhone :NativeEarthAppDelegate <NetworkDataGetterDelegate>{
 
    //first launch
	BOOL isFirstLaunch;
    BOOL updateCheckStarted;
    BOOL updateCheckFinished;
    NSMutableArray *  addArray ;
    NSMutableArray *  deleteArray ;
    NSMutableArray *  updateArray ;
  //  LauncherViewController_iPhone *viewController;
}
@property (nonatomic, retain) NSMutableArray *  updateArray ;
@property (nonatomic, retain) IBOutlet LauncherViewController_iPhone * viewController;

- (void) updateStatusesWithReachability: (Reachability*) curReach;

-(void) GetLandShortsFromWebService;
-(void) GetFirstNationLandFromWebServiceWithLandID:(NSNumber *)landID;
@end

NSInteger firstNumSort(id str1, id str2, void *context) {
    int num1 = [str1 integerValue];
    int num2 = [str2 integerValue];
    
    if (num1 < num2)
        return NSOrderedAscending;
    else if (num1 > num2)
        return NSOrderedDescending;
    
    return NSOrderedSame;
}