//
//  NativeEarthAppDelegate_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NativeEarthAppDelegate_iPhone.h"

#import "LandShortArray.h"
#import "LandShort.h"
#import "LocalLandGetter.h"
#import "WSLand.h"

NSInteger firstNumSort(id str1, id str2, void *context) {
    int num1 = [str1 integerValue];
    int num2 = [str2 integerValue];
    
    if (num1 < num2)
        return NSOrderedAscending;
    else if (num1 > num2)
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

@implementation NativeEarthAppDelegate_iPhone

@synthesize viewController,updateArray;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application: application didFinishLaunchingWithOptions:launchOptions];
    // Status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
 
    self.viewController.internetConnectionStatus = self.internetConnectionStatus;
    self.viewController.wifiConnectionStatus = self.wifiConnectionStatus;
    self.viewController.remoteHostStatus = self.wifiConnectionStatus;
    self.viewController.managedObjectContext = self.managedObjectContext;
   
         updateCheckStarted=FALSE;
      updateCheckFinished=FALSE;
  
    [self.window addSubview:self.viewController.view];
    [self.window makeKeyAndVisible];
    return  YES;
}

- (void)dealloc
{
    
  //  [self.viewController release];
	[super dealloc];
}
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateStatusesWithReachability: curReach];
}
- (void) updateStatusesWithReachability: (Reachability*) curReach
{
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
	
    //check for updates
    if (!updateCheckStarted) {
    
    addArray  =[[NSMutableArray alloc] init];
    deleteArray  =[[NSMutableArray alloc] init];
    self.updateArray  =[[NSMutableArray alloc] init];
    if (remoteHostStatus!=NotReachable) {
            [self GetLandShortsFromWebService];
        }
        updateCheckStarted = YES;
    }
    
}

-(void) GetLandShortsFromWebService{
    NSString *url = @"http://localhost/~ladan/FirstNationList";
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
}
-(void) GetFirstNationLandFromWebServiceWithLandID:(NSNumber *)landID{
    //pass landID and language here:
    
    NSString *url = @"http://localhost/~ladan/Algonquin ";
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
    
}

#pragma mark - NetworkDataGetterDelegate Methods

-(void)DataUpdate:(id)object{
    if(!updateCheckFinished){// check for updates
        //first get the local dictionary 
        LandShortDictionary * localLandShortDict = [[LandShortDictionary alloc] initWithManagedObjectContext:self.managedObjectContext];

        //get the largest local land id 
        NSArray * localKeyArray= [localLandShortDict allKeys];
        int localLargestID = [[localKeyArray lastObject] intValue];
   
        //second get the network array:
        NSDictionary * networkDict = (NSDictionary* )object;
        NSArray * networkIDArray =[[networkDict allKeys] sortedArrayUsingFunction: firstNumSort context:NULL ];
    
        int netWorkLargestID =[[networkIDArray lastObject] intValue];
    
        // get the maximum of largest ids
        int max = MAX(localLargestID, netWorkLargestID);
        
        // figure out additiond, deletions and updates
        for (int i=0 ; i<=max; i++) {
            BOOL landExistLocally = [localKeyArray containsObject: [NSString stringWithFormat:@"%d",i]];
            BOOL landExistRemothly =[networkIDArray containsObject:[NSString stringWithFormat:@"%d",i]];
        
            if(landExistLocally && landExistRemothly){
                LandShort *l = (LandShort*)[localLandShortDict valueForKey:[NSString stringWithFormat:@"%d",i]];
                NSNumber  * localVersion=l.versionIdentifier;
                NSNumber * remotVersion=[[networkDict valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"VersionIdentifier"];
                if ([remotVersion intValue]!=[localVersion intValue]) {
                    [self.updateArray addObject:[NSNumber numberWithInt:i]];
                }
            }else if(landExistLocally){ // it should be deleted
                [deleteArray addObject:[NSNumber numberWithInt:i]];
            }else if (landExistRemothly){
                [addArray addObject:[NSNumber numberWithInt:i]];
            }
        
        }// end of for
        //apply deletes:
        if ([deleteArray count]>0) {
            LocalLandGetter * localLandGetter =[[LocalLandGetter alloc] initWithManagedObjectContext:self.managedObjectContext];
            for (NSNumber * n in deleteArray) {
                Land * land = [localLandGetter GetLandWithLandID:[n intValue]];
                [self.managedObjectContext deleteObject:land];
            }
            NSError * error;
            if(![self.managedObjectContext save:&error]){
            }
        } // end of deletion
        
        //post update notification (there is listener in location info view)
        if ([updateArray count]>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateArrayNotification" object:updateArray];        
        }
        //get objects to be addes

        for (NSNumber * n in addArray){
            [self GetFirstNationLandFromWebServiceWithLandID:n];
        }
        updateCheckFinished=YES;
    
    }else{// apply the additions
  
        WSLand * land = [[WSLand alloc] initWithDictionary:(NSDictionary*)object];
        
        Land * managedLand = [land ToManagedLand:self.managedObjectContext];

        NSError * error;
        if(![managedLand.managedObjectContext save:&error]){
            NSLog(@"%@",[error description]);
        } 
    }
    
}
-(void)DataError:(NSError *)error{
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"%@", [error description]);
}



@end

