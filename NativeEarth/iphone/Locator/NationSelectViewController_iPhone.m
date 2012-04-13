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
   
    double dist1=[[(NSDictionary *)nationDict1 valueForKey:@"Distance"] doubleValue];
    double dist2=[[(NSDictionary *)nationDict2 valueForKey:@"Distance"] doubleValue];
    NSInteger rv= NSOrderedSame;
    if (dist1 < dist2)
        rv= NSOrderedAscending;
    else if (dist1 > dist2)
        rv= NSOrderedDescending;
    
   return rv;
}


@implementation NationSelectViewController_iPhone

@synthesize nationDictArray;
@synthesize originLocation;
@synthesize originTitle;
@synthesize showOrigin;
@synthesize selectedNationDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    return self;
}

- (void)dealloc
{
    [self.nationDictArray release];
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
 self.nationDictArray =[NSMutableArray arrayWithArray:[self.nationDictArray sortedArrayUsingFunction:nationDictSort context:nil]];
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
        return [self.nationDictArray count];
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
        if ([self.nationDictArray count]>0) {
            Nation * nation = (Nation *)[(NSMutableDictionary *)[self.nationDictArray objectAtIndex:indexPath.row] valueForKey:@"Nation"];
            NSNumber * distance = [(NSNumber *)[self.nationDictArray objectAtIndex:indexPath.row] valueForKey:@"Distance"];
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

    if(indexPath.section==0){
        if ([self.nationDictArray count]>0) {
            
            LocationInfoViewController_iPhone *nextVC= [[LocationInfoViewController_iPhone alloc] initWithNibName:nil bundle:nil];
            // ...
            // Pass the selected object to the new view controller.
            selectedNationDict =[self.nationDictArray objectAtIndex:indexPath.row] ;
            Nation * nation = (Nation*)[selectedNationDict valueForKey:@"Nation"];
            //[landArray objectAtIndex:indexPath.section];    
            //ask for the land to be updates  
            NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate]; 
            [appDelegate.model setNationToBeUpdatedByNationNumber:[nation.Number intValue]];
        
            nextVC.selectedNation= nation;
            nextVC.originLocation = self.originLocation;
            nextVC.originTitle = self.originTitle;
            NSMutableArray * nationArray = [[NSMutableArray alloc] initWithCapacity:[self.nationDictArray count]];
            for (NSDictionary * dict in self.nationDictArray) {
                Nation * n = (Nation *)[dict valueForKey:@"Nation"];
                [nationArray addObject:n];
            }
            nextVC.allNations = nationArray;
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
        int index=  [self.nationDictArray  indexOfObjectIdenticalTo:selectedNationDict] ; 
        [selectedNationDict setValue:updatedNation forKey:@"Nation"];
        [self.nationDictArray replaceObjectAtIndex:index withObject:selectedNationDict];
        NSLog(@"Notification received in location info");
       [self.tableView reloadData];
    
    }
    
    //notify user
    [self.view makeToast:NSLocalizedString(@"        Date Updated.         ", @"        Date Updated.         ")                 duration:2.0
                position:@"bottom"];  
    
    
}

@end
