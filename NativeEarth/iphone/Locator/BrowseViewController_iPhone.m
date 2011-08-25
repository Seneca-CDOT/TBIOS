 //
//  BrowseViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowseViewController_iPhone.h"
#import "LocationInfoViewController_iPhone.h"
#import "JSON.h"
#import "LandShort.h"
#import "LandShortArray.h"
#import "LandGetter.h"
#import "NativeEarthAppDelegate_iPhone.h"

@implementation BrowseViewController_iPhone
@synthesize browseType;
@synthesize completeList;
@synthesize filteredList;
@synthesize  dataStream;
@synthesize delegate;
@synthesize resultsTableView;
@synthesize toolbar;
@synthesize searchBar;

- (void)dealloc
{
    [searchBar release];
    [resultsTableView release];
    [toolbar release];
    [dataStream release];
    [completeList release];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"NewList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UpdatedLand" object:nil];

    landIsSelected = NO;
    if (browseType== ForLocator) {
        [self.toolbar setHidden:YES];
        [self.resultsTableView removeFromSuperview];
        self.view = self.resultsTableView;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view from its nib.
    [self GetLandShortList];
    
}
-(void) awakeFromNib{
    [super awakeFromNib];
    }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.resultsTableView = nil;
    self.toolbar = nil;
    searchBar = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    landIsSelected = NO;
    [self GetLandShortList];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - local data retrival opertion
-(void) GetLandShortList{
     NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    if (self.completeList!= nil) {
        [self.completeList removeAllObjects];
    }
    self.completeList = [NSMutableArray arrayWithArray: appDelegate.landGetter.landShortList];
    [self.completeList retain];
    NSLog(@"initial completelist in browser:");
    NSLog(@"%@",[self.completeList description]);
    self.filteredList = [NSMutableArray arrayWithCapacity:[self.completeList count]];
    [self.resultsTableView reloadData];
	self.resultsTableView.scrollEnabled = YES;
}


-(Land* )GetLandByLandID:(int) landID{
   NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
   Land * selectedLand = [appDelegate.landGetter GetLandWithLandId:landID];
    
    return selectedLand;
   }


#pragma mark - TableView datasource and delegate

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredList count];
    }
	else
	{
        return [self.completeList count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kPlacesCellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlacesCellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kPlacesCellIdentifier] autorelease];
        if (browseType==ForLocator) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
                cell.accessoryType = UITableViewCellAccessoryNone; 
        }
    }
    
    /*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
   LandShort * nation ;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        nation = (LandShort*)[self.filteredList objectAtIndex:indexPath.row];
    }
	else
	{
        nation = (LandShort*)[self.completeList objectAtIndex:indexPath.row];
    }
    
    
    cell.textLabel.text = nation.landName;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    landIsSelected = YES;
    /*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	LandShort *landShort = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        landShort = [self.filteredList objectAtIndex:indexPath.row];
    }
	else
	{
        landShort = [self.completeList objectAtIndex:indexPath.row];
    }
    
       
  if (browseType == ForLocator)  {
      Land* selectedLand= [self GetLandByLandID:[landShort.landId  intValue]];
      LocationInfoViewController_iPhone *nextVC = [[LocationInfoViewController_iPhone alloc] init];
      
      nextVC.remoteHostStatus = self.remoteHostStatus;
      nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
      nextVC.internetConnectionStatus = self.internetConnectionStatus;
      nextVC.managedObjectContext = self.managedObjectContext;
      nextVC.selectedLand = selectedLand;
      
      NSArray * lands = [NSArray arrayWithObject:selectedLand];
      nextVC.allLands = lands;
      
      
      nextVC.title= selectedLand.LandName;
      
      [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];

    }else {
        [self.delegate BrowseViewControllerDidSelectFirstNation:landShort];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredList removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (LandShort *nation in self.completeList)
	{
        NSComparisonResult result = [nation.landName  compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredList addObject:nation];
        }
		
	}
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(IBAction) CancelButtonAction:(id) sender{
    [self dismissModalViewControllerAnimated:YES];
}


// Notification handler
- (void)updateUI:(NSNotification *)notif {
    if ([[notif name] isEqualToString:@"NewList"]){
        NSLog(@"New List Notification received in browser");
         [self GetLandShortList];
    }else if ([[notif name] isEqualToString:@"UpdatedLand"]){
         NSLog(@"Updated land Notification received in browser");
        [self GetLandShortList];

    }
}

@end
