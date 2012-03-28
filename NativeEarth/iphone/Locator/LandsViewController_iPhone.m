//
//  LandsViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LandsViewController_iPhone.h"
#import "Nation.h"
#import "Land.h"
#import "MapBrowserViewController_iPhone.h"

@implementation LandsViewController_iPhone
@synthesize landList;
@synthesize  referringNation ;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    return self;
}


- (void)dealloc
{
    [self.landList release]; 
   
    [self.referringNation release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    locale = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
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
    int rv=1;
    int landCount =[self.landList count];
   
    if (section==0 && landCount>0) {
        rv=landCount;
    }
    return rv;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     return  self.referringNation.OfficialName;
   
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
    
        if ([self.landList count]>0) {
            Land  * land = [self.landList objectAtIndex:indexPath.row] ;
            // NSNumber * distance = [(NSNumber *)[landArray objectAtIndex:indexPath.section] valueForKey:@"Distance"];
            // cell.textLabel.text =((Land *)[landArray objectAtIndex:indexPath.section]).LandName;
           if ([locale compare:@"fr"]==0) {
                cell.textLabel.text = land.LandName_FRA;
           }else{
               cell.textLabel.text = land.LandName_ENG;
           }
            
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %lf Km", [distance doubleValue]];
            cell.userInteractionEnabled= YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.alpha=1.0;
        }
        else{
            cell.textLabel.text= NSLocalizedString(@"No land is listed for this nation" ,@"No land is listed for this nation" );
            cell.userInteractionEnabled= NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.alpha=0.5;
        }
       
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if ([self.landList count]>0) {
            selectedLand=[self.landList objectAtIndex:indexPath.row];
            [self navigateToMap];
                  }
         

    
}

-(void)navigateToMap{
    if (self.remoteHostStatus != NotReachable) {
        
        MapBrowserViewController_iPhone * nextVC = [[MapBrowserViewController_iPhone alloc] initWithNibName:@"MapBrowserViewController_iPhone" bundle:nil];
        nextVC.remoteHostStatus = self.remoteHostStatus;
        nextVC.internetConnectionStatus = self.internetConnectionStatus;
        nextVC.wifiConnectionStatus= self.wifiConnectionStatus;
        nextVC.isBrowsingNation=NO;
        if ([locale compare:@"fr"]==0) {
             nextVC.title=selectedLand.LandName_FRA;
        }else{
             nextVC.title=selectedLand.LandName_ENG;
        }

        nextVC.title=selectedLand.LandName_ENG;
        nextVC.referringLand = selectedLand;
        [self.navigationController pushViewController:nextVC animated:YES];
        [nextVC release];
    }else{
        //alert
    }

}

@end
