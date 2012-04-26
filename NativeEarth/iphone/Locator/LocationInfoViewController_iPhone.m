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
#import "LandsViewController_iPhone.h"


typedef enum{
    rowTitleAddess,
    rowTitleGreetings,
    rowTitleLands,
    rowTitleMap,
    rowTitleCommunitySite,
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
    appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    self.title = self.selectedNation.OfficialName; 
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0,4*kTableViewSectionHeaderHeight) style:UITableViewStyleGrouped];
    
   // hasAddress=(self.selectedNation.Address ==nil) ?0:1;
   // hasComunitySite=(self.selectedNation.CommunitySite==nil)?0:1;
  //  hasGreeting=(self.selectedNation.greeting==nil)?0:1;
    
    
    
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (shouldLetAddToVisit) {    
    UIBarButtonItem * btnTrip =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_case.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(AddVisit)];
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
    cell.textLabel.font= [UIFont boldSystemFontOfSize:15] ;
    cell.detailTextLabel.font= [UIFont systemFontOfSize:15] ;
    cell.detailTextLabel.numberOfLines=0;
    cell.textLabel.alpha=1.0;
    cell.hidden=NO;
    [cell setAlpha:1.0];
    if (indexPath.section==0) {
        
	switch (indexPath.row) {
        case rowTitleAddess:
            cell.textLabel.text= NSLocalizedString(@"Center Address:", @"Center Address:");
            cell.detailTextLabel.text= selectedNation.Address;
            cell.userInteractionEnabled = NO;
            break;
      case  rowTitleLands:
            
            cell.textLabel.text=NSLocalizedString(@"Lands",@"Lands");
            if ([selectedNation.Lands count]>0) {
                cell.userInteractionEnabled = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.alpha = 0.5;
                
            }
            break;
        case rowTitleGreetings:
            cell.textLabel.text=NSLocalizedString(@"Greetings",@"Greetings");
            if (selectedNation.greeting!= nil) {
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        case rowTitleCommunitySite:
            if (self.selectedNation.CommunitySite!=nil) {
            cell.textLabel.text=NSLocalizedString(@"Open Community Website in Safary",@"Open Comunity Website in Safary");
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha = 1;
            }else{
                cell.textLabel.text=NSLocalizedString(@"No Community Website is Detected",@"No Comunity Website is Detected");
                cell.userInteractionEnabled=NO;
                cell.textLabel.alpha = 0.5;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case rowTitleScreenshots:
            cell.textLabel.text=NSLocalizedString(@"Saved Maps",@"Saved Maps");
            if ([self.selectedNation.Maps count] != 0){
                cell.userInteractionEnabled = YES; 
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
    }else{
        cell.textLabel.text=NSLocalizedString(@"View this nation with all the other nations on the map",@"View this nation with all the other nations on the map");
        cell.userInteractionEnabled = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.alpha = 1;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger rv =1;
    if ([self.allNations count]>1) {
        rv=2;
    }
    return rv;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    if (section==0) {
        return rowCount;
    }
    else return 1;
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
	if (section==0) {
    NSString * title = [[NSString alloc]init];
	title = selectedNation.OfficialName;
	return title;
    }
    else return @"";
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section==0) {
    switch (indexPath.row) {
        case rowTitleAddess: 
          break;
        case rowTitleLands:
            [self NavigateToLands];
            break;
        case rowTitleGreetings:
            [self NavigateToGreetings];
            break;
        case rowTitleMap:
            [self NavigateToMap];
            break;
        case rowTitleCommunitySite:
            [self OpenCommunitySite];
           
            break;    
        case rowTitleScreenshots:
            [self NavigateToScreenshotBrowser];
            break; 
        default:
            break;
    } 
  }else{
      [self NavigateToAllMaps];
  }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row == rowTitleAddess) {
        NSString *address = @"";
        if (selectedNation.Address != nil) address = selectedNation.Address;  
        CGSize s = [address sizeWithFont:[UIFont systemFontOfSize:15] 
                     constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
                         lineBreakMode:UILineBreakModeWordWrap];
        return s.height + 16 +16; // Add padding

    }else if(indexPath.section==1){
        return kRegularCellRowHeight +16;
    }
       
    return kRegularCellRowHeight;
}


#pragma mark - navigation methods

-(void) NavigateToGreetings{
    GreetingViewController_iPhone * nextVC = [[GreetingViewController_iPhone alloc]initWithNibName:@"GreetingViewController_iPhone" bundle:nil];
    nextVC.title=NSLocalizedString(@"Greetings", @"Greetings");
   ( (GreetingViewController_iPhone*)nextVC).greeting = (Greeting*)[selectedNation valueForKey:@"greeting"];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
      
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
}

-(void)NavigateToLands{

    LandsViewController_iPhone * nextVC =[[LandsViewController_iPhone alloc] initWithStyle:UITableViewStylePlain];
   NSArray * lands = [self.selectedNation.Lands allObjects];
    nextVC.landList = [NSMutableArray arrayWithArray:lands];
   // [lands release];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
    nextVC.referringNation = self.selectedNation;
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
    
}

-(void) NavigateToMap{
    if (self.remoteHostStatus != NotReachable) {
        
    MapBrowserViewController_iPhone * nextVC = [[MapBrowserViewController_iPhone alloc] initWithNibName:@"MapBrowserViewController_iPhone" bundle:nil];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
   // nextVC.nations = self.allNations;
    nextVC.referringNation = self.selectedNation;
    nextVC.showOrigin= self.showOrigin;
    nextVC.isBrowsingNation=YES;
    nextVC.selectedNationName = selectedNation.OfficialName;
    nextVC.originLocation= self.originLocation;
    nextVC.originAnnotationTitle= self.originTitle;
    nextVC.title=NSLocalizedString(@"Map",@"Map");
    [self.navigationController pushViewController:nextVC animated:YES];
      [nextVC release];
    }else{
        [self.view makeToast:NSLocalizedString(@"      No Network Connection       ", @"      No Network Connection       ")                 duration:2.0
                    position:@"bottom"]; 
    }
}

-(void) NavigateToAllMaps{
    if (self.remoteHostStatus != NotReachable) {
        
        MapBrowserViewController_iPhone * nextVC = [[MapBrowserViewController_iPhone alloc] initWithNibName:@"MapBrowserViewController_iPhone" bundle:nil];
        nextVC.remoteHostStatus = self.remoteHostStatus;
        nextVC.internetConnectionStatus = self.internetConnectionStatus;
        nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
        nextVC.nations = self.allNations;
        nextVC.referringNation = self.selectedNation;
        nextVC.showOrigin= self.showOrigin;
        nextVC.isBrowsingNation=YES;
        nextVC.selectedNationName = selectedNation.OfficialName;
        nextVC.originLocation= self.originLocation;
        nextVC.originAnnotationTitle= self.originTitle;
        nextVC.title=NSLocalizedString(@"All Detected Nations",@"All Detected Nations");
        [self.navigationController pushViewController:nextVC animated:YES];
        [nextVC release];
    }else{
        [self.view makeToast:NSLocalizedString(@"      No Network Connection       ", @"      No Network Connection       ")                 duration:2.0
                    position:@"bottom"]; 
    }

}

-(void) OpenCommunitySite{
 
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.selectedNation.CommunitySite]];
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




-(void)AddVisit{

    EditAVisitViewController_iPhone * nextVC = [[EditAVisitViewController_iPhone alloc] init];
    nextVC.isNew=YES;
    PlannedVisit * visit = [appDelegate.model getNewPlannedVisit];
    [visit addNationsObject:self.selectedNation];
    nextVC.visit = visit;
    [visit release];
    
    nextVC.title = NSLocalizedString(@"New Visit",@"New Visit");
    
    nextVC.presentationType = presentationTypeModal;
    nextVC.hidesBottomBarWhenPushed=NO;
    
    nextVC.delegate=self;
    UINavigationController *cntrol = [[UINavigationController alloc] initWithRootViewController:nextVC];
    cntrol.navigationBar.barStyle=UIBarStyleBlack;
    [self.navigationController presentModalViewController:cntrol animated:YES];
    [nextVC release];
    [cntrol release];

}
-(void) EditAVisitViewControllerDidSave:(EditAVisitViewController_iPhone*) controller{
    [controller dismissModalViewControllerAnimated:YES];
}

@end
