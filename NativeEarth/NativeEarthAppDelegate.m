 //
//  NativeEarthAppDelegate.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NativeEarthAppDelegate.h"
#import "ZipArchive.h"
@implementation NativeEarthAppDelegate


@synthesize window=_window;
@synthesize internetConnectionStatus;
@synthesize wifiConnectionStatus;
@synthesize remoteHostStatus;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    
    hostReach = [[Reachability reachabilityWithHostName: kHostName] retain];
    [hostReach startNotifier];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
    
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];
    
    self.remoteHostStatus = [hostReach currentReachabilityStatus] ;
    self.internetConnectionStatus= [internetReach currentReachabilityStatus];
    self.wifiConnectionStatus =[wifiReach currentReachabilityStatus];
    
    isFirstLaunch=NO;
    
    NSString *storeFileName= [[[self applicationDocumentsDirectory] relativePath] stringByAppendingPathComponent:@"NativeEarth.sqlite"] ;
	// Get a reference to the file manager
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check whether the file exists
	isFirstLaunch = ![fileManager fileExistsAtPath:storeFileName];
	
    
	if (isFirstLaunch) { 
  //   NSLog(@"data creation started\n.");
   //   DataCreator * dataCreator = [[DataCreator alloc] initWithContext:self.managedObjectContext];
   // [dataCreator createDataFromWebServive];
           
      NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"NativeEarth.sqlite" ofType:@"zip"];
      if (defaultStorePath) {
        ///
          
          ZipArchive *zipArchive = [[ZipArchive alloc] init];
          
          if([zipArchive UnzipOpenFile:defaultStorePath]) {
              
              if ([zipArchive UnzipFileTo:[[self applicationDocumentsDirectory]relativePath] overWrite:YES]) {
                  //unzipped successfully
                  NSLog(@"Archive unzip Success");
                 // [self.fileManager removeItemAtPath:filePath error:NULL];
              } else {
                  NSLog(@"Failure To Unzip Archive");
              }
              
          } else  {
              NSLog(@"Failure To Open Archive");
          }
          
          [zipArchive release];
          
          ////
          
           //  [fileManager copyItemAtPath:defaultStorePath toPath:storeFileName error:NULL];
       }
	}


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
   
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}



#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
    }
    
	if(curReach == internetReach)
	{	
		
        self.internetConnectionStatus= [curReach currentReachabilityStatus];
	}
	if(curReach == wifiReach)
	{
        self.wifiConnectionStatus =[curReach currentReachabilityStatus];
	}    
}

@end
