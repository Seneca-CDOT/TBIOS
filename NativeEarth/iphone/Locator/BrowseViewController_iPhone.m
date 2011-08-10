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
#import "LocalLandGetter.h"

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
    //[filteredList release];
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
    landIsSelected = NO;
    if (browseType== ForLocator) {
        [self.toolbar setHidden:YES];
        [self.resultsTableView removeFromSuperview];
        self.view = self.resultsTableView;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view from its nib.
    [self GetFirstNationListLocally];
    
   // [self GetFirstNationListFromWebService];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - local data retrival opertion
-(void) GetFirstNationListLocally{
    LandShortArray * landShortArray = [[LandShortArray alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.completeList = (NSArray*)landShortArray;
    self.filteredList = [NSMutableArray arrayWithCapacity:[self.completeList count]];
    [self.resultsTableView reloadData];
	self.resultsTableView.scrollEnabled = YES;
}


-(void )GetLandLocallyByLandID:(int) landID{
    LocalLandGetter * landGetter = [[LocalLandGetter alloc] initWithManagedObjectContext:self.managedObjectContext];
   Land * selectedLand = [landGetter GetLandWithLandID:landID];
    
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
}

#pragma mark - Network operations
-(void) GetFirstNationListFromWebService{
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
      //[self GetFirstNationLandFromWebServiceWithLandID:landShort.landId];
      [self GetLandLocallyByLandID:[landShort.landId  intValue]];

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
	for (NSDictionary *nation in self.completeList)
	{
        NSComparisonResult result = [[nation valueForKey:@"Name"] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
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
#pragma  mark - NetworkDataGetter Delegate

-(void)DataUpdate:(id)object{
    if (!landIsSelected) {
    //self.completeList = (NSArray*)object;
    //self.filteredList = [NSMutableArray arrayWithCapacity:[self.completeList count]];
    //[self.resultsTableView reloadData];
	// self.resultsTableView.scrollEnabled = YES;
    }
    else{
        WSLand * selectedLand = [[WSLand alloc] initWithDictionary:(NSDictionary*)object];
        
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
    }
        
}
-(void)DataError:(NSError *)error{
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"%@", [error description]);
}

@end
