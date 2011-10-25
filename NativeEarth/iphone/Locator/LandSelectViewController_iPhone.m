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
@implementation LandSelectViewController_iPhone

@synthesize landArray;
@synthesize originLocation;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    return self;
}

- (void)dealloc
{
    [self.landArray release];
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
    // Return the number of sections.
    int c = [self.landArray count];
    if (c>0) {
         return c;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return 1;
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
	if ([self.landArray count]>0) {
        
        cell.textLabel.text =((Land *)[landArray objectAtIndex:indexPath.section]).LandName;
      //  cell.detailTextLabel.text=((WSLand *)[landArray objectAtIndex:indexPath.section]).LandDescription;
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
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if ([landArray count]>0) {
        
     LocationInfoViewController_iPhone *nextVC= [[LocationInfoViewController_iPhone alloc] initWithNibName:nil bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
        
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate]; 
       selectedLand =[landArray objectAtIndex:indexPath.section];
        
    [appDelegate.landGetter setLandToBeUpdatedById:[selectedLand.LandID intValue]];
        
        
    nextVC.selectedLand = selectedLand;
        nextVC.originLocation = self.originLocation;
        nextVC.allLands = landArray;
     [self.navigationController pushViewController:nextVC animated:YES];
     [nextVC release];
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
