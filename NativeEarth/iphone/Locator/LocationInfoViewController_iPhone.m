//
//  CurrentLocationViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationInfoViewController_iPhone.h"
#import "NativeEarthAppDelegate_iPhone.h"
#import "GreetingViewController_iPhone.h"
#import "GazetterViewController_iPhone.h"
#import "ImageBrowser_iPhone.h"
#import "MapBrowserViewController_iPhone.h"
#import "Constants.h"
#import "Toast+UIView.h"
#import "ScreenshotBrowser.h"
#import "PlannedVisit.h"
#import "EditAVisitViewController_iPhone.h"
typedef enum{
    rowTitleName,
    rowTitleDescription,
    rowTitleGreetings,
    rowTitleMap,
    rowTitleScreenshots,
  //  rowTitleImage,
    rowTitleGazetter,

    rowCount
    
} rowTitle;
@implementation LocationInfoViewController_iPhone
@synthesize selectedLand;
@synthesize allLands;
@synthesize originLocation;
@synthesize originTitle;
@synthesize showOrigin;
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
    [self.originTitle release];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UpdatedLand" object:nil];
    language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    self.title = self.selectedLand.LandName; 
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0,4*kTableViewSectionHeaderHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIBarButtonItem * btnTrip =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_case.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(ShowActionSheet)];
    
    //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(addToVisits:)];

    self.navigationItem.rightBarButtonItem = btnTrip;
    [btnTrip release];
    self.view = self.tableView;
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [super viewWillAppear:animated];
    language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
	[self.tableView reloadData];
}


 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView Data Source and Delegate Methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
	switch (indexPath.row) {
        case rowTitleName:
            cell.textLabel.text=selectedLand.LandName;
            //cell.detailTextLabel.text = 
            cell.userInteractionEnabled = NO;
            break;
        case rowTitleDescription:
            cell.detailTextLabel.numberOfLines=0;
            if ([language compare:@"fr"]==0) {
                cell.detailTextLabel.text = selectedLand.LandDescriptionFrench;
            }else{
                cell.detailTextLabel.text = selectedLand.LandDescriptionEnglish;  
            }
             cell.userInteractionEnabled =NO;
            
            
            break;
        case rowTitleGreetings:
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
        case rowTitleMap:
            cell.textLabel.text=NSLocalizedString(@"Map",@"Map");
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha = 1;
            break;
//                
//        case rowTitleImage:
//            cell.textLabel.text=NSLocalizedString(@"IMage Gallery",@"Image Gallery");
//            if (([((Land *)selectedLand).Images count] >0)) {
//             cell.userInteractionEnabled = YES;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                cell.textLabel.alpha = 1;
//            }else{
//                cell.userInteractionEnabled = NO;
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.textLabel.alpha = 0.5;
//            }
//            break;
        case rowTitleGazetter:
            cell.textLabel.text=NSLocalizedString(@"Gazetter",@"Gazetter");
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha = 1;
            break;
        case rowTitleScreenshots:
            cell.textLabel.text=NSLocalizedString(@"Saved Maps",@"Saved Maps");
            if ([self.selectedLand.Maps count] != 0){
                cell.userInteractionEnabled = YES; 
                cell.textLabel.alpha = 1; 
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else{
                cell.userInteractionEnabled=NO;
                cell.textLabel.alpha = 0.5;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
           
          
        default:
            break;
    }
    cell.textLabel.alpha=1.0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return rowCount;
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
        case rowTitleName:
          break;
        case rowTitleDescription:
           break;
        case rowTitleGreetings:
            [self NavigateToGreetings];
            break;
        case rowTitleMap:
            [self NavigateToMap];
            break;
        case rowTitleScreenshots:
            [self NavigateToScreenshotBrowser];
            break;
//        case rowTitleImage:
//            [self NavigateToImageGallery];
//            break;
        case rowTitleGazetter:
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
    GreetingViewController_iPhone * nextVC = [[GreetingViewController_iPhone alloc]initWithNibName:@"GreetingViewController_iPhone" bundle:nil];
    nextVC.title=NSLocalizedString(@"Greetings", @"Greetings");
    nextVC.language = ((Land *)selectedLand).Language;
    nextVC.greetings = [(NSMutableSet *)((Land *)selectedLand).Greetings allObjects];
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
    nextVC.showOrigin= self.showOrigin;
    nextVC.selectedLandName = ((Land *)selectedLand).LandName;
    nextVC.originLocation= self.originLocation;
    nextVC.originAnnotationTitle= self.originTitle;
    nextVC.title=NSLocalizedString(@"Map",@"Map");
    [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];
    }else{
        //alert
    }
}


//-(void) NavigateToImageGallery{
//    if (self.remoteHostStatus != NotReachable) {
//    ImageBrowser_iPhone * nextVC = [[ImageBrowser_iPhone alloc]initWithNibName:@"ImageBrowser_iPhone" bundle:nil];
//    nextVC.remoteHostStatus = self.remoteHostStatus;
//    nextVC.internetConnectionStatus = self.internetConnectionStatus;
//    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
//    nextVC.managedObjectContext= self.managedObjectContext;
//    nextVC.managedImages = [((Land *)selectedLand).Images allObjects];
//    nextVC.title= ((Land *)selectedLand).LandName;
//    
//    [self.navigationController pushViewController:nextVC animated:YES];
//      [nextVC release];
//    }else{
//        //alert
//    }
//
//   }
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
-(void)NavigateToScreenshotBrowser{
    ScreenshotBrowser *nextVC=[[ScreenshotBrowser alloc] initWithNibName:@"ScreenshotBrowser" bundle:nil];
    NSArray * maps = [self.selectedLand.Maps allObjects];
    nextVC.maps=[NSMutableArray arrayWithArray: maps];
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



    - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        // the user clicked one of the buttons
        if (buttonIndex == 0)
        {
            
//            [self SetBackControls];
//            BrowseViewController_iPhone * nextVC = [[BrowseViewController_iPhone alloc]initWithNibName:@"BrowseViewController_iPhone" bundle:nil];
//            nextVC.remoteHostStatus = self.remoteHostStatus;
//            nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
//            nextVC.internetConnectionStatus = self.internetConnectionStatus;
//            nextVC.managedObjectContext = self.managedObjectContext;
//            nextVC.title= NSLocalizedString(@"Names", @"Names");
//            nextVC.browseType = ForVisitPlanner;
//            nextVC.delegate = self;
//            
//            [self.navigationController presentModalViewController:nextVC animated:YES];
//            [nextVC release];
            
        } else if (buttonIndex == 1){
            //[self SetBackControls];
        }else
        {
           // [self SetBackControls];
        }
    }


-(void)ShowActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:NSLocalizedString(@"Plan a Visit:", @"Plan a Visit:")
                                  delegate:self 
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") 
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: NSLocalizedString(@"New Visit Plan",@"New Visit Plan"), NSLocalizedString(@"Existng Visit Plan",@"Existng Visit Plan"), nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; 
	[actionSheet release];
}



@end
