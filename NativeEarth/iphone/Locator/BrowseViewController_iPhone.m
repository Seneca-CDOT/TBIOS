//
//  BrowseViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowseViewController_iPhone.h"
#import "JSON.h"

@implementation BrowseViewController_iPhone
@synthesize browseType;
@synthesize completeList;
@synthesize filteredList;
@synthesize  dataStream;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Do any additional setup after loading the view from its nib.
    [self GetFirstNationListFromWebService];
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



#pragma mark - Network operations
-(void) GetFirstNationListFromWebService{
    // Prepare the NSMutableData receiver
    dataStream = [[NSMutableData alloc] init];
	
	// Create a URL // we should be able to pass language and locationManager.coordinate latitude and longitude here:
    NSURL *url;
    
	if (browseType == ByName) {
        // use by name WS
         url = [NSURL URLWithString:@"http://localhost/~ladan/FirstNationList"];// fake webservice 
    }else if(browseType == ByGeopoliticalName)
    {
    // use by Geopolitical Name WS
     url = [NSURL URLWithString:@"http://localhost/~ladan/FirstNationList"];// fake webservice 
    }
    else{
    // and other criteria?
    }
      // Create a request
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
	// Create a connection
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    
	// Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	// Release the objects
    [request release];
	[connection release];
    
}
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// Implement this if you want
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// Append the incoming data to the data stream object
	[dataStream appendData:data]; 
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
	// Convert the data stream object to a string
	NSString *response = [[NSString alloc] initWithData:dataStream encoding:NSUTF8StringEncoding];
	
	
	// Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	// Load the response data string into the districts array
	
	self.completeList = [response JSONValue];
    self.filteredList = [NSMutableArray arrayWithCapacity:[self.completeList count]];
    
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
    
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	// Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"%@", [error description]);
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
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    /*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
    NSDictionary *nation = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        nation = [self.filteredList objectAtIndex:indexPath.row];
    }
	else
	{
        nation = [self.completeList objectAtIndex:indexPath.row];
    }
    
    
    cell.textLabel.text = [[nation valueForKey:@"Name"] description];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	NSDictionary *dict = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        dict = [self.filteredList objectAtIndex:indexPath.row];
    }
	else
	{
        dict = [self.completeList objectAtIndex:indexPath.row];
    }
    
    //    FirstNation * nation = [[FirstNation alloc]init];
    //    nation.name = [dict valueForKey:@"Name"];
    //    nation.latitude = [dict valueForKey:@"CenterLatitude"];
    //    nation.longitude = [dict valueForKey:@"CenterLongitude"];
    
    // [self.navigationController popViewControllerAnimated:YES];
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



@end
