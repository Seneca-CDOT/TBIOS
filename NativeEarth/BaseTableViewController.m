//
//  BaseTableViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTableViewController.h"


@implementation BaseTableViewController


@synthesize internetConnectionStatus;
@synthesize wifiConnectionStatus;
@synthesize remoteHostStatus;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -  Network Reachability

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
