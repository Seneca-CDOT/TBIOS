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
#import "ShortNation.h"
#import "Model.h"
#import "NativeEarthAppDelegate_iPhone.h"
#import "Toast+UIView.h"
@implementation BrowseViewController_iPhone
@synthesize browseType;
@synthesize completeList;
@synthesize filteredList;
@synthesize  dataStream;
@synthesize delegate;
@synthesize resultsTableView;
@synthesize toolbar;
@synthesize searchBar;
@synthesize searchDisplayController;

- (void)dealloc
{
    [searchBar release];
    [searchDisplayController release];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UpdatedNation" object:nil];
    CGRect frame = CGRectMake(0, 0,  [self.searchBar frame].size.width, 44);
                    
    [self.searchBar setBounds:frame];
    nationIsSelected = NO;
    if (browseType== ForLocator) {
        [self.toolbar setHidden:YES];
        [self.resultsTableView removeFromSuperview];
        self.view = self.resultsTableView;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view from its nib.
    [self GetShortNationList];
    
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
    self.searchDisplayController =nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    nationIsSelected = NO;
    [self GetShortNationList];
}
-(void)viewDidDisappear:(BOOL)animated{
     [self.searchDisplayController setActive:NO];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - local data retrival opertion
-(void) GetShortNationList{
     NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    if (self.completeList!= nil) {
        [self.completeList removeAllObjects];
    }
    self.completeList = [NSMutableArray arrayWithArray: appDelegate.model.shortNationList];
    [self.completeList retain];
 //   NSLog(@"initial complete list in browser:");
 //   NSLog(@"%@",[self.completeList description]);
    self.filteredList = [NSMutableArray arrayWithCapacity:[self.completeList count]];
    [self.resultsTableView reloadData];
	self.resultsTableView.scrollEnabled = YES;
}


-(Nation* )GetNationByNationNumber:(int) number{
   NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
   Nation * selectedNation = [appDelegate.model getNationWithNationNumber:number];
    return selectedNation;
   }


#pragma mark - TableView datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.completeList count]>0)
    return 1;
    else return 0;
}
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
   ShortNation * nation ;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        nation = (ShortNation*)[self.filteredList objectAtIndex:indexPath.row];
    }
	else
	{
        nation = (ShortNation*)[self.completeList objectAtIndex:indexPath.row];
    }
    
    
    cell.textLabel.text = nation.OfficialName;
	cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nationIsSelected = YES;
    /*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	ShortNation *shortNation = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        shortNation = [self.filteredList objectAtIndex:indexPath.row];
    }
	else
	{
        shortNation = [self.completeList objectAtIndex:indexPath.row];
    }
    
       
  if (browseType == ForLocator)  {
      Nation* selectedNation= [self GetNationByNationNumber:[shortNation.Number  intValue]];
      LocationInfoViewController_iPhone *nextVC = [[LocationInfoViewController_iPhone alloc] init];
      
      nextVC.remoteHostStatus = self.remoteHostStatus;
      nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
      nextVC.internetConnectionStatus = self.internetConnectionStatus;
      nextVC.selectedNation = selectedNation;
      
      NSArray * nations = [NSArray arrayWithObject:selectedNation];
      nextVC.allNations = nations;
      
      nextVC.title= selectedNation.OfficialName;
      nextVC.shouldLetAddToVisit=YES;
      [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];

    }else {
        [self.delegate BrowseViewControllerDidSelectNation:shortNation];
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
	for (ShortNation *nation in self.completeList)
	{
        NSComparisonResult result = [nation.OfficialName  compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
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

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}

#pragma mark - 
-(IBAction) CancelButtonAction:(id) sender{
    [self dismissModalViewControllerAnimated:YES];
}


// Notification handler
- (void)updateUI:(NSNotification *)notif {
    if ([[notif name] isEqualToString:@"NewList"]){
        NSLog(@"New List Notification received in browser");
         [self GetShortNationList];
    }else if ([[notif name] isEqualToString:@"UpdatedLand"]){
         NSLog(@"Updated nation Notification received in browser");
        [self GetShortNationList];

    }
    [self.view makeToast:NSLocalizedString(@"        Date Updated.         ", @"        Date Updated.         ")                 duration:2.0
                position:@"bottom"]; 
}

@end
