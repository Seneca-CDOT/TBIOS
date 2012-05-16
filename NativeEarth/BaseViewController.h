//
//  RootViewController.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "LocationDetector.h"
#import "Reachability.h"

@interface BaseViewController : UIViewController {
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
NetworkStatus internetConnectionStatus;
  NetworkStatus wifiConnectionStatus;
 NetworkStatus remoteHostStatus;
   
}
// coredata 
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus wifiConnectionStatus;
@property NetworkStatus remoteHostStatus;

- (void) updateStatusesWithReachability: (Reachability*) curReach;
@end
