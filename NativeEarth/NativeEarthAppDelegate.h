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

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Network Conectivity
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus wifiConnectionStatus;
@property NetworkStatus remoteHostStatus;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
