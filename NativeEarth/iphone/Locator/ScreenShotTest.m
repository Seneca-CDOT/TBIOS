//
//  ScreenShotTest.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScreenShotTest.h"


@implementation ScreenShotTest
@synthesize map;
@synthesize imageView;
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
    [map release];
    [imageView release];
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
    self.imageView.image= map.Image;
    
    ///work here more:
    UIBarButtonItem * deleteButton= [[UIBarButtonItem alloc]init];
    [deleteButton setTitle:@"Delete"];
    
     self.navigationItem.rightBarButtonItem = self.editButtonItem;

   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
