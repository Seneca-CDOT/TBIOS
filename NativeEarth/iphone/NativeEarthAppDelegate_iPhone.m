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
 

    self.model = [[Model alloc] init];

    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];
    return  YES;
}

- (void)dealloc{
    [model release];
    [updateArray release];
    
	[super dealloc];
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

