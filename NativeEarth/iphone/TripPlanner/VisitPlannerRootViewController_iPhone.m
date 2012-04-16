//
//  VisitPlannerRootViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VisitPlannerRootViewController_iPhone.h"

#import "ViewAVisitViewController_iPhone.h"
#import "NationSelectViewController_iPhone.h"
#import "PlannedVisit.h"
#import "Land.h"

@implementation VisitPlannerRootViewController_iPhone
@synthesize plannedVisits;
@synthesize dateFormatter;
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
    [plannedVisits release];
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
    
  appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    self.plannedVisits= [NSMutableArray arrayWithArray:[appDelegate.model getAllPlannedVisits]];
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];

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
    [self.plannedVisits removeAllObjects];
   self.plannedVisits= [NSMutableArray arrayWithArray:[appDelegate.model getAllPlannedVisits]];
   [self.tableView reloadData];
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
    return [self.plannedVisits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{ 
    PlannedVisit * visit =(PlannedVisit *)[plannedVisits objectAtIndex:indexPath.row];
    cell.selectionStyle= UITableViewCellSelectionStyleGray;
    cell.textLabel.text = visit.Title;
   
    if(visit.FromDate!=nil){
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ - %@",[self.dateFormatter stringFromDate:visit.FromDate],[self.dateFormatter stringFromDate:visit.ToDate]];
    }

    if([cell.textLabel.text length]==0)cell.textLabel.text=NSLocalizedString(@"New Visit", @"New Visit");
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
   
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([plannedVisits count]>0){
        PlannedVisit * visit = (PlannedVisit *)[self.plannedVisits objectAtIndex:indexPath.row];
        ViewAVisitViewController_iPhone * nextVC = [[ViewAVisitViewController_iPhone alloc] init];
        nextVC.title = visit.Title;
       
        nextVC.visit = visit;
        [self.navigationController pushViewController:nextVC animated:YES];
        [nextVC release]; 
    }
}


#pragma mark -
#pragma mark Navigation Methods
- (void) goHome {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)AddNewVisit{
    EditAVisitViewController_iPhone * nextVC = [[EditAVisitViewController_iPhone alloc] initWithNibName:@"EditAVisitViewController_iPhone" bundle:nil];
    nextVC.title = NSLocalizedString(@"New Visit",@"New Visit");
    nextVC.visit = [appDelegate.model getNewPlannedVisit];
     nextVC.isNew=YES;
    nextVC.presentationType = presentationTypeNavigate;
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
}


- (void)addAVisitViewController:(EditAVisitViewController_iPhone *)controller didFinishWithSave:(BOOL)save{
    if (save==YES) {
        [self.tableView reloadData];
    }
}

// DELEGATE PROTOCOL METHOD
// This method is called when the user asks to delete a row
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// You should think long and hard about whether you will permit deleting this way
	
    // Did the user request to delete the row?
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
				
		// Save the context.
		NSError *error= [appDelegate.model DeleteVisit:[plannedVisits objectAtIndex:indexPath.row]];
		if (error!=nil) {
			// Handle the error... (and do it better in a production app)
			NSLog(@"%@", [error description]);
		}
    }
    [self.plannedVisits removeAllObjects];
    self.plannedVisits=[NSMutableArray arrayWithArray:[appDelegate.model getAllPlannedVisits]];
    [self.tableView reloadData];
}



@end


