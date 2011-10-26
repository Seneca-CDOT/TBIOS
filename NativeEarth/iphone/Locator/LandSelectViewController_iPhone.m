//
//  LandSelectViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LandSelectViewController_iPhone.h"
#import "LocationInfoViewController_iPhone.h"
#import "WSLand.h"
#import "NativeEarthAppDelegate_iPhone.h"
#import "Toast+UIView.h"

NSInteger landDictSort(id landDict1, id landDict2, void *context) {
   
    double dist1=[[(NSMutableDictionary *)landDict1 valueForKey:@"Distance"] doubleValue];
    double dist2=[[(NSMutableDictionary *)landDict2 valueForKey:@"Distance"] doubleValue];
    
    if (dist1 < dist2)
        return NSOrderedAscending;
    else if (dist1 > dist2)
        return NSOrderedDescending;
    
    return NSOrderedSame;
}


@implementation LandSelectViewController_iPhone

@synthesize landArray;
@synthesize originLocation;
@synthesize originTitle;
@synthesize nearbyLands;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    return self;
}

- (void)dealloc
{
    [self.landArray release];
    [self.nearbyLands release];
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
    //[self.selectedLand retain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UpdatedLand" object:nil];
language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    NSMutableArray * tempArray = [[NSMutableArray alloc] initWithCapacity:[self.landArray count]];
    for (NSDictionary * landDict  in self.landArray) {
        if([[landDict valueForKey:@"Distance"] doubleValue]!=0.0 ){
           [tempArray addObject:landDict];
        }
    }
    [self.landArray removeObjectsInArray:tempArray];
    self.nearbyLands = [[NSArray arrayWithArray:tempArray] sortedArrayUsingFunction:landDictSort
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
    int landCount =[self.landArray count];
    int nearByCount =[self.nearbyLands count];
    if (section==0 && landCount>0) {
        rv=landCount;
    }else if(section==1 && nearByCount>0){
        rv=nearByCount;
    }
    return rv;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return NSLocalizedString(@"Your location is inside:", @"Your location is inside:");
    }else if(section==1){
        return NSLocalizedString(@"Nearby Lands:", @"Nearby Lands:");
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
    
    if (indexPath.section ==0) {
        if ([self.landArray count]>0) {
            Land * land = (Land *)[(NSMutableDictionary *)[self.landArray objectAtIndex:indexPath.row] valueForKey:@"Land"];
           // NSNumber * distance = [(NSNumber *)[landArray objectAtIndex:indexPath.section] valueForKey:@"Distance"];
            // cell.textLabel.text =((Land *)[landArray objectAtIndex:indexPath.section]).LandName;
            cell.textLabel.text = land.LandName;
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %lf Km", [distance doubleValue]];
            cell.userInteractionEnabled= YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha=1.0;
        }
        else{
            cell.textLabel.text= NSLocalizedString(@"No first nation land is detected in your location.", @"No first nation land is detected in your location." );
            cell.userInteractionEnabled= NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.alpha=0.5;
        }
    }else if(indexPath.section==1){
        if ([self.nearbyLands count]>0) {
            Land * land = (Land *)[(NSMutableDictionary *)[self.nearbyLands objectAtIndex:indexPath.row] valueForKey:@"Land"];
            NSNumber * distance = [(NSNumber *)[self.nearbyLands objectAtIndex:indexPath.row] valueForKey:@"Distance"];
            cell.textLabel.text = land.LandName;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %lf Km", [distance doubleValue]];
            cell.userInteractionEnabled= YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha=1.0;
        }
        else{
            cell.textLabel.text= NSLocalizedString(@"No first nation land is detected nearby your location.", @"No first nation land is detected in your location." );
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
        if ([self.landArray count]>0) {
        
            LocationInfoViewController_iPhone *nextVC= [[LocationInfoViewController_iPhone alloc] initWithNibName:nil bundle:nil];
            // ...
            // Pass the selected object to the new view controller.
            selectedLand =(Land *)[(NSMutableDictionary *)[self.landArray objectAtIndex:indexPath.row] valueForKey:@"Land"];
            //[landArray objectAtIndex:indexPath.section];    
            //ask for the land to be updates  
            NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate]; 
            [appDelegate.landGetter setLandToBeUpdatedById:[selectedLand.LandID intValue]];
          
            nextVC.selectedLand = selectedLand;
            nextVC.originLocation = self.originLocation;
            nextVC.originTitle = self.originTitle;
            NSMutableArray *allLands =[[NSMutableArray alloc]initWithCapacity:[self.nearbyLands count]+[landArray count]];
            for (NSMutableDictionary * dict in landArray) {
                Land * land = (Land*)[dict valueForKey:@"Land"];
                [allLands addObject:land];
            }  
            for (NSMutableDictionary * dict in self.nearbyLands) {
                Land * land = (Land*)[dict valueForKey:@"Land"];
                [allLands addObject:land];
            } 
            nextVC.allLands = allLands;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC release];
        }
    } else if(indexPath.section==1){
        if ([self.nearbyLands count]>0) {
            
            LocationInfoViewController_iPhone *nextVC= [[LocationInfoViewController_iPhone alloc] initWithNibName:nil bundle:nil];
            // ...
            // Pass the selected object to the new view controller.
            selectedLand =(Land *)[(NSMutableDictionary *)[self.nearbyLands objectAtIndex:indexPath.row] valueForKey:@"Land"];
            //[landArray objectAtIndex:indexPath.section];    
            //ask for the land to be updates  
            NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate]; 
            [appDelegate.landGetter setLandToBeUpdatedById:[selectedLand.LandID intValue]];
            
            nextVC.selectedLand = selectedLand;
            nextVC.originLocation = self.originLocation;
            nextVC.originTitle = self.originTitle;
            NSMutableArray *allLands =[[NSMutableArray alloc]initWithCapacity:[self.nearbyLands count]+[self.landArray count]];
            for (NSMutableDictionary * dict in self.landArray) {
                Land * land = (Land*)[dict valueForKey:@"Land"];
                [allLands addObject:land];
            }  
            for (NSMutableDictionary * dict in self.nearbyLands) {
                Land * land = (Land*)[dict valueForKey:@"Land"];
                [allLands addObject:land];
            } 
            nextVC.allLands = allLands;
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC release];
        }

    }
     
}


// Notification handler
- (void)updateUI:(NSNotification *)notif {
    if ([[notif name] isEqualToString:@"UpdatedLand"]){
        Land* updatedLand = (Land*) [notif object];
        int index=[self.landArray indexOfObject:selectedLand];
        [self.landArray replaceObjectAtIndex:index withObject:updatedLand];
        
        
        NSLog(@"Notification received in location info");
        [self.tableView reloadData];
    }
    
    //notify user
    [self.view makeToast:NSLocalizedString(@"        Date Updated.         ", @"        Date Updated.         ")                 duration:2.0
                position:@"bottom"];  
    
    
}

@end
