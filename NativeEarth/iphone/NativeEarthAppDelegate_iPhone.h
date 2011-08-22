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
#import "LandGetter.h"
@interface NativeEarthAppDelegate_iPhone :NativeEarthAppDelegate {
 

}
@property (nonatomic , retain) LandGetter * landGetter;
@property (nonatomic, retain) NSMutableArray *  updateArray ;
@property (nonatomic, retain) IBOutlet LauncherViewController_iPhone * viewController;

- (void) updateStatusesWithReachability: (Reachability*) curReach;


@end

