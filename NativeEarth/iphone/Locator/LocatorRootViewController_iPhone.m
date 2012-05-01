 //
//  LocatorRootViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocatorRootViewController_iPhone.h"
#import "Reachability.h"
#import "NationSelectViewController_iPhone.h"
#import "BrowseViewController_iPhone.h"
#import "MapLookUpViewController_iPhone.h"
#import "LocationInfoViewController_iPhone.h"


//NSInteger nationDictSort(id nationDict1, id nationDict2, void *context) {
//    
//    double dist1=[[(NSDictionary *)nationDict1 valueForKey:@"Distance"] doubleValue];
//    double dist2=[[(NSDictionary *)nationDict2 valueForKey:@"Distance"] doubleValue];
//    NSInteger rv= NSOrderedSame;
//    if (dist1 < dist2)
//        rv= NSOrderedAscending;
//    else if (dist1 > dist2)
//        rv= NSOrderedDescending;
//    
//    return rv;
//}

@implementation LocatorRootViewController_iPhone
@synthesize locationDetector;

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [locationDetector release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //add observer for updateArray notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUpdateArrayNotification:) 
                                                 name:@"UpdateArrayNotification"
                                               object:nil];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 4*kTableViewSectionHeaderHeight) style:UITableViewStyleGrouped];
    //self.myTableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    isLocationDetected=NO;
    self.view = self.tableView;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
    isLocationDetected = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.locationDetector.locationManager stopUpdatingLocation];
}

- (void)viewDidUnload{ 
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
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
	switch (indexPath.section) {
        case 0:
            cell.textLabel.text=NSLocalizedString(@"Current Location", @"Current Location"); 
            cell.imageView.image= [UIImage imageNamed:@"icon_location.png"];
            break;
        case 1:
            cell.textLabel.text=NSLocalizedString(@"Browse By First Nation Name",@"Browse By First Nation Name");
            cell.imageView.image= [UIImage imageNamed:@"list.png"];
            break;
        case 2:
            cell.textLabel.text=NSLocalizedString(@"Browse By Map",@"Browse By Map");
            cell.imageView.image= [UIImage imageNamed:@"72-pin.png"];
            break;
        default:
            break;
    }
    cell.textLabel.alpha=1.0;
    cell.userInteractionEnabled = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
			return 3;
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
    cell.imageView.image= nil;
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
            [self BrowseMap];
            break;
        default:
            break;
    }
}

#pragma mark - Navigation Methods
-(void)goHome {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)GoToCurrentLocation{        
        self.locationDetector =[[LocationDetector alloc]initWithRetrieveOption:Locally];

    self.locationDetector.delegate = self;
 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
   [self.locationDetector.locationManager startUpdatingLocation];

    
}
-(void)BrowseByName;{
    BrowseViewController_iPhone * nextVC = [[BrowseViewController_iPhone alloc]initWithNibName:@"BrowseViewController_iPhone" bundle:nil];
    
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.title= NSLocalizedString(@"Names", @"Names");
    nextVC.browseType = ForLocator;
    
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];

    
}

-(void)BrowseMap{
    MapLookUpViewController_iPhone * nextVC = [[MapLookUpViewController_iPhone alloc] initWithNibName:@"MapLookUpViewController_iPhone" bundle:nil];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.title= NSLocalizedString(@"The First Nation", @"The First Nation");
    
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];

}

#pragma  mark - LocationDetectorDelegate
-(void) NationUpdate:(NSArray *)nations{
    if (!isLocationDetected) {
        
     isLocationDetected=YES;
    
    NationSelectViewController_iPhone *nextVC = [[NationSelectViewController_iPhone alloc]initWithStyle:UITableViewStylePlain];
    
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    
    nextVC.nationDictArray= [NSMutableArray arrayWithArray: nations];
                             
   nextVC.originTitle = NSLocalizedString(@"You are here!", @"You are here!");
    nextVC.title= NSLocalizedString(@"Select a nation", @"Select a nation");
    nextVC.originLocation = currentlocation;
    nextVC.showOrigin=YES;
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
    }

}

-(void) LocationError:(NSError *)error{
    NSLog(@"%@",[error description]);
}

-(void) locationUpdate:(CLLocation *)location{
    currentlocation.latitude=location.coordinate.latitude;
    currentlocation.longitude = location.coordinate.longitude;
}

#pragma  mark - converter
-(NSArray *)GetWSNationsFromDictArray:(NSArray *) dictArray{
  
    NSMutableArray * wSNations = [[NSMutableArray alloc]init];
    for (NSDictionary* dict in dictArray) {
        [wSNations addObject:[self GetWSNationForDict:dict]];
    }
    return wSNations;
}

-(WSNation *)GetWSNationForDict:(NSDictionary *)dict{
    return  [[WSNation alloc] initWithDictionary:dict];
}

#pragma mark - notification observer methods
- (void) receiveUpdateArrayNotification:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"UpdateArrayNotification"]){
       // NSArray * updatesArray = (NSArray*)notification;
       // set the local veriable;
    }
    
}

@end
