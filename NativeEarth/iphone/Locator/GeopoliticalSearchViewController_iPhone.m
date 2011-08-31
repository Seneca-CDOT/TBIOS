//
//  GeopoliticalSearchViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeopoliticalSearchViewController_iPhone.h"


@implementation GeopoliticalSearchViewController_iPhone
@synthesize delegate,results,toolbar;
@synthesize  resultsTableView;


- (void)dealloc
{
    [self.resultsTableView release];
    [self.toolbar release];
    [self.results release];
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
    self.results = [[NSMutableArray alloc] init];
    self.resultsTableView.alwaysBounceVertical = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.toolbar =nil;
    self.resultsTableView= nil;
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

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [[(NSDictionary*)[self.results objectAtIndex:indexPath.row] valueForKey:@"formatted_address"] description];
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = nil;
      dict = [self.results objectAtIndex:indexPath.row];
    [delegate GeopoliticalSearchViewController:self didSelectAResult:dict];
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark- Search operation

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	Geocoder *geocoder = [[[Geocoder alloc] init] autorelease];
	geocoder.delegate = self;
	[geocoder getCoordinateForAddress:searchBar.text];
	
	[searchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
     [searchBar setShowsCancelButton:YES animated:YES];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
     [searchBar setShowsCancelButton:NO animated:YES];
}
#pragma mark - Geocoder Deledate
-(void)locationFound:(NSArray*)searchResults
{
	[self.results removeAllObjects];
    [self.results addObjectsFromArray:searchResults];
    [self.resultsTableView reloadData];
        self.resultsTableView.alwaysBounceVertical = YES;
}
#pragma mark - 
-(IBAction) CancelButtonAction:(id) sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
