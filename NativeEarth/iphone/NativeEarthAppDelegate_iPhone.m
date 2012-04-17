//
//  NativeEarthAppDelegate_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NativeEarthAppDelegate_iPhone.h"

#import "Model.h"



@implementation NativeEarthAppDelegate_iPhone

@synthesize viewController,updateArray,model;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [super application: application didFinishLaunchingWithOptions:launchOptions];
    // Status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
 
    self.viewController.internetConnectionStatus = self.internetConnectionStatus;
    self.viewController.wifiConnectionStatus = self.wifiConnectionStatus;
    self.viewController.remoteHostStatus = self.wifiConnectionStatus;
    self.model = [[Model alloc] init];

    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];
    return  YES;
}

- (void)dealloc{
    [model release];
    [updateArray release];
    
  //  [self.viewController release];
	[super dealloc];
}
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateStatusesWithReachability: curReach];
}
- (void) updateStatusesWithReachability: (Reachability*) curReach{
    if(curReach == hostReach)
	{
        self.remoteHostStatus = [curReach currentReachabilityStatus];
        //self.viewController.remoteHostStatus =self.remoteHostStatus;
    }
    
	if(curReach == internetReach)
	{	
		
        self.internetConnectionStatus= [curReach currentReachabilityStatus];
       // self.viewController.internetConnectionStatus =self.internetConnectionStatus;
	}
	if(curReach == wifiReach)
	{
        self.wifiConnectionStatus =[curReach currentReachabilityStatus];
       // self.viewController.wifiConnectionStatus=self.wifiConnectionStatus;
	}
	
        
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    NSError *error;
    if (error=[self.model SaveData])
    {
        NSLog(@"%@",[error description]);
    }
    
}





@end

