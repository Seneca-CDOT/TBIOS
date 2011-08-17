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

