//
//  LauncherViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LauncherViewController_iPhone.h"


@implementation LauncherViewController_iPhone

@synthesize   FirstNationLocatorBtn;
@synthesize  PlanAVisitBtn;
@synthesize  SettingsBtn;
@synthesize  infoBtn;

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
    // Do any additional setup after loading the view from its nib.
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma  mark - IBAction Methods

-(IBAction) FirstNationLocatorBtnAction:(id) sender{
    
}
-(IBAction) planAVisitBtnAction:(id) sender{
    
}

-(IBAction) goToSettings:(id) sender{
    
}
-(IBAction) infoBtnAction:(id) sender{
    
}


@end
