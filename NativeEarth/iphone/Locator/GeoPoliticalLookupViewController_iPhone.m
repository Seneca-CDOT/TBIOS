//
//  GeoPoliticalLookupViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeoPoliticalLookupViewController_iPhone.h"
#import "JSON.h"
#import "LocationInfoViewController_iPhone.h"
#import "TextFieldCell_iPhone.h"
#define kButtonTag			1		// for tagging search button
#define kSearchButtonWidth  60
#define kSearchButtonHeight  30
typedef enum {SectionSearch, SectionResult} SectionType;

typedef enum {CountryRow, RegionRow, LocalityRow,ButtonRow} RowType ;
/*
 Country
 Region (i.e. province/state)
 Locality (i.e. city/town/district)
 */

@implementation GeoPoliticalLookupViewController_iPhone

@synthesize  dataStream;
@synthesize tableView;
@synthesize delegate;
@synthesize geoLookupType;
@synthesize toolbar;
@synthesize resultList;
@synthesize searchButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [searchButton release];
    [resultList release];
    [dataStream release];
    [tableView release];
    [toolbar release];
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
    // Do any additional setup after loading the view from its nib.
    
    if (geoLookupType == LookupForLocator) {
       // [self.toolbar setHidden:YES];
        [self.tableView removeFromSuperview];
        self.view = self.tableView;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    tableView= nil;
    toolbar=nil;
    searchButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Network operations

-(void) GetFirstNationListFromWebService{
    NSString *url = @"http://localhost/~ladan/FirstNationList";
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
}

#pragma  mark - NetworkDataGetter Delegate

-(void)DataUpdate:(NSArray *)objectArray{
    self.resultList = objectArray;

    [self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}
-(void)DataError:(NSError *)error{
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"%@", [error description]);
}



#pragma mark - TableView datasource and delegate

// Customize the number of rows in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section== SectionSearch ){
        return  3 +1;
    }else{
        return [self.resultList count];
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    static NSString *ResultCellIdentifier=@"ResultCell";
    static NSString *ButtonCellIdentifier=@"ButtonCell";
    
    UITableViewCell *cell ;
    TextFieldCell_iPhone *inputCell;
    
    BOOL cellIsEditable = NO;
        if (indexPath.section == SectionSearch) {
            if (indexPath.row==ButtonRow) {
                 cell =  [tv dequeueReusableCellWithIdentifier:ButtonCellIdentifier];
            }else{  
              cellIsEditable = YES;
            inputCell = (TextFieldCell_iPhone *) [tv dequeueReusableCellWithIdentifier:kCellTextField_ID];
            }
            
        }else if(indexPath.section== SectionResult){
            cell =  [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
        }
    
    
    if ((cellIsEditable && inputCell == nil) || (!cellIsEditable && cell == nil)) {
     
            if (indexPath.section == SectionSearch){
                
                if (indexPath.row == ButtonRow) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ButtonCellIdentifier] autorelease];
                    [self configureCell:cell atIndexPath:indexPath];
                }else{  // inputs
                inputCell = [TextFieldCell_iPhone createNewTextFieldCellFromNib];
                 [self configureCell:inputCell atIndexPath:indexPath];
                  cell = inputCell;
                }
            }
            else if (indexPath.section == SectionResult) {// results
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResultCellIdentifier] autorelease];
              [self configureCell:cell atIndexPath:indexPath];
                
            }
        
    }else
    {
            if (indexPath.section == SectionSearch) {
                if (indexPath.row==ButtonRow) {
               //        the cell is being recycled, remove old embedded controls
                UIView *viewToRemove = nil;
                viewToRemove = [cell.contentView viewWithTag:kButtonTag];
                if (viewToRemove) 
                    [viewToRemove removeFromSuperview];  
                    
                    [self configureCell:cell atIndexPath:indexPath];

                } else{

                [self configureCell:inputCell atIndexPath:indexPath];
                cell= inputCell;
                }
            
            }else if(indexPath.section == SectionResult){
                [self configureCell:cell atIndexPath:indexPath];
            }
        
        
    }
    
    return cell;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==SectionSearch) {
        return nil;
    }else{
        return NSLocalizedString(@"Results:", @"Results:");
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SectionSearch) {
      
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row==ButtonRow){
                cell.accessoryView = self.searchButton;
            }else{
                ((TextFieldCell_iPhone *)cell).textField.delegate =(TextFieldCell_iPhone *)cell;                    
                ((TextFieldCell_iPhone *)cell).delegate = self;  
                if (indexPath.row == CountryRow) {
                    ((TextFieldCell_iPhone *)cell).textField.placeholder=NSLocalizedString(@"Country", @"Country");
                }else if (indexPath.row==RegionRow){
                    ((TextFieldCell_iPhone *)cell).textField.placeholder=NSLocalizedString(@"Province/State", @"Province/State");
                }else if (indexPath.row== LocalityRow){
                    ((TextFieldCell_iPhone *)cell).textField.placeholder=NSLocalizedString(@"City/Town/District", @"City/Town/District");
                } 
            }
             
        
    } else {
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                if (geoLookupType==LookupForLocator) {
                    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                } else {
                    cell.accessoryType= UITableViewCellAccessoryNone;
                }
         cell.textLabel.text = [[resultList objectAtIndex:indexPath.row] valueForKey:@"Name"];
         
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	NSDictionary *dict = nil;
	
        dict = [self.resultList objectAtIndex:indexPath.row];
    

    
    // LandShort * nation = [[LandShort alloc]init];
    // nation.landName = [dict valueForKey:@"Name"];
    // nation.latitude = [dict valueForKey:@"CenterLatitude"];
    // nation.longitude = [dict valueForKey:@"CenterLongitude"];
    
    if (indexPath.section ==SectionResult) {
        if (geoLookupType == LookupForLocator)  {
            LocationInfoViewController_iPhone *nextVC = [[LocationInfoViewController_iPhone alloc] init];
        
            nextVC.remoteHostStatus = self.remoteHostStatus;
            nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
            nextVC.internetConnectionStatus = self.internetConnectionStatus;
            nextVC.managedObjectContext = self.managedObjectContext;
        
            //nextVC.title= nation.name;
        
            [self.navigationController pushViewController:nextVC animated:YES];
            [nextVC release];
        
        }else {
            [self.delegate GeoPoliticalLookupViewControllerDidSelectFirstNation:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(IBAction) CancelButtonAction:(id) sender{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - TextFieldCellDelegate Methods

-(void)TextFieldCellEditDidFinish:(TextFieldCell_iPhone *)tfc{
    
}

- (void)TextFieldCellEditStarted:(TextFieldCell_iPhone*)tfc{
    
}

#pragma  mark - searchButton

#pragma mark - Button configuration

- (UIButton *)newButtonWithTitle:(NSString *)title
                          target:(id)target
                        selector:(SEL)selector
                           frame:(CGRect)frame
                           image:(UIImage *)image
                    imagePressed:(UIImage *)imagePressed
                   darkTextColor:(BOOL)darkTextColor
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	// or you can do this:
	//		UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


- (UIButton *)searchButton
{	
    
	if (searchButton == nil)
	{
		// create the UIButtons with various background images
		// white button:
		UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
		UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
		
		CGRect frame = CGRectMake(182.0, 5.0, kSearchButtonWidth, kSearchButtonHeight);
		
		searchButton = [self  newButtonWithTitle:NSLocalizedString(@"Search", @"Search")
                                          target:self
                                        selector:@selector(searchButtonTapped:)
                                           frame:frame
                                           image:buttonBackground
                                    imagePressed:buttonBackgroundPressed
                                   darkTextColor:YES];
		
		searchButton.tag = kButtonTag;	// tag this view for later so we can remove it from recycled table cells
	}
	return searchButton;
}
- (void)searchButtonTapped:(id)sender{
    [self GetFirstNationListFromWebService ];
}
@end
