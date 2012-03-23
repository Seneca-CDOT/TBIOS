//
//  NativeEarthAppDelegate.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface NativeEarthAppDelegate : NSObject <UIApplicationDelegate> {
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    NetworkStatus internetConnectionStatus;
    NetworkStatus wifiConnectionStatus;
    NetworkStatus remoteHostStatus;
    //first launch
	BOOL isFirstLaunch;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;


//Network Conectivity
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus wifiConnectionStatus;
@property NetworkStatus remoteHostStatus;

- (NSURL *)applicationDocumentsDirectory;

@end
