//
//  BaseTableViewController.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "LocationDetector.h"
#import "Reachability.h"
#define kTableViewSectionHeaderHeight 30
@interface BaseTableViewController : UITableViewController {
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
}

//coredata 
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
//Network

@property NetworkStatus internetConnectionStatus;
@property NetworkStatus wifiConnectionStatus;
@property NetworkStatus remoteHostStatus;
-(void) updateStatusesWithReachability: (Reachability*) curReach;
@end
