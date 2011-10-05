//
//  VisitPlannerRootViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VisitPlannerRootViewController_iPhone.h"
//#import "Reachability.h"
#import "AddAVisitViewController_iPhone.h"
#import "LandSelectViewController_iPhone.h"
#import "PlannedVisit.h"
#import "Land.h"
#import "NativeEarthAppDelegate_iPhone.h"
@implementation VisitPlannerRootViewController_iPhone

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

 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddNewVisit)];
    
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    plannedVisits= [appDelegate.landGetter GetAllPlannedVisits];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [plannedVisits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = ((PlannedVisit *)[plannedVisits objectAtIndex:indexPath.row]).Title;
    cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
   
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([plannedVisits count]>0) {
        
   
    LandSelectViewController_iPhone * nextVC = [[LandSelectViewController_iPhone alloc] init];
   // nextVC.managedObjectContext = self.managedObjectContext;
    // add reffering object too.
        
        nextVC.landArray =[NSMutableArray arrayWithArray: [((PlannedVisit*)[plannedVisits objectAtIndex:indexPath.row]).Lands allObjects]];
   nextVC.title = @"Lands";
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{
    ViewAVisitViewController_iPhone * nextVC = [[ViewAVisitViewController_iPhone alloc] initWithNibName:@"ViewAVisitViewController_iPhone" bundle:nil];
    nextVC.title = @"Trip Title";
    nextVC.managedObjectContext = self.managedObjectContext;
    nextVC.visit = (PlannedVisit *)[plannedVisits objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
}
#pragma mark -
#pragma mark Navigation Methods
- (void) goHome {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)AddNewVisit{
    AddAVisitViewController_iPhone * nextVC = [[AddAVisitViewController_iPhone alloc] initWithNibName:@"ViewAVisitViewController_iPhone" bundle:nil];
 
    nextVC.title = NSLocalizedString(@"New Visit",@"New Visit");
    nextVC.managedObjectContext = self.managedObjectContext;
    // will add visit object too.
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"PlannedVisit" inManagedObjectContext:self.managedObjectContext];
    nextVC.visit = [[PlannedVisit alloc]initWithEntity:entity insertIntoManagedObjectContext:nextVC.managedObjectContext];
    
    [self.navigationController presentModalViewController:nextVC animated:YES];
    [nextVC release];
}




@end


