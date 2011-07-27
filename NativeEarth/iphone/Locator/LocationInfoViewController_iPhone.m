//
//  CurrentLocationViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationInfoViewController_iPhone.h"
#import "GreetingsViewController_iPhone.h"
#import "GazetterViewController_iPhone.h"
#import "ImageBrowser_iPhone.h"
#import "MapBrowserViewController_iPhone.h"
typedef enum{
    sectionHeaderTitleName,
    sectionHeaderTitleDescription,
    sectionHeaderTitleGreetings,
    sectionHeaderTitleMap,
    sectionHeaderTitleImage,
    sectionHeaderTitleGazetter
    
} sectionHeaderTitle;
@implementation LocationInfoViewController_iPhone
@synthesize land;
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
    [self.land release];
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

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 4*kTableViewSectionHeaderHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.view = self.tableView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

#pragma mark - TableView Data Source and Delegate Methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
        case sectionHeaderTitleName:
            cell.textLabel.text=NSLocalizedString(@"Name", @"Name");
             cell.userInteractionEnabled = NO;
            break;
        case sectionHeaderTitleDescription:
            cell.textLabel.text=NSLocalizedString(@"Description",@"Description");
             cell.userInteractionEnabled = NO;
            
            break;
        case sectionHeaderTitleGreetings:
            cell.textLabel.text=NSLocalizedString(@"Greetings",@"Greetings");
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case sectionHeaderTitleMap:
            cell.textLabel.text=NSLocalizedString(@"Map",@"Map");
             cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case sectionHeaderTitleImage:
            cell.textLabel.text=NSLocalizedString(@"IMage Gallery",@"Image Gallery");
             cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case sectionHeaderTitleGazetter:
            cell.textLabel.text=NSLocalizedString(@"Gazetter",@"Gazetter");
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    cell.textLabel.alpha=1.0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
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


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    NSString * title = [[NSString alloc]init];
	title = @"title";
	return title;
}




- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
          break;
        case 1:
           break;
        case 2:
            [self NavigateToGreetings];
            break;
        case 3:
            [self NavigateToMap];
            break;
        case 4:
            [self NavigateToImageGallery];
            break;
        case 5:
            [self NavigateToGazetter];
            break;
        default:
            break;
    }
}




-(void) NavigateToGreetings{
    GreetingsViewController_iPhone * nextVC = [[GreetingsViewController_iPhone alloc]init];
    nextVC.title=@"Title";
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
    nextVC.managedObjectContext= self.managedObjectContext;
    
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
}

-(void) NavigateToMap{
    MapBrowserViewController_iPhone * nextVC = [[MapBrowserViewController_iPhone alloc] initWithNibName:@"MapBrowserViewController_iPhone" bundle:nil];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
    nextVC.managedObjectContext= self.managedObjectContext;
     nextVC.title=@"Title";
      [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];
}
-(void) NavigateToImageGallery{
    ImageBrowser_iPhone * nextVC = [[ImageBrowser_iPhone alloc]initWithNibName:@"ImageBrowser_iPhone" bundle:nil];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
    nextVC.managedObjectContext= self.managedObjectContext;
    nextVC.imageArray = [self loadImages];
     nextVC.title=@"Title";
    [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];

   }
-(void) NavigateToGazetter{
    GazetterViewController_iPhone * nextVC = [[GazetterViewController_iPhone alloc]initWithNibName:@"GazetterViewController_iPhone" bundle:nil];
     nextVC.remoteHostStatus = self.remoteHostStatus;
     nextVC.internetConnectionStatus = self.internetConnectionStatus;
     nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
     nextVC.managedObjectContext= self.managedObjectContext;
    [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];

}


- (UIImage *)imageAtIndex:(int)index {
    // use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching our images
    NSString *imageName = [NSString stringWithFormat:@"%d", index];
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];    
}
-(NSArray *) loadImages{
    int count = 6;
    NSMutableArray * ImagesArray = [[NSMutableArray alloc] init];
    for(int i=0; i<count ; i++){
        [ImagesArray addObject:[self imageAtIndex:i+1]];
    }
    return  ImagesArray;
}

@end
