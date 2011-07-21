
//
//  ViewAVisitViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewAVisitViewController_iPhone.h"

//contstants
#define kUITextViewCellRowHeight 110.0
#define kStdButtonWidth		60.0
#define kStdButtonHeight	20.0
#define kRegularCellRowHeight  34.0

#define kButtonTag			1		// for tagging our embedded controls for removal at cell recycle time
typedef enum {SectionFirstNationName, SectionDate, SectionNotes} SectionType;

typedef enum {HeaderRow, DetailRow1, DetailRow2} RowType ;

@implementation ViewAVisitViewController_iPhone

@synthesize dateFormatter;
@synthesize toolBar;
@synthesize infoTableView;
@synthesize pickerView;
@synthesize doneButton;
@synthesize cancelButton;
@synthesize changeButton;
@synthesize shiftForKeyboard;
@synthesize trashButton;

- (void)dealloc
{
    [self.trashButton release];
    [self.changeButton release];
    [self.doneButton release];
    [self.cancelButton release];
    [self.pickerView release];
    [self.toolBar release];
    [self.infoTableView release];
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
    infoTableView.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

    [self.view addSubview:self.toolBar];
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterFullStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
   self.dateFormatter = nil;
    self.toolBar = nil;
    self.infoTableView = nil;
    self.pickerView = nil;
    self.doneButton = nil;
    self.cancelButton =nil;
    self.trashButton = nil;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == SectionDate) {
        return  3;
    }
    return 2;
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HeaderCellIdentifier = @"HeaderCell";
    static NSString *DateCellIdentifier=@"DateCell";
    static NSString *FirstNationCellIdentifier=@"FirstNationCell";
    
    
    UITableViewCell *cell ;
    TextViewCell *noteCell;
    BOOL cellIsEditable = NO;
    if (indexPath.row == HeaderRow) {
        cell =  [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    }else{
        if (indexPath.section==SectionFirstNationName) {
            cell =  [tableView dequeueReusableCellWithIdentifier:FirstNationCellIdentifier];
            
        }else if(indexPath.section== SectionDate){
            cell =  [tableView dequeueReusableCellWithIdentifier:DateCellIdentifier];
        }else if (indexPath.section== SectionNotes){
            cellIsEditable = YES;
            noteCell= (TextViewCell *) [tableView dequeueReusableCellWithIdentifier:kCellTextView_ID];
        }
    }

    if ((cellIsEditable && noteCell == nil) || (!cellIsEditable && cell == nil)) {
        if (indexPath.row == HeaderRow ){
           
                 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderCellIdentifier] autorelease];
              [self configureCell:cell atIndexPath:indexPath];
         
         }else{
            
            if (indexPath.section == SectionFirstNationName){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:FirstNationCellIdentifier] autorelease];
                   [self configureCell:cell atIndexPath:indexPath];
               
            }
            else if (indexPath.section == SectionDate ) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:DateCellIdentifier] autorelease];
                   [self configureCell:cell atIndexPath:indexPath];
              
            }else if (indexPath.section == SectionNotes){
            
                noteCell = [TextViewCell createNewTextCellFromNib];
                [self configureCell:noteCell atIndexPath:indexPath];
                
                cell = noteCell;
                
                }//end of if else
          }
    }else
    {
        if (indexPath.row != HeaderRow ) {
            if (indexPath.section == SectionFirstNationName) {
                // the cell is being recycled, remove old embedded controls
                UIView *viewToRemove = nil;
                viewToRemove = [cell.contentView viewWithTag:kButtonTag];
                 if (viewToRemove)
                [viewToRemove removeFromSuperview];
                [self configureCell:cell atIndexPath:indexPath];
            }else if(indexPath.section ==SectionDate){
                [self configureCell:cell atIndexPath:indexPath];
            }else if(indexPath.section == SectionNotes){
                [self configureCell:noteCell atIndexPath:indexPath];
                cell = noteCell;
            }
        }

    }
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	        
    if (indexPath.section == SectionFirstNationName) {
        if (indexPath.row == HeaderRow) {
            cell.textLabel.text = NSLocalizedString(@"First Nation:", @"First Nation Name:") ;
            cell.userInteractionEnabled = NO;
        }else if (indexPath.row == DetailRow1){
            cell.detailTextLabel.text =@"Algonquin ";
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines =0;
            
           cell.accessoryView = self.changeButton;
        }
    }else if(indexPath.section == SectionDate){
        if(indexPath.row == HeaderRow){
            cell.textLabel.text = NSLocalizedString(@"Date:", @"Date:");
            cell.userInteractionEnabled = NO;

        }
        else if (indexPath.row == DetailRow1) {
              cell.textLabel.text = NSLocalizedString(@"To:", @"To:");
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;

        } else if (indexPath.row ==DetailRow2){
                cell.textLabel.text = NSLocalizedString(@"From:", @"From:");

                cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
                cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;

            }
           
    }else if(indexPath.section == SectionNotes ) {
        if(indexPath.row == HeaderRow){
        cell.textLabel.text =NSLocalizedString( @"Notes:",@"Notes:");
             cell.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            ((TextViewCell*)cell).textView.delegate =(TextViewCell*)cell;                    
            ((TextViewCell*)cell).delegate = self;
            cell.detailTextLabel.numberOfLines = 0;
           
        }
    }
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == HeaderRow) {
        return kRegularCellRowHeight;
    }else{
    
        if (indexPath.section == SectionFirstNationName || indexPath.section == SectionDate) {
            // Regular
            return kRegularCellRowHeight;
 
        } else if(indexPath.section == SectionNotes){
		
            CGFloat result;
            result = kUITextViewCellRowHeight;	
            return result;

        } 
    }
    return 34;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == SectionNotes && indexPath.row == DetailRow1 ) {
        return YES;
    }
    return NO;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.section == SectionDate && indexPath.row != HeaderRow){
        
        UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
        self.pickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
    
        // check if our date picker is already on screen
        if (self.pickerView.superview == nil)
        {
            [self.view.window addSubview: self.pickerView];
            
            // size up the picker view to our screen and compute the start/end frame origin for our slide up animation
            //
            // compute the start frame
            CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
            CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
            CGRect startRect = CGRectMake(0.0,
                                          screenRect.origin.y + screenRect.size.height,
                                          pickerSize.width, pickerSize.height);
            self.pickerView.frame = startRect;
            
            // compute the end frame
            CGRect pickerRect = CGRectMake(0.0,
                                           screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                           pickerSize.width,
                                           pickerSize.height);
            // start the slide up animation
            [UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
            
			// we need to perform some post operations after the animation is complete
			[UIView setAnimationDelegate:self];
            
			self.pickerView.frame = pickerRect;
            
			// shrink the table vertical size to make room for the date picker
			CGRect newFrame = tableView.frame;
			newFrame.size.height -= self.pickerView.frame.size.height;
			tableView.frame = newFrame;
            [UIView commitAnimations];
            
            
            self.navigationItem.rightBarButtonItem = self.doneButton;
          
            //[self.navigationItem setHidesBackButton:YES animated:YES];
            self.navigationItem.leftBarButtonItem = self.cancelButton;
             }
    }
    
}

- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
	[self.pickerView removeFromSuperview];
}
#pragma mark - IBActions

- (IBAction)dateAction:(id)sender{
    NSIndexPath *indexPath = [self.infoTableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.infoTableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.pickerView.date];
    
}

- (IBAction)doneAction:(id)sender
{
    // remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil; 
     self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    [self SetBackControls];   
	
    
}

-(IBAction)Cancel:(id)sender{
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    // remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil; 
    [self SetBackControls];
}

-(void)SetBackControls{

    NSIndexPath *noteCellIndexPath = [NSIndexPath  indexPathForRow:1 inSection:2];
    NSIndexPath *dateCell1IndexPath= [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *dateCell2IndexPath= [NSIndexPath indexPathForRow:2 inSection:1];
    
    
    UITableViewCell *noteCell = [self.infoTableView cellForRowAtIndexPath:noteCellIndexPath];
    
    if ([noteCell isKindOfClass:[TextViewCell class]]) {
        [((TextViewCell * )[self.infoTableView cellForRowAtIndexPath:noteCellIndexPath]).textView resignFirstResponder];
    }
    
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.pickerView.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down animation
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
	
    self.pickerView.frame = endFrame;
	[UIView commitAnimations];
	
	// grow the table back again in vertical size to make room for the date picker
	CGRect newFrame = self.infoTableView.frame;
	newFrame.size.height += self.pickerView.frame.size.height;
	self.infoTableView.frame = newFrame;
	
	// deselect the current table row
    
	[self.infoTableView deselectRowAtIndexPath:noteCellIndexPath animated:NO];
    [self.infoTableView deselectRowAtIndexPath:dateCell1IndexPath animated:NO];
    [self.infoTableView deselectRowAtIndexPath:dateCell2IndexPath animated:NO];
}


#pragma  mark - EditFieldCellDelegate Methods
 
-(void)editStarted:(UITextView *)tv{
    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
 
    // Make a CGRect so we can get the textField dimensions and position
	// The following statement gets the rectangle
	CGRect tvRect = [self.view.window convertRect:tv.bounds fromView:tv];
	// Find out what the bottom edge value is
	CGFloat bottomEdge = tvRect.origin.y + tvRect.size.height;
	
	// If the bottom edge is 250 or more, we want to shift the view up
	// We chose 250 here instead of 264, so that we would have some visual buffer space
	if (bottomEdge >= 250) {
		
		// Make a CGRect for the view (which should be positioned at 0,0 and be 320px wide and 480px tall)
		//CGRect viewFrame = self.view.frame;
		CGRect viewFrame = self.infoTableView.frame;

		// Determine the amount of the shift
		self.shiftForKeyboard = bottomEdge - 250.0f +30.0;
        
		// Adjust the origin for the viewFrame CGRect
		viewFrame.origin.y -= self.shiftForKeyboard;
		
		// The following animation setup just makes it look nice when shifting
		// We don't really need the animation code, but we'll leave it in here
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
        
		// Apply the new shifted vewFrame to the view
		//[self.view setFrame:viewFrame];
		[self.infoTableView setFrame:viewFrame];
		// More animation code
		[UIView commitAnimations];
		
	} else {
		// No view shifting required; set the value accordingly
		self.shiftForKeyboard = 0.0f;
	}


}

- (void)editDidFinish:(NSMutableDictionary *)result {  
   // NSString *key = [result objectForKey:@"key"];  
   // NSString *value = [result objectForKey:@"text"];  
    
    
    
    /// Shift view:
    // Make a CGRect for the view (which should be positioned at 0,0 and be 320px wide and 480px tall)
	CGRect viewFrame = self.infoTableView.frame;
    
	// Adjust the origin back for the viewFrame CGRect
	viewFrame.origin.y += self.shiftForKeyboard;
    
	// Set the shift value back to zero
	self.shiftForKeyboard = 0.0f;
	
	// As above, the following animation setup just makes it look nice when shifting
	// Again, we don't really need the animation code, but we'll leave it in here
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];
	
	// Apply the new shifted vewFrame to the view
	[self.infoTableView setFrame:viewFrame];
    
	// More animation code
	[UIView commitAnimations];
} 

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


- (UIButton *)changeButton
{	

	if (changeButton == nil)
	{
		// create the UIButtons with various background images
		// white button:
		UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
		UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
		
		CGRect frame = CGRectMake(182.0, 5.0, kStdButtonWidth, kStdButtonHeight);
		
		changeButton = [self  newButtonWithTitle:NSLocalizedString(@"Change", @"Change")
                                              target:self
                                              selector:@selector(changeButtonTapped:)
                                              frame:frame
                                               image:buttonBackground
                                               imagePressed:buttonBackgroundPressed
                                              darkTextColor:YES];
		
		changeButton.tag = kButtonTag;	// tag this view for later so we can remove it from recycled table cells
	}
	return changeButton;
}

-(void)changeButtonTapped: (id) sender{
    self.navigationItem.leftBarButtonItem = self.cancelButton;
        self.navigationItem.rightBarButtonItem = self.doneButton;
    
    // open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:NSLocalizedString(@"Browse By:", @"Browse By:")
                                   delegate:self 
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") 
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: NSLocalizedString(@"Names",@"Names"), NSLocalizedString(@"Geopolitical Names",@"Geopolitical Names"), NSLocalizedString(@"Map",@"Map"), nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

#pragma mark - ActionSheet delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		//NSLog(@"name");
        [self SetBackControls];
        BrowseViewController_iPhone * nextVC = [[BrowseViewController_iPhone alloc]initWithNibName:@"BrowseViewController_iPhone" bundle:nil];
        
        nextVC.remoteHostStatus = self.remoteHostStatus;
        nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
        nextVC.internetConnectionStatus = self.internetConnectionStatus;
        nextVC.managedObjectContext = self.managedObjectContext;
        nextVC.title= NSLocalizedString(@"Names", @"Names");
        nextVC.browseType = ForVisitPlanner;
        nextVC.delegate = self;
        
        [self.navigationController presentModalViewController:nextVC animated:YES];
        [nextVC release];
        

	} else if (buttonIndex == 1){
       // NSLog(@"geo");
        [self SetBackControls];
    
    } else if (buttonIndex == 2){
       // NSLog(@"map");
        [self SetBackControls];
    }else
	{
		//NSLog(@"cancel");
        [self SetBackControls];
	}
}



@end
