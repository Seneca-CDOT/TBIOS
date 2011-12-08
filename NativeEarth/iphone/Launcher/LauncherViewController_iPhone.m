//
//  LauncherViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LauncherViewController_iPhone.h"
#import "LocatorRootViewController_iPhone.h"
#import "VisitPlannerRootViewController_iPhone.h"
@implementation LauncherViewController_iPhone

@synthesize  FirstNationLocatorBtn;
@synthesize  PlanAVisitBtn;
@synthesize  SettingsBtn;
@synthesize  infoBtn;
@synthesize  okBtn;
@synthesize  launcherView;
@synthesize  infoView;
@synthesize  blackView;
@synthesize  containerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.launcherView release];
    [self.infoView release];
    [self.blackView release];
    [self.containerView release];
    [self.okBtn release];
    [self.FirstNationLocatorBtn release];
    [self.PlanAVisitBtn release];
    [self.SettingsBtn release];
    [self.infoBtn release];
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
    // R: 128 G: 90 B: 200
    UIColor *bgColor = [UIColor colorWithRed:(100.0 / 255.0) green:(150.0 / 255.0) blue:(40.0 / 255.0) alpha: 1];
    // Do any additional setup after loading the view from its nib.
    
    // create the container view which we will use for flip animation (centered horizontally)
	containerView = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.containerView];
    [self.launcherView setBackgroundColor:bgColor];
    [self.containerView addSubview:self.launcherView];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.FirstNationLocatorBtn =nil;
    self.PlanAVisitBtn =nil;
    self.SettingsBtn= nil;
    self.infoBtn= nil;
    self.okBtn = nil;
    self.launcherView=nil;
    self.infoView= nil;
    self.blackView= nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma  mark - IBAction Methods

-(IBAction) FirstNationLocatorBtnAction:(id) sender{
    LocatorRootViewController_iPhone * locatorRootVC = [[LocatorRootViewController_iPhone alloc]init];
    locatorRootVC.remoteHostStatus = self.remoteHostStatus;
    locatorRootVC.wifiConnectionStatus = self. wifiConnectionStatus;
    locatorRootVC.internetConnectionStatus = self.internetConnectionStatus;
    locatorRootVC.managedObjectContext= self.managedObjectContext;
    locatorRootVC.title = NSLocalizedString(@"Locator",@"Locator");
    
    UIBarButtonItem *homeBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:locatorRootVC action:@selector(goHome)];
	[locatorRootVC.navigationItem setLeftBarButtonItem:homeBtn];
	[homeBtn release];

    UINavigationController *LocatorNavigationController = [[UINavigationController alloc] initWithRootViewController:locatorRootVC];
   
  //  LocatorNavigationController.navigationBar.tintColor=[UIColor blackColor];
   // LocatorNavigationController.navigationBar.translucent=YES;
    [LocatorNavigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self presentModalViewController:LocatorNavigationController animated:YES];
	[locatorRootVC release];
    [LocatorNavigationController  release];
	

    
}
-(IBAction) planAVisitBtnAction:(id) sender{
    VisitPlannerRootViewController_iPhone * visitPlannerRootVC = [[VisitPlannerRootViewController_iPhone alloc]initWithNibName:@"VisitPlannerRootViewController_iPhone" bundle:nil];
    
    visitPlannerRootVC.title = NSLocalizedString(@"Saved Visits",@"Saved Visits");
    UIBarButtonItem *homeBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:visitPlannerRootVC action:@selector(goHome)];
	[visitPlannerRootVC.navigationItem setLeftBarButtonItem:homeBtn];
	[homeBtn release];
    
    visitPlannerRootVC.internetConnectionStatus = self.internetConnectionStatus;
    visitPlannerRootVC.wifiConnectionStatus = self.wifiConnectionStatus;
    visitPlannerRootVC.remoteHostStatus= self.remoteHostStatus;
    visitPlannerRootVC.managedObjectContext = self.managedObjectContext;
     UINavigationController *VisitPlannerNavigationController = [[UINavigationController alloc] initWithRootViewController:visitPlannerRootVC];
    
    VisitPlannerNavigationController.navigationBar.tintColor=[UIColor blackColor];
    VisitPlannerNavigationController.navigationBar.translucent=YES;
    [self presentModalViewController:VisitPlannerNavigationController animated:YES];
	[visitPlannerRootVC release];
    [VisitPlannerNavigationController  release];
}

-(IBAction) goToSettings:(id) sender{
    
}
-(IBAction) flipAction:(id) sender{
   
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	
	[UIView setAnimationTransition:([self.launcherView superview] ?
									UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
                           forView:containerView cache:YES];
	if ([infoView superview])
	{
		[infoView removeFromSuperview];
		[containerView addSubview:self.launcherView];
	}
	else
	{
		[self.launcherView removeFromSuperview];
		[containerView addSubview:infoView];
	}
	
	[UIView commitAnimations];
	
}


@end
