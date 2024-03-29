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
#import <UIKit/UIKit.h>

typedef enum{
    rowTitleAddess,
    rowTitlePhone,
    rowTitleLands,
    rowTitleMap,
    rowTitleCommunitySite,
    rowTitleGreetings,
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
@synthesize deviceType;

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
    [self.deviceType release];
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
    self.deviceType=[UIDevice currentDevice].model;
    self.title = self.selectedNation.OfficialName; 
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0,4*kTableViewSectionHeaderHeight) style:UITableViewStyleGrouped];
    
    
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
      case rowTitlePhone: 
          
            cell.textLabel.text= NSLocalizedString(@"Phone: ", @"Phone:");
             [cell.detailTextLabel setTextColor:[UIColor grayColor]];
            if (selectedNation.Phone) {
                //add just enogh space to alighn the phone to left(no more)
            cell.detailTextLabel.text= [NSString stringWithFormat:@"%@                       ", selectedNation.Phone];
                if([self.deviceType isEqualToString:@"iPhone"])
                {
                cell.userInteractionEnabled = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.userInteractionEnabled = NO;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }else{
                cell.detailTextLabel.text= NSLocalizedString(@"Not Available                          ", @"Not Available                         ") ;
                 cell.textLabel.alpha = 0.5;
                cell.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            
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
            cell.textLabel.text=NSLocalizedString(@"Open Community Website in Safari",@"Open Comunity Website in Safari");
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha = 1;
            }else{
                cell.textLabel.text=NSLocalizedString(@"Community Website",@"Comunity Website");
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
        cell.textLabel.text=NSLocalizedString(@"View this nation with all other nations on the map",@"View this nation with all other nations on the map");
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
    
    static NSString *RegularCellIdentifier = @"RCell";
    static NSString *PhoneCellIdentifier = @"PCell";
    UITableViewCell *cell=nil;
    if (indexPath.section==0 && indexPath.row==rowTitlePhone) {
        cell = [tableView dequeueReusableCellWithIdentifier:PhoneCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PhoneCellIdentifier] autorelease];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:RegularCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RegularCellIdentifier] autorelease];
        }
    }
  
    
    // Configure the cell...
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section==0) {
    NSString * title =selectedNation.OfficialName; 
	
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
        case rowTitlePhone: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Do You want to Dial:",@"Do You want to Dial:") message:self.selectedNation.Phone delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") otherButtonTitles: NSLocalizedString(@"Dial",@"Dial"),nil];
            [alert show];
            [alert release];
        }
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
        
        return s.height+ 16 +16; // Add padding

    }
    else if(indexPath.section==1){
        return kRegularCellRowHeight +16;
    }
       
    return kRegularCellRowHeight;
}

#pragma mark- Alert View Delegate Method
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) 
        [self DialPhone];
   
   [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:rowTitlePhone inSection:0] animated:NO];
    
}
#pragma mark - navigation methods
-(void) DialPhone{
    NSString * telString = [self.selectedNation.Phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    telString = [telString stringByReplacingOccurrencesOfString:@") " withString:@"-"];
    @try {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel://%@",  telString]]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception description]);
    }   
      
}

-(void) NavigateToGreetings{
    GreetingViewController_iPhone * nextVC = [[GreetingViewController_iPhone alloc]initWithStyle:UITableViewStyleGrouped];
    nextVC.title=NSLocalizedString(@"Greetings", @"Greetings");
    nextVC.greeting=selectedNation.greeting;
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
   // NSLog(@"R:%d-I:%d-W:%d",self.remoteHostStatus ,self.internetConnectionStatus,self.wifiConnectionStatus);
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
}

-(void)NavigateToLands{

    LandsViewController_iPhone * nextVC =[[LandsViewController_iPhone alloc] initWithStyle:UITableViewStylePlain];
   NSArray * lands = [self.selectedNation.Lands allObjects];
    nextVC.landList = [NSMutableArray arrayWithArray:lands];
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
    if (self.remoteHostStatus != NotReachable) {

     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.selectedNation.CommunitySite]];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:rowTitleCommunitySite inSection:0] animated:NO];
    } else{
        [self.view makeToast:NSLocalizedString(@"      No Network Connection       ", @"      No Network Connection       ")                 duration:2.0
                    position:@"bottom"];
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




-(void)AddVisit{

   // EditAVisitViewController_iPhone * nextVC = [[EditAVisitViewController_iPhone alloc] init];
    EditAVisitViewController_iPhone * nextVC = [[EditAVisitViewController_iPhone alloc] initWithNibName:@"EditAVisitViewController_iphone" bundle:nil];
    nextVC.isNew=YES;
    PlannedVisit * visit = [appDelegate.model getNewPlannedVisit];
    [visit addNationsObject:self.selectedNation];
    nextVC.visit = visit;//never release visit , it is autorelease
  
    nextVC.title = NSLocalizedString(@"New Visit",@"New Visit");
    
    nextVC.presentationType = presentationTypeModal;
    nextVC.hidesBottomBarWhenPushed=NO;
    
    nextVC.delegate=self;
    UINavigationController *control = [[UINavigationController alloc] initWithRootViewController:nextVC];
    control.navigationBar.barStyle=UIBarStyleBlack;
    [self.navigationController presentModalViewController:control animated:YES];
    [nextVC release];
    [control release];

}
-(void) EditAVisitViewControllerDidSave:(EditAVisitViewController_iPhone*) controller{
    [controller dismissModalViewControllerAnimated:YES];
}

@end
