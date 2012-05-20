//
//  NationSelectViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NationSelectViewController_iPhone.h"
#import "LocationInfoViewController_iPhone.h"
#import "WSNation.h"
#import "NativeEarthAppDelegate_iPhone.h"
#import "Toast+UIView.h"

NSInteger nationDistSort(id nation1, id nation2, void *context) {
   
    double dist1=[((Nation*)nation1).Distance doubleValue];
    double dist2=[((Nation*)nation2).Distance doubleValue];
    NSInteger rv= NSOrderedSame;
    if (dist1 < dist2)
        rv= NSOrderedAscending;
    else if (dist1 > dist2)
        rv= NSOrderedDescending;
    
   return rv;
}


@implementation NationSelectViewController_iPhone

@synthesize nationArray;
@synthesize originLocation;
@synthesize originTitle;
@synthesize showOrigin;
@synthesize selectedNation;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    return self;
}

- (void)dealloc
{
    
    [self.selectedNation release];
    [self.nationArray release];
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
language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
 self.nationArray =[NSMutableArray arrayWithArray:[self.nationArray sortedArrayUsingFunction:nationDistSort context:nil]] ;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.nationArray count];
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
      return NSLocalizedString(@"Nearby Nations:", @"Nearby Nations:");
    }
    return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
        
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle= UITableViewCellSelectionStyleGray;
     if(indexPath.section==0){
        if ([self.nationArray count]>0) {
            Nation * nation = (Nation *)[self.nationArray objectAtIndex:indexPath.row];         NSNumber * distance =nation.Distance;
            
            cell.textLabel.text = nation.OfficialName;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.2f Km", [distance doubleValue]];
            cell.userInteractionEnabled= YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha=1.0;
        }
        else{
            cell.textLabel.text= NSLocalizedString(@"No first nation is detected nearby your location.", @"No first nation is detected in your location." );
            cell.userInteractionEnabled= NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.alpha=0.5;
        }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    if(indexPath.section==0){
        if ([self.nationArray count]>0) {
            
            LocationInfoViewController_iPhone *nextVC= [[LocationInfoViewController_iPhone alloc] initWithNibName:nil bundle:nil];
            // ...
            // Pass the selected object to the new view controller.
            selectedNation =[self.nationArray objectAtIndex:indexPath.row] ;
            
            //[landArray objectAtIndex:indexPath.section];    
            //ask for the land to be updates  
            NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate]; 
            [appDelegate.model setNationToBeUpdatedByNationNumber:[self.selectedNation.Number intValue]];
        
            nextVC.selectedNation= self.selectedNation;
            nextVC.originLocation = self.originLocation;
            nextVC.originTitle = self.originTitle;
            nextVC.allNations = self.nationArray;
            nextVC.showOrigin =self.showOrigin;
            nextVC.shouldLetAddToVisit=YES;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC release];
        }

    }
     
}


// Notification handler
- (void)updateUI:(NSNotification *)notif {
    if ([[notif name] isEqualToString:@"UpdatedNation"]){
        Nation* updatedNation = (Nation*) [notif object];
        int index=  [self.nationArray  indexOfObjectIdenticalTo:selectedNation] ; 
        [selectedNation setValue:updatedNation forKey:@"Nation"];
        [self.nationArray replaceObjectAtIndex:index withObject:selectedNation];
        NSLog(@"Notification received in location info");
       [self.tableView reloadData];
    
    }
    
    //notify user
    [self.view makeToast:NSLocalizedString(@"        Date Updated.         ", @"        Date Updated.         ")                 duration:2.0
                position:@"bottom"];  
    
    
}

@end
