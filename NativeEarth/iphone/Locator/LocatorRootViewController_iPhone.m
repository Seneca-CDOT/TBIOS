//
//  LocatorRootViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocatorRootViewController_iPhone.h"
#import "Reachability.h"
#import "LocationInfoViewController_iPhone.h"
#import "BrowseViewController_iPhone.h"
#import "MapLookUpViewController_iPhone.h"
#import "GeoPoliticalLookupViewController_iPhone.h"
@implementation LocatorRootViewController_iPhone


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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 4*kTableViewSectionHeaderHeight) style:UITableViewStyleGrouped];
    //self.myTableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.view = self.tableView;
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
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

#pragma mark - TableView Data Source and Delegate Methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
        case 0:
            cell.textLabel.text=NSLocalizedString(@"Current Location", @"Current Location");            break;
        case 1:
            cell.textLabel.text=NSLocalizedString(@"Browse By First Nation Name",@"Browse By First Nation Name");
            break;
        case 2:
             cell.textLabel.text=NSLocalizedString(@"Browse By Geopolitcal Name",@"Browse By Geopolitcal Name");
            break;
        case 3:
            cell.textLabel.text=NSLocalizedString(@"Browse By Map",@"Browse By Map");
            break;
        default:
            break;
    }
    cell.textLabel.alpha=1.0;
    cell.userInteractionEnabled = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
			return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		return 1;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0)
        return NSLocalizedString(@"Select a method of browsing:", @"Select a method of browsing:");
    else return  nil;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            [self GoToCurrentLocation];
            break;
        case 1:
            [self BrowseByName];
            break;
        case 2:
            [self BrowseByGeopoliticalName];
            break;
        case 3:
            [self BrowseMap];
            break;
        default:
            break;
    }
}



#pragma mark -
#pragma mark Navigation Methods
- (void) goHome {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)GoToCurrentLocation{
    LocationInfoViewController_iPhone *nextVC = [[LocationInfoViewController_iPhone alloc]init];
  
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.managedObjectContext = self.managedObjectContext;
    nextVC.title= NSLocalizedString(@"Current Location", @"Current Location");
  
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
}
-(void)BrowseByName;{
    BrowseViewController_iPhone * nextVC = [[BrowseViewController_iPhone alloc]initWithNibName:@"BrowseViewController_iPhone" bundle:nil];
    
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.managedObjectContext = self.managedObjectContext;
    nextVC.title= NSLocalizedString(@"Names", @"Names");
    nextVC.browseType = ForLocator;
    
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];

    
}
-(void)BrowseByGeopoliticalName{
   GeoPoliticalLookupViewController_iPhone * nextVC = [[GeoPoliticalLookupViewController_iPhone alloc]initWithNibName:@"GeoPoliticalLookupViewController_iPhone" bundle:nil];
    
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.managedObjectContext = self.managedObjectContext;
    nextVC.title= NSLocalizedString(@"Geopolitical Name", @"Geopolitical Name");
    nextVC.geoLookupType = ForLocator;
    
    [self.navigationController pushViewController:nextVC animated:YES];

    [nextVC release];
}
-(void)BrowseMap{
    MapLookUpViewController_iPhone * nextVC = [[MapLookUpViewController_iPhone alloc] initWithNibName:@"MapLookUpViewController_iPhone" bundle:nil];
    //nextVC.remoteHostStatus = self.remoteHostStatus;
    //nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    //nextVC.internetConnectionStatus = self.internetConnectionStatus;
    //nextVC.managedObjectContext = self.managedObjectContext;
    nextVC.title= NSLocalizedString(@"The First Nation", @"The First Nation");
    
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];

}
@end
