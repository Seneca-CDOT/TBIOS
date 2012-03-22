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
#import "MapBrowserViewController_iPhone.h"
#import "Constants.h"
#import "Toast+UIView.h"
#import "ScreenshotBrowser.h"
#import "PlannedVisit.h"
#import "EditAVisitViewController_iPhone.h"
typedef enum{
    rowTitleName,
    rowTitleGreetings,
    rowTitleMap,
    rowTitleScreenshots,
    rowCount
} rowTitle;

@implementation LocationInfoViewController_iPhone
@synthesize selectedNation;
@synthesize allNations;
@synthesize originLocation;
@synthesize originTitle;
@synthesize showOrigin;
@synthesize shouldLetAddToVisit;

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
    [self.selectedNation release];
    [self.allNations release];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UpdatedNation" object:nil];
    //appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    self.title = self.selectedNation.OfficialName; 
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0,4*kTableViewSectionHeaderHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (shouldLetAddToVisit) {    
    UIBarButtonItem * btnTrip =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_case.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(ShowActionSheet)];
    self.navigationItem.rightBarButtonItem = btnTrip;
    
    [btnTrip release];
    }
  
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
            cell.textLabel.text=selectedNation.OfficialName;
            //cell.detailTextLabel.text = 
            cell.userInteractionEnabled = NO;
            break;
        case rowTitleGreetings:
            cell.textLabel.text=NSLocalizedString(@"Greetings",@"Greetings");
            if (((Nation *)selectedNation).Greeting != nil) {
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

        case rowTitleScreenshots:
            cell.textLabel.text=NSLocalizedString(@"Saved Maps",@"Saved Maps");
            if ([self.selectedNation.Maps count] != 0){
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
        case rowTitleGreetings:
            [self NavigateToGreetings];
            break;
        case rowTitleMap:
            [self NavigateToMap];
            break;
        case rowTitleScreenshots:
            [self NavigateToScreenshotBrowser];
            break; 
        default:
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 1) {
//        NSString *description = @"[No Description]";
//        if ([language compare:@"fr"]==0) {
//                  if (selectedNation.LandDescriptionFrench != nil) description = selectedLand.LandDescriptionFrench;  
//        }else{
//            if (selectedLand.LandDescriptionEnglish != nil) description = selectedLand.LandDescriptionEnglish;  
//        }

//        CGSize s = [description sizeWithFont:[UIFont systemFontOfSize:15] 
//                     constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
//                         lineBreakMode:UILineBreakModeWordWrap];
//        return s.height + 16; // Add padding

//    }
       
    return kRegularCellRowHeight;
}


#pragma mark - navigation methods

-(void) NavigateToGreetings{
    GreetingViewController_iPhone * nextVC = [[GreetingViewController_iPhone alloc]initWithNibName:@"GreetingViewController_iPhone" bundle:nil];
    nextVC.title=NSLocalizedString(@"Greetings", @"Greetings");
  //  nextVC.language = ((Nation *)selectedNation).Language;
    nextVC.greeting = selectedNation.Greeting;
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
      
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
}

-(void) NavigateToMap{
    if (self.remoteHostStatus != NotReachable) {
        
    MapBrowserViewController_iPhone * nextVC = [[MapBrowserViewController_iPhone alloc] initWithNibName:@"MapBrowserViewController_iPhone" bundle:nil];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
    nextVC.nations = self.allNations;
    nextVC.showOrigin= self.showOrigin;
    nextVC.selectedNationName = ((Nation *)selectedNation).OfficialName;
    nextVC.originLocation= self.originLocation;
    nextVC.originAnnotationTitle= self.originTitle;
    nextVC.title=NSLocalizedString(@"Map",@"Map");
    [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];
    }else{
        //alert
    }
}

-(void)NavigateToScreenshotBrowser{
    ScreenshotBrowser *nextVC=[[ScreenshotBrowser alloc] initWithNibName:@"ScreenshotBrowser" bundle:nil];
    NSArray * maps = [self.selectedNation.Maps allObjects];
    nextVC.maps=[NSMutableArray arrayWithArray: maps];
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
}

#pragma mark- update
// Notification handler
- (void)updateUI:(NSNotification *)notif {
    if ([[notif name] isEqualToString:@"UpdatedNation"]){
  Nation* updatedNation = (Nation*) [notif object];
    self.selectedNation= updatedNation;
    [self.selectedNation retain];
   NSLog(@"Notification received in location info");
    [self.tableView reloadData];
    }
    
    self.title = selectedNation.OfficialName;
    [self.view makeToast:NSLocalizedString(@"        Date Updated.         ", @"        Date Updated.         ")                 duration:2.0
                position:@"bottom"];  
    
        
}


#pragma mark - actionsheet methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        // the user clicked one of the buttons
        if (buttonIndex == 0)
        {
            
            EditAVisitViewController_iPhone * nextVC = [[EditAVisitViewController_iPhone alloc] initWithNibName:@"EditAVisitViewController_iPhone" bundle:nil];
            
            nextVC.title = NSLocalizedString(@"New Visit",@"New Visit");
            
            nextVC.visit  = [appDelegate.model getNewPlannedVisit];
            [nextVC.visit addNationsObject:self.selectedNation];
            nextVC.presentationType = presentationTypeNavigate;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC release];
            
            
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
