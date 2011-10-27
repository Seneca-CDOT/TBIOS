
//
//  EditAVisitViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditAVisitViewController_iPhone.h"
#import "Constants.h"
#import "NativeEarthAppDelegate_iPhone.h"
//typedef enum {SectionFirstNationName, SectionDate, SectionTitle, SectionNotes,SectionCount} SectionType;
typedef enum {SectionTitle,  SectionDate, SectionFirstNationName, SectionNotes,SectionCount} SectionType;

typedef enum {HeaderRow, DetailRow1, DetailRow2} RowType ;

@implementation EditAVisitViewController_iPhone
@synthesize dateFormatter;
@synthesize toolBar;
@synthesize infoTableView;
@synthesize pickerView;
@synthesize doneButton;
@synthesize cancelButton;
@synthesize changeButton;
@synthesize shiftForKeyboard;
@synthesize trashButton;
@synthesize visit;
- (void)dealloc
{
    [self.visit release];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    infoTableView.editing = YES;
    infoTableView.allowsSelectionDuringEditing=YES;
    [infoTableView setScrollEnabled:YES];
    infoTableView.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

    [self.view addSubview:self.toolBar];
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterFullStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    ((TextFieldCell_iPhone *)[infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:DetailRow1 inSection:SectionTitle]]).textField.text =visit.Title;
    
    ((TextViewCell *)[infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:DetailRow1 inSection:SectionNotes]]).textView.text =visit.Notes;
   
}

-(void)viewDidDisappear:(BOOL)animated{
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    [appDelegate.landGetter SaveData];

}

- (void)viewDidUnload {
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == SectionDate) {
        return  3;
    }else if (section == SectionFirstNationName){
        return  1+ [self.visit.Lands count];
    }
    return 2;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *HeaderCellIdentifier = @"HeaderCell";
    static NSString *DateCellIdentifier=@"DateCell";
    static NSString *FirstNationCellIdentifier=@"FirstNationCell";
    //static NSString *TitleCellIdentifier=@"TitleCell";
    
    
    UITableViewCell *cell ;
    TextViewCell *noteCell;
    TextFieldCell_iPhone *titleCell;
    BOOL cellIsNoteCell = NO;
    if (indexPath.row == HeaderRow) {
        cell =  [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    }else{
      if (indexPath.section==SectionFirstNationName) {
            cell =  [tableView dequeueReusableCellWithIdentifier:FirstNationCellIdentifier];
        } else  if(indexPath.section == SectionTitle){
                cell = [tableView dequeueReusableCellWithIdentifier:kCellTextField_ID];
        }else if(indexPath.section== SectionDate){
            cell =  [tableView dequeueReusableCellWithIdentifier:DateCellIdentifier];
        }else if (indexPath.section== SectionNotes){
            cellIsNoteCell = YES;
            noteCell= (TextViewCell *) [tableView dequeueReusableCellWithIdentifier:kCellTextView_ID];
        }
        
    }

    if ((cellIsNoteCell && noteCell == nil) || (!cellIsNoteCell && cell == nil)) {
        if (indexPath.row == HeaderRow ){           
                 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderCellIdentifier] autorelease];
              [self configureCell:cell atIndexPath:indexPath];
         
         }else{
            
            if (indexPath.section == SectionFirstNationName){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:FirstNationCellIdentifier] autorelease];
                   [self configureCell:cell atIndexPath:indexPath];
               
            } else if (indexPath.section == SectionTitle) {
                 titleCell = [TextFieldCell_iPhone createNewTextFieldCellFromNib];
                 [self configureCell:titleCell atIndexPath:indexPath];
                 cell = titleCell;
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
        if(indexPath.section == SectionNotes && indexPath.row != HeaderRow){
                [self configureCell:noteCell atIndexPath:indexPath];
                cell = noteCell;
        }else{
            [self configureCell:cell atIndexPath:indexPath];
        }
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	        
    if (indexPath.section == SectionFirstNationName) {
        if (indexPath.row == HeaderRow) {
            cell.textLabel.text = NSLocalizedString(@"First Nation Lands:", @"First Nation Lands:") ;
        }else {
            cell.detailTextLabel.text =((Land *)[[visit.Lands allObjects] objectAtIndex:indexPath.row -1]).LandName;
        } 
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if(indexPath.section == SectionTitle){
        if (indexPath.row == HeaderRow) {
            cell.textLabel.text = NSLocalizedString(@"Title:", @"Title:") ;
            cell.userInteractionEnabled = NO;
        }else if (indexPath.row == DetailRow1){
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ((TextFieldCell_iPhone *)cell).textField.delegate =(TextFieldCell_iPhone*)cell; 
           ((TextFieldCell_iPhone *)cell).textField.placeholder = NSLocalizedString( @"Enter a title for your visit",  @"Enter a title for your visit"); 
           ((TextFieldCell_iPhone *)cell).delegate = self;
        }

    }else if(indexPath.section == SectionDate){
        if(indexPath.row == HeaderRow){
            cell.textLabel.text = NSLocalizedString(@"Date:", @"Date:");
            cell.userInteractionEnabled = NO;

        }
        else if (indexPath.row == DetailRow1) {
              cell.textLabel.text = NSLocalizedString(@"From Date:", @"From Date:");
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;

        } else if (indexPath.row ==DetailRow2){
                cell.textLabel.text = NSLocalizedString(@"To Date:", @"To Date:");

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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ((TextViewCell*)cell).textView.delegate =(TextViewCell*)cell;                    
            ((TextViewCell*)cell).delegate = self;
            cell.detailTextLabel.numberOfLines = 0;
           
        }
    }
    
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle editingStyle;
    if( indexPath.section==SectionFirstNationName){
        if (indexPath.row ==HeaderRow){
            editingStyle = UITableViewCellEditingStyleInsert;
        }else {
            editingStyle = UITableViewCellEditingStyleDelete;
        }

    }
    
    return editingStyle;
    
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionFirstNationName:
            if (indexPath.row ==HeaderRow){
                [self AddLand];
            }else {
                [self.visit removeLandsObject:(Land*)[[self.visit.Lands allObjects] objectAtIndex:indexPath.row-1]];
                [self.infoTableView reloadData];
                 }
            break;
        default:
            break;
    }

    
    
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == HeaderRow) {
        return kRegularCellRowHeight;
    }else{
    
        if (indexPath.section == SectionFirstNationName || indexPath.section == SectionDate) {
            // Regular
            return kRegularCellRowHeight;
        }else if (indexPath.section == SectionTitle){
            CGFloat result;
            result = kTextFieldCellRowHeight;	
            return result; 
        }else if(indexPath.section == SectionNotes){
            CGFloat result;
            result = kUITextViewCellRowHeight;	
            return result;
        } 
    }
    return kRegularCellRowHeight;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == SectionFirstNationName ){
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == SectionDate && indexPath.row != HeaderRow){
        UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
        self.pickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
        // check if our date picker is already on screen
        if (self.pickerView.superview == nil) 
            [self ShiftUpDatePicker];
    }else [self ShiftDownDatePicker];
}

 
#pragma mark - IBActions

-(IBAction)dateAction:(id)sender{
    NSIndexPath *indexPath = [self.infoTableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.infoTableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.pickerView.date];
}

-(IBAction)doneAction:(id)sender{
    // remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil; 
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    [self SetBackControls];   
}

-(IBAction)Cancel:(id)sender {
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    //remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil; 
    [self SetBackControls];
}

#pragma mark - Controls manipulation

-(void) SetBackControls{
    [self ShiftBackView];
    NSIndexPath *dateCell1IndexPath= [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionDate];
    NSIndexPath *dateCell2IndexPath= [NSIndexPath indexPathForRow:DetailRow2 inSection:SectionDate];
    NSIndexPath *titleCellIndexPath= [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionTitle];
    NSIndexPath *noteCellIndexPath = [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionNotes];
    
    //deselect the current table row
    [self.infoTableView deselectRowAtIndexPath:dateCell1IndexPath animated:NO];
    [self.infoTableView deselectRowAtIndexPath:dateCell2IndexPath animated:NO];
    [self.infoTableView deselectRowAtIndexPath:titleCellIndexPath animated:NO];
    [self.infoTableView deselectRowAtIndexPath:noteCellIndexPath animated:NO];
    
    UITableViewCell *noteCell = [self.infoTableView cellForRowAtIndexPath:noteCellIndexPath];
    UITableViewCell *titleCell =[self.infoTableView cellForRowAtIndexPath:titleCellIndexPath];
    
    if ([titleCell isKindOfClass:[TextFieldCell_iPhone class]]) {
        [((TextFieldCell_iPhone * )[self.infoTableView cellForRowAtIndexPath:titleCellIndexPath]).textField resignFirstResponder];
        [self SetEnabledTitleCell:YES];
    }
    
    if ([noteCell isKindOfClass:[TextViewCell class]]) {
        [((TextViewCell * )[self.infoTableView cellForRowAtIndexPath:noteCellIndexPath]).textView resignFirstResponder];
    }
    
    [self ShiftDownDatePicker];
}

-(void) SetEnabledDateCells:(BOOL) enabled{
    NSIndexPath *dateCell1IndexPath= [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionDate];
    NSIndexPath *dateCell2IndexPath= [NSIndexPath indexPathForRow:DetailRow2 inSection:SectionDate];
    UITableViewCell * dateCell1= [self.infoTableView cellForRowAtIndexPath:dateCell1IndexPath]; 
    UITableViewCell *dateCell2=[self.infoTableView cellForRowAtIndexPath:dateCell2IndexPath];
    dateCell1.userInteractionEnabled =enabled;
    dateCell2.userInteractionEnabled =enabled;
    
}

-(void) SetEnabledTitleCell:(BOOL) enabled{
     NSIndexPath * titleCellIndexPath= [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionTitle];
     UITableViewCell * titleCell= [self.infoTableView cellForRowAtIndexPath:titleCellIndexPath]; 
     titleCell.userInteractionEnabled =enabled;
    
}

- (void)slideDownDidStop {
	// the date picker has finished sliding downwards, so remove it
	[self.pickerView removeFromSuperview];
}

-(void) ShiftDownDatePicker{
    if (self.pickerView.superview != nil) {  
        
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
        //[UIView commitAnimations];
        
        // grow the table back again in vertical size to make room for the date picker
        CGRect newFrame = self.infoTableView.frame;
       newFrame.size.height += self.pickerView.frame.size.height;
        self.infoTableView.frame = newFrame;
        
        [UIView commitAnimations];

    }
}

-(void) ShiftUpDatePicker{
    //[self.navigationItem setHidesBackButton:YES animated:YES]; 
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    [self.view.window addSubview: self.pickerView];
    
    // size up the picker view to our screen and compute the start/end frame origin for our slide up animation
    //
    // compute the start frame
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
    CGRect startRect = CGRectMake(0.0,
                                  screenRect.origin.y + screenRect.size.height,
                                  pickerSize.width, 
                                  pickerSize.height);
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
    CGRect newFrame = infoTableView.frame;
    newFrame.size.height -= self.pickerView.frame.size.height;
    infoTableView.frame = newFrame;
    [UIView commitAnimations]; 
    NSIndexPath * ip = [NSIndexPath indexPathForRow:2 inSection:1];
    [self ShiftViewForCell:[infoTableView cellForRowAtIndexPath:ip] atIndexPath:ip];
}

#pragma  mark - EditFieldCellDelegate Methods
-(void)ShiftViewForCell:(UITableViewCell*) cell atIndexPath : (NSIndexPath *) indexpath{
    CGFloat leftbottomEdge =cell.frame.origin.y + cell.frame.size.height; 	
	// If the bottom edge is 250 or more, we want to shift the view up
	// We chose 250 here instead of 264, so that we would have some visual buffer space
    
    CGFloat ExtraHeight ;    
    if (leftbottomEdge >= 250) {
            // Make a CGRect for the view (which should be positioned at 0,0 and be 320px wide and 480px tall)
            //CGRect viewFrame = self.view.frame;
            CGRect viewFrame = self.infoTableView.frame;
           
               if ([visit.Lands count] >= 1) {
                   if(indexpath.section !=1){
                   ExtraHeight =  ([visit.Lands count]-1 )* kRegularCellRowHeight ;
                   }
                   else{
                       ExtraHeight =  ([visit.Lands count]-1)* kRegularCellRowHeight ;
                   }
               } else ExtraHeight = -1 *kRegularCellRowHeight;
          
                // Determine the amount of the shift
                self.shiftForKeyboard = leftbottomEdge - 250.0f ;
                self.shiftForKeyboard-=ExtraHeight;
           
                // Adjust the origin for the viewFrame CGRect
                viewFrame.origin.y -= self.shiftForKeyboard;
		
                // The following animation setup just makes it look nice when shifting
                // We don't really need the animation code, but we'll leave it in here
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationBeginsFromCurrentState:YES];
                [UIView setAnimationDuration:0.3];
        
                // Apply the new shifted viewFrame to the view
                //[self.view setFrame:viewFrame];
                [self.infoTableView setFrame:viewFrame];
                // More animation code
                [UIView commitAnimations];
               
        
            [self.infoTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self.infoTableView setScrollEnabled:NO];
	} else {
		// No view shifting required; set the value accordingly
		self.shiftForKeyboard = 0.0f;
	}
    
    
}

-(void)ShiftBackView {
    [self.infoTableView setScrollEnabled:YES];
    [self SetEnabledDateCells:YES];
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
    NSIndexPath *firstNationCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.infoTableView scrollToRowAtIndexPath:firstNationCellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)TextFieldCellEditStarted:(TextFieldCell_iPhone *)tfc{
    [self ShiftDownDatePicker];
   // [self SetEnabledDateCells:NO];
    self.navigationItem.leftBarButtonItem = self.cancelButton;  
    NSIndexPath *titleCellIndexPath = [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionTitle];
    [self ShiftViewForCell:tfc atIndexPath:titleCellIndexPath];
}

-(void)TextFieldCellEditDidFinish:(TextFieldCell_iPhone *)tfc{  
     self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    [self SetBackControls];
}

-(void)TextViewCellEditStarted:(TextViewCell *)tvc{
    [self ShiftDownDatePicker];
    [self SetEnabledDateCells:NO];
   [self SetEnabledTitleCell:NO];
    self.navigationItem.rightBarButtonItem = self.doneButton;
   self.navigationItem.leftBarButtonItem = self.cancelButton;
    
   NSIndexPath *noteCellIndexPath = [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionNotes];
  [self ShiftViewForCell:tvc atIndexPath:noteCellIndexPath];

}

-(void)TextViewCellEditDidFinish: (TextViewCell *)tvc {  
    [self ShiftBackView];
} 

-(void)AddLand{
    
    // open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:NSLocalizedString(@"Browse By:", @"Browse By:")
                                   delegate:self 
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") 
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: NSLocalizedString(@"Names",@"Names"), NSLocalizedString(@"Map",@"Map"), nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

#pragma mark - ActionSheet delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the buttons
	if (buttonIndex == 0)
	{
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
        [self SetBackControls];
    }else
	{
        [self SetBackControls];
	}
}

#pragma  mark - BrowseViewController_iPhoneDelegate methods
-(void) BrowseViewControllerDidSelectFirstNation:(LandShort *)nation{
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    Land * newLand = [appDelegate.landGetter GetLandWithLandId:[nation.landId intValue]];
    [self.visit addLandsObject:newLand];
    [self.infoTableView reloadData];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
