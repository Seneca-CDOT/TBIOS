//
//  CurrentLocationViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationInfoViewController_iPhone.h"
#import "NativeEarthAppDelegate_iPhone.h"
#import "GreetingsViewController_iPhone.h"
#import "GazetterViewController_iPhone.h"
#import "ImageBrowser_iPhone.h"
#import "MapBrowserViewController_iPhone.h"
#import "WSLand.h"
#import "Constants.h"
#import "Toast+UIView.h"
typedef enum{
    sectionHeaderTitleName,
    sectionHeaderTitleDescription,
    sectionHeaderTitleGreetings,
    sectionHeaderTitleMap,
    sectionHeaderTitleImage,
    sectionHeaderTitleGazetter
    
} sectionHeaderTitle;
@implementation LocationInfoViewController_iPhone
@synthesize selectedLand;
@synthesize allLands;
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
    [self.selectedLand release];
    [self.allLands release];
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
    //[self.selectedLand retain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UpdatedLand" object:nil];
    language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
   
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 4*kTableViewSectionHeaderHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.view = self.tableView;
    
 
  //      NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate]; 
   //    [appDelegate.landGetter CheckForLandUpdatesByLandId:selectedLand.LandID];
        
   
  
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
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
            cell.textLabel.text=selectedLand.LandName;
            //cell.detailTextLabel.text = 
            cell.userInteractionEnabled = NO;
            break;
        case sectionHeaderTitleDescription:
          //  cell.textLabel.text=NSLocalizedString(@"Description",@"Description");
            cell.detailTextLabel.numberOfLines=0;
            if ([language compare:@"fr"]==0) {
                cell.detailTextLabel.text = selectedLand.LandDescriptionFrench;
            }else{
                cell.detailTextLabel.text = selectedLand.LandDescriptionEnglish;  
            }
             cell.userInteractionEnabled =NO;
            
            
            break;
        case sectionHeaderTitleGreetings:
            cell.textLabel.text=NSLocalizedString(@"Greetings",@"Greetings");
            if (((Land *)selectedLand).Greetings != nil) {
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha = 1;
            }else{
                cell.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.alpha = 0.5;
            }
            break;
        case sectionHeaderTitleMap:
            cell.textLabel.text=NSLocalizedString(@"Map",@"Map");
             cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha = 1;
        
            break;
        case sectionHeaderTitleImage:
            cell.textLabel.text=NSLocalizedString(@"IMage Gallery",@"Image Gallery");
            if (([((Land *)selectedLand).Images count] >0)) {
             cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.alpha = 1;
            }else{
                cell.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.alpha = 0.5;
            }
            break;
        case sectionHeaderTitleGazetter:
            cell.textLabel.text=NSLocalizedString(@"Gazetter",@"Gazetter");
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha = 1;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    NSString * title = [[NSString alloc]init];
	title = NSLocalizedString(@"The First Nation:",@"The First Nation:" );//((WSLand *)selectedLand).Name;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        NSString *description = @"[No Description]";
        if ([language compare:@"fr"]==0) {
                  if (selectedLand.LandDescriptionFrench != nil) description = selectedLand.LandDescriptionFrench;  
        }else{
            if (selectedLand.LandDescriptionEnglish != nil) description = selectedLand.LandDescriptionEnglish;  
        }

        CGSize s = [description sizeWithFont:[UIFont systemFontOfSize:15] 
                     constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
                         lineBreakMode:UILineBreakModeWordWrap];
        return s.height + 16; // Add padding

    }
       
    return kRegularCellRowHeight;
}



-(void) NavigateToGreetings{
    GreetingsViewController_iPhone * nextVC = [[GreetingsViewController_iPhone alloc]init];
    nextVC.title=NSLocalizedString(@"Greetings", @"Greetings");
    nextVC.greetings = (Greetings *)((Land *)selectedLand).Greetings;
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
    nextVC.managedObjectContext= self.managedObjectContext;
    
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
}

-(void) NavigateToMap{
    if (self.remoteHostStatus != NotReachable) {
        
    MapBrowserViewController_iPhone * nextVC = [[MapBrowserViewController_iPhone alloc] initWithNibName:@"MapBrowserViewController_iPhone" bundle:nil];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
    nextVC.managedObjectContext= self.managedObjectContext;
    nextVC.lands = self.allLands;
    nextVC.title=NSLocalizedString(@"Map",@"Map");
    [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];
    }else{
        //alert
    }
}
-(void) NavigateToImageGallery{
    if (self.remoteHostStatus != NotReachable) {
    ImageBrowser_iPhone * nextVC = [[ImageBrowser_iPhone alloc]initWithNibName:@"ImageBrowser_iPhone" bundle:nil];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
    nextVC.managedObjectContext= self.managedObjectContext;
    nextVC.managedImages = [((Land *)selectedLand).Images allObjects];
    nextVC.title= ((Land *)selectedLand).LandName;
    
    [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];
    }else{
        //alert
    }

   }
-(void) NavigateToGazetter{
    GazetterViewController_iPhone * nextVC = [[GazetterViewController_iPhone alloc]initWithNibName:@"GazetterViewController_iPhone" bundle:nil];
     nextVC.remoteHostStatus = self.remoteHostStatus;
     nextVC.internetConnectionStatus = self.internetConnectionStatus;
     nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
     nextVC.managedObjectContext= self.managedObjectContext;
    nextVC.title=NSLocalizedString(@"Gazetter",@"Gazetter");
    [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];

}

// Notification handler
- (void)updateUI:(NSNotification *)notif {
    if ([[notif name] isEqualToString:@"UpdatedLand"]){
  Land* updatedLand = (Land*) [notif object];
    self.selectedLand= updatedLand;
    [self.selectedLand retain];
   NSLog(@"Notification received in location info");
    [self.tableView reloadData];
    }
    
    self.title = selectedLand.LandName;
    
    [self.view makeToast:NSLocalizedString(@"        Date Updated.         ", @"        Date Updated.         ")                 duration:2.0
                position:@"bottom"];  
    
        
}

@end
