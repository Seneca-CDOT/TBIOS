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

NSInteger nationDictSort(id nationDict1, id nationDict2, void *context) {
   
    double dist1=[[(NSMutableDictionary *)nationDict1 valueForKey:@"Distance"] doubleValue];
    double dist2=[[(NSMutableDictionary *)nationDict2 valueForKey:@"Distance"] doubleValue];
    
    if (dist1 < dist2)
        return NSOrderedAscending;
    else if (dist1 > dist2)
        return NSOrderedDescending;
    
    return NSOrderedSame;
}


@implementation NationSelectViewController_iPhone

@synthesize nationArray;
@synthesize originLocation;
@synthesize originTitle;
@synthesize nearbyNations;
@synthesize showOrigin;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    return self;
}

- (void)dealloc
{
    [self.nationArray release];
    [self.nearbyNations release];
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
    //[self.selectedNation retain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UpdatedNation" object:nil];
language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    NSMutableArray * tempArray = [[NSMutableArray alloc] initWithCapacity:[self.nationArray count]];
    for (NSDictionary * nationDict  in self.nationArray) {
        if([[nationDict valueForKey:@"Distance"] doubleValue]!=0.0 ){
           [tempArray addObject:nationDict];
        }
    }
    [self.nationArray removeObjectsInArray:tempArray];
    self.nearbyNations = [[NSArray arrayWithArray:tempArray] sortedArrayUsingFunction:nationDictSort
                                                                            context:nil];
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
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rv=1;
    int nationCount =[self.nationArray count];
    int nearByCount =[self.nearbyNations count];
    if (section==0 && nationCount>0) {
        rv=nationCount;
    }else if(section==1 && nearByCount>0){
        rv=nearByCount;
    }
    return rv;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return NSLocalizedString(@"You are Inside:", @"You are Inside:");
    }else if(section==1){
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
    if (indexPath.section ==0) {
        if ([self.nationArray count]>0) {
            Nation * nation = (Nation *)[(NSMutableDictionary *)[self.nationArray objectAtIndex:indexPath.row] valueForKey:@"Nation"];
           // NSNumber * distance = [(NSNumber *)[landArray objectAtIndex:indexPath.section] valueForKey:@"Distance"];
            // cell.textLabel.text =((Land *)[landArray objectAtIndex:indexPath.section]).LandName;
            cell.textLabel.text = nation.OfficialName;
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %lf Km", [distance doubleValue]];
            cell.userInteractionEnabled= YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha=1.0;
        }
        else{
            cell.textLabel.text= NSLocalizedString(@"No first nation is detected in your location.", @"No first nation  is detected in your location." );
            cell.userInteractionEnabled= NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.alpha=0.5;
        }
    }else if(indexPath.section==1){
        if ([self.nearbyNations count]>0) {
            Nation * nation = (Nation *)[(NSMutableDictionary *)[self.nearbyNations objectAtIndex:indexPath.row] valueForKey:@"Nation"];
            NSNumber * distance = [(NSNumber *)[self.nearbyNations objectAtIndex:indexPath.row] valueForKey:@"Distance"];
            cell.textLabel.text = nation.OfficialName;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %lf Km", [distance doubleValue]];
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
    if (indexPath.section==0) {
        if ([self.nationArray count]>0) {
        
            LocationInfoViewController_iPhone *nextVC= [[LocationInfoViewController_iPhone alloc] initWithNibName:nil bundle:nil];
            // ...
            // Pass the selected object to the new view controller.
            selectedNation=(Nation *)[(NSMutableDictionary *)[self.nationArray objectAtIndex:indexPath.row] valueForKey:@"Nation"];   
            //ask for the nation to be updates  
            NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate]; 
            [appDelegate.model setNationToBeUpdatedByNationNumber:[selectedNation.Number intValue]];
            nextVC.shouldLetAddToVisit=YES;
            nextVC.selectedNation = selectedNation;
            nextVC.originLocation = self.originLocation;
            nextVC.originTitle = self.originTitle;
            NSMutableArray *allNations =[[NSMutableArray alloc]initWithCapacity:[self.nearbyNations count]+[nationArray count]];
            for (NSMutableDictionary * dict in nationArray) {
                Nation * nation = (Nation*)[dict valueForKey:@"Nation"];
                [allNations addObject:nation];
            }  
            for (NSMutableDictionary * dict in self.nearbyNations) {
                Nation * nation = (Nation*)[dict valueForKey:@"Nation"];
                [allNations addObject:nation];
            } 
            nextVC.allNations = allNations;
            nextVC.showOrigin= self.showOrigin;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC release];
        }
    } else if(indexPath.section==1){
        if ([self.nearbyNations count]>0) {
            
            LocationInfoViewController_iPhone *nextVC= [[LocationInfoViewController_iPhone alloc] initWithNibName:nil bundle:nil];
            // ...
            // Pass the selected object to the new view controller.
            selectedNation =(Nation *)[(NSMutableDictionary *)[self.nearbyNations objectAtIndex:indexPath.row] valueForKey:@"Nation"];
            //[landArray objectAtIndex:indexPath.section];    
            //ask for the land to be updates  
            NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate]; 
            [appDelegate.model setNationToBeUpdatedByNationNumber:[selectedNation.Number intValue]];
            
            nextVC.selectedNation= selectedNation;
            nextVC.originLocation = self.originLocation;
            nextVC.originTitle = self.originTitle;
            NSMutableArray *allNations =[[NSMutableArray alloc]initWithCapacity:[self.nearbyNations count]+[self.nationArray count]];
            for (NSMutableDictionary * dict in self.nationArray) {
                Nation * nation = (Nation*)[dict valueForKey:@"Nation"];
                [allNations addObject:nation];
            }  
            for (NSMutableDictionary * dict in self.nearbyNations) {
                Nation * nation = (Nation*)[dict valueForKey:@"Nation"];
                [allNations addObject:nation];
            } 
            nextVC.allNations = allNations;
            nextVC.showOrigin =self.showOrigin;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC release];
        }

    }
     
}


// Notification handler
- (void)updateUI:(NSNotification *)notif {
    if ([[notif name] isEqualToString:@"UpdatedNation"]){
        Nation* updatedNation = (Nation*) [notif object];
        int index=[self.nationArray indexOfObject:selectedNation];
        [self.nationArray replaceObjectAtIndex:index withObject:updatedNation];
        
        
        NSLog(@"Notification received in location info");
        [self.tableView reloadData];
    }
    
    //notify user
    [self.view makeToast:NSLocalizedString(@"        Date Updated.         ", @"        Date Updated.         ")                 duration:2.0
                position:@"bottom"];  
    
    
}

@end
