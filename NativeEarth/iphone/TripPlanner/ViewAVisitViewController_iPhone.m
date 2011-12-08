//
//  ViewAVisitViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-10-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewAVisitViewController_iPhone.h"
#import "Land.h"
#import "LocationInfoViewController_iPhone.h"

typedef enum {SectionTitle,  SectionDate, SectionFirstNationName, SectionNotes,SectionCount} SectionType;

typedef enum {HeaderRow, DetailRow1, DetailRow2} RowType ;

@implementation ViewAVisitViewController_iPhone
@synthesize visit;
@synthesize dateFormatter;
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
    [self.visit release];
    [self.dateFormatter release];
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
    if (self.visit.Title==nil ||self.title==@"") {
         self.title = NSLocalizedString(@"New Visit",@"New Visit");
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.editButtonItem setAction:@selector(EditButtonAction:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 4*kTableViewSectionHeaderHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.view = self.tableView;
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterFullStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
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
    [self.navigationItem setHidesBackButton:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
  // [self.tableView reloadData];
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

    return SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == SectionDate) {
        return  3;
    }else if (section == SectionFirstNationName){
        return  1+ [self.visit.Lands count];
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RegularCellIdentifier = @"RegularCell";
    static NSString *DateCellIdentifier = @"DateCell";
    UITableViewCell *cell;
    if(indexPath.section== SectionDate &&(indexPath.row== DetailRow1 || indexPath.row == DetailRow2)){
        cell = [tableView dequeueReusableCellWithIdentifier:DateCellIdentifier];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:RegularCellIdentifier];

    }
    
    if (cell == nil) {
        if(indexPath.section== SectionDate &&(indexPath.row== DetailRow1 || indexPath.row == DetailRow2)){
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DateCellIdentifier] autorelease];
        }else{
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RegularCellIdentifier] autorelease];
        }   
    } 
    cell.textLabel.text=nil;
    cell.detailTextLabel.text=nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SectionFirstNationName) {
        if (indexPath.row == HeaderRow) {
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15] ;
            cell.textLabel.text = NSLocalizedString(@"First Nation Lands:", @"First Nation Lands:") ;
        }else {
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15] ;
            cell.detailTextLabel.text =((Land *)[[visit.Lands allObjects] objectAtIndex:indexPath.row -1]).LandName;
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } 
    }else if(indexPath.section == SectionTitle){
        if (indexPath.row == HeaderRow) {
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15] ;
            cell.textLabel.text = NSLocalizedString(@"Title:", @"Title:") ;
        }else if (indexPath.row == DetailRow1){
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15] ;
            cell.detailTextLabel.numberOfLines =0;
            cell.detailTextLabel.text=visit.Title;
        }
        
    }else if(indexPath.section == SectionDate){
        if(indexPath.row == HeaderRow){
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15] ;
            cell.textLabel.text = NSLocalizedString(@"Dates:", @"Dates:");
            
        }
        else if (indexPath.row == DetailRow1) {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15] ;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15] ;
            cell.textLabel.text=NSLocalizedString(@"From:", @"From");
            if (![self.dateFormatter stringFromDate:visit.FromDate].length >0) {
                 cell.detailTextLabel.text=NSLocalizedString( @"no date selected yet",@"no date selected yet");
            }else{
                
            cell.detailTextLabel.text= [self.dateFormatter stringFromDate:visit.FromDate];
            }
            cell.detailTextLabel.textColor=[UIColor grayColor];
            
        } else if (indexPath.row ==DetailRow2){
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15] ;
            cell.textLabel.text=NSLocalizedString(@"To:", @"To");
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15] ;
             cell.detailTextLabel.textColor=[UIColor grayColor];
             
            if (![self.dateFormatter stringFromDate:visit.ToDate].length >0) {
                cell.detailTextLabel.text=NSLocalizedString( @"no date selected yet",@"no date selected yet");
            }else{
                
            cell.detailTextLabel.text=[self.dateFormatter stringFromDate:visit.ToDate];
            }
            
        }
        
    }else if(indexPath.section == SectionNotes ) {
        if(indexPath.row == HeaderRow){
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15] ;
            cell.textLabel.text =NSLocalizedString( @"Notes:",@"Notes:");
        }else{
            
            cell.textLabel.font = [UIFont systemFontOfSize:15] ;
            cell.detailTextLabel.numberOfLines =0;
            cell.detailTextLabel.text=visit.Notes;
        }
    }
    
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int rv = kRegularCellRowHeight;
    if (indexPath.section==SectionNotes && indexPath.row == DetailRow1) {
        NSMutableString *text = [[NSMutableString alloc] init];
        
        if(visit.Notes!=nil)text=[NSMutableString stringWithString: visit.Notes];
        else text =[NSMutableString stringWithString:@""];
        if (text.length !=0) {
		CGSize s = [text sizeWithFont:[UIFont systemFontOfSize:15] 
					   constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
						   lineBreakMode:UILineBreakModeWordWrap];
		rv=  s.height + 16; // Add padding
        }
    }else if(indexPath.section==SectionTitle && indexPath.row == DetailRow1)
    { NSString *text =visit.Title;
        if (text.length!=0) {
       
		CGSize s = [text sizeWithFont:[UIFont systemFontOfSize:15] 
                    constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
                        lineBreakMode:UILineBreakModeWordWrap];
		rv=s.height + 16; // Add padding
        }
    }
    return  rv;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == SectionFirstNationName && indexPath.row>HeaderRow ) {
        LocationInfoViewController_iPhone *nextVC= [[LocationInfoViewController_iPhone alloc] initWithNibName:nil bundle:nil];
        NSArray * lands = (NSArray*)[visit.Lands allObjects];
        nextVC.allLands = lands;
        nextVC.selectedLand= [lands objectAtIndex:indexPath.row -1];  
       // nextVC.
        nextVC.showOrigin=NO; 
        
        [self.navigationController pushViewController:nextVC animated:YES];
        [nextVC release];
    }
}

-(void)EditButtonAction:(id) sender{
    EditAVisitViewController_iPhone * nextVC = [[EditAVisitViewController_iPhone alloc] init];
    nextVC.visit = self.visit;
    
    nextVC.title=NSLocalizedString(@"Edit Visit",@"Edit Visit");
    nextVC.presentationType = presentationTypeModal;
    nextVC.hidesBottomBarWhenPushed=NO;
    nextVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    nextVC.modalPresentationStyle=UIModalPresentationFullScreen;
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
