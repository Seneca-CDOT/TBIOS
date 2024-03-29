
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
#import "ViewAVisitViewController_iPhone.h"
//typedef enum {SectionFirstNationName, SectionDate, SectionTitle, SectionNotes,SectionCount} SectionType;
typedef enum {SectionTitle,  SectionDate, SectionFirstNationName, SectionNotes,SectionCount} SectionType;
typedef enum {HeaderRow, DetailRow1, DetailRow2} RowType ;

typedef enum {noteCellTag} textViewCellTags;
typedef enum {titleCellTag} textFieldCellTags;

@implementation EditAVisitViewController_iPhone
@synthesize delegate;
@synthesize saveBtn;
@synthesize presentationType;
@synthesize dateFormatter;
@synthesize toolBar;
@synthesize infoTableView;
@synthesize pickerView;
@synthesize doneButton;
@synthesize cancelButton;
@synthesize changeButton;
@synthesize shiftForKeyboard;

@synthesize visit;
@synthesize visitFromDate,visitNotes,visitTitle,visitToDate;
@synthesize visitFistNations;
@synthesize isNew;
- (void)dealloc
{
    [self.saveBtn release];
    [self.visit release];
    
    [self.changeButton release];
    [self.doneButton release];
    [self.cancelButton release];
    [self.pickerView release];
    [self.toolBar release];
    [self.infoTableView release];
    [self.dateFormatter release];
    
    [self.visitFistNations release];
    [self.visitFromDate release];
    [self.visitNotes release];
    [self.visitTitle release]; 
    [self.visitToDate release];
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

    self.visitFistNations = [NSMutableArray arrayWithArray:[self.visit.Nations allObjects]];
    self.infoTableView.editing = YES;
    self.infoTableView.allowsSelectionDuringEditing=YES;
    [self.infoTableView setScrollEnabled:YES];
    self.infoTableView.delegate = self;
    appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    [self.view addSubview:self.toolBar];
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterFullStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.visitTitle =(self.visit.Title .length>0)?[NSMutableString stringWithString: self.visit.Title]:nil;
    self.visitNotes =(self.visit.Notes.length>0 )?[NSMutableString stringWithString:self.visit.Notes]:nil;
 
    if (![self.dateFormatter stringFromDate:visit.FromDate].length >0) {
        self.visitFromDate=NSLocalizedString( @"no date selected yet",@"no date selected yet");//[NSMutableString stringWithString: @""];
    }else{
        self.visitFromDate= [self.dateFormatter stringFromDate:visit.FromDate];
    }
    
    if (![self.dateFormatter stringFromDate:visit.ToDate].length >0) {
        self.visitToDate=NSLocalizedString( @"no date selected yet",@"no date selected yet");//[NSMutableString stringWithString: @""];
    }else{
        self.visitToDate=[self.dateFormatter stringFromDate:visit.ToDate];
    }
    self.saveBtn= [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)] autorelease];
    if (self.presentationType==presentationTypeModal) {
        [self.navigationItem setRightBarButtonItem:self.saveBtn animated:YES];
        [self.navigationItem setLeftBarButtonItem:self.cancelButton animated:YES];
    }

}


-(void)viewWillDisappear:(BOOL)animated{
    if (!isSelectingNations) {
        
        [self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem animated:YES]; 
        [self.navigationItem setHidesBackButton:NO animated:YES];

        if(self.presentationType==presentationTypeNavigate){//because there is no save button then
            self.visit.Title = self.visitTitle;
   
            if (self.visitFromDate != NSLocalizedString(@"no date selected yet",@"no date selected yet")) {
                self.visit.FromDate = [self.dateFormatter dateFromString: visitFromDate];
            }else{
                self.visit.FromDate = nil;
            }

            if (self.visitToDate != NSLocalizedString(@"no date selected yet",@"no date selected yet")) {
                self.visit.ToDate = [self.dateFormatter dateFromString: visitToDate];
            }else{
                self.visit.ToDate =nil;
            }
 
            self.visit.Notes = visitNotes;
    
            [self.visit addNations:[NSSet setWithArray:self.visitFistNations]];
   
            NSError *error;
            if ((error=[appDelegate.model SaveData]))
            {
                NSLog(@"%@",[error description]);
            }
        }
    
    }
    [super viewWillDisappear:animated];
    
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
        return  1+ [self.visitFistNations count];
    }
    return 2;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *HeaderCellIdentifier = @"HeaderCell";
    static NSString *DateCellIdentifier=@"DateCell";
    static NSString *FirstNationCellIdentifier=@"FirstNationCell";
    
    
    UITableViewCell *cell=nil ;
    TextViewCell *noteCell=nil;
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

    if ((cellIsNoteCell && noteCell == nil) || (!cellIsNoteCell && (cell == nil))) {
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
                titleCell.tag = titleCellTag;
                 cell = titleCell;
             } 
            else if (indexPath.section == SectionDate ) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DateCellIdentifier] autorelease];
                   [self configureCell:cell atIndexPath:indexPath];
              
            }else if (indexPath.section == SectionNotes){
                noteCell = [TextViewCell createNewTextCellFromNib];
                [self configureCell:noteCell atIndexPath:indexPath];
                noteCell.tag = noteCellTag;
                cell = noteCell;
                }//end of if else
          }
        
    }else
    {   
        if((indexPath.section == SectionNotes )&& (indexPath.row != HeaderRow)){
                [self configureCell:noteCell atIndexPath:indexPath];
                cell = noteCell;
            cell.tag=noteCellTag;
        }else{
            [self configureCell:cell atIndexPath:indexPath];
        }
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	       cell.detailTextLabel.font = [UIFont systemFontOfSize:15] ; 
    if (indexPath.section == SectionFirstNationName) {
        if (indexPath.row == HeaderRow) {
            cell.textLabel.text = NSLocalizedString(@"First Nations:", @"First Nations:") ;
        }else {
            cell.detailTextLabel.text =((Nation *)[self.visitFistNations objectAtIndex:indexPath.row -1]).OfficialName;
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
        ((TextFieldCell_iPhone *)cell).textField.text =self.visitTitle;
        }

    }else if(indexPath.section == SectionDate){
        if(indexPath.row == HeaderRow){
            cell.textLabel.text = NSLocalizedString(@"Dates:", @"Dates:");
             cell.userInteractionEnabled = NO;
        }
        else if (indexPath.row == DetailRow1) {
              cell.textLabel.text = NSLocalizedString(@"From:", @"From:");
            cell.detailTextLabel.text = self.visitFromDate;
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;

        } else if (indexPath.row ==DetailRow2){
                cell.textLabel.text = NSLocalizedString(@"To:", @"To:");
            cell.detailTextLabel.text = visitToDate;
                cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;

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
            ((TextViewCell *)cell).textView.text =self.visitNotes;
        }
    }
    
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle editingStyle=UITableViewCellEditingStyleNone;
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
                [self AddNation];
            }else {
                [self.visitFistNations removeObject:(Land*)[self.visitFistNations  objectAtIndex:indexPath.row-1]];
                [self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem animated:YES];
                [self.navigationItem setHidesBackButton:NO animated:YES];
                if (self.presentationType==presentationTypeModal) {
                    [self.navigationItem setRightBarButtonItem:self.saveBtn animated:YES]; 
                    [self.navigationItem setLeftBarButtonItem:self.cancelButton animated:YES];
                }
                [self.infoTableView reloadData];
                 }
            break;
        default:
            break;
    }

}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int rv= kRegularCellRowHeight;
    if (indexPath.row != HeaderRow && indexPath.section == SectionNotes)
            return kUITextViewCellRowHeight;
    return rv;
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
        if (targetCell.detailTextLabel.text.length>0 && [targetCell.detailTextLabel.text compare: NSLocalizedString(@"no date selected yet",@"no date selected yet" )] !=NSOrderedSame) {
        self.pickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
        } else self.pickerView.date = [NSDate date];
        [self.infoTableView setScrollEnabled:NO];
        [self SetEnabledTitleCell:NO];
        [self SetEnabledFirstNationEdit:NO];
        // check if our date picker is already on screen
        if (self.pickerView.superview == nil) 
            [self ShiftUpDatePicker];
    }else [self ShiftDownDatePicker];
       
}

 
#pragma mark - IBActions

-(IBAction)dateAction:(id)sender{
    NSIndexPath *indexPath = [self.infoTableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.infoTableView cellForRowAtIndexPath:indexPath];
    NSString* date = [self.dateFormatter stringFromDate:self.pickerView.date];
	cell.detailTextLabel.text = date;
    if (indexPath.row==DetailRow1) {
        self.visitFromDate=date;
    }else self.visitToDate=date;
}
//work here(same date does not work yet)
-(BOOL)validateDates{
    BOOL isValid=YES;
    NSDate *fromDate=nil ;
    NSDate *toDate =nil;
    if(self.visitFromDate!=NSLocalizedString(@"no date selected yet",@"no date selected yet"))
        fromDate = [self.dateFormatter dateFromString:self.visitFromDate];
    if(self.visitToDate!=NSLocalizedString(@"no date selected yet",@"no date selected yet"))
        toDate = [self.dateFormatter dateFromString:self.visitToDate];  
    
    if (fromDate != nil && [fromDate compare:[NSDate date]]==NSOrderedAscending) {
        isValid=NO;
    }       
    
    if (toDate!=nil ) {
        if (fromDate!=nil) {
            if([fromDate compare:toDate]==NSOrderedDescending)
                isValid=NO;
        }
        
        if ([toDate compare:[NSDate date]]==NSOrderedAscending)
            isValid = NO;
    }
    
    return isValid;
}

-(IBAction)doneAction:(id)sender{
    BOOL go=YES;
    NSIndexPath *indexPath = [self.infoTableView indexPathForSelectedRow];
    if(indexPath.section==SectionDate)
        if (([self.visitFromDate compare:[self.dateFormatter stringFromDate: self.visit.FromDate]]!=NSOrderedSame) ||([self.visitToDate compare:[self.dateFormatter stringFromDate:self.visit.ToDate]]!=NSOrderedSame )) {
            go=  [self validateDates];
        }
    if (go) {
   
    // remove the "Done" button in the nav bar
   [self.navigationItem setRightBarButtonItem:nil animated:YES];
   [self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem animated:YES];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self SetBackControls];  
    [self.infoTableView setScrollEnabled:YES];
    
    if (self.presentationType==presentationTypeModal) {
               [self.navigationItem setRightBarButtonItem:self.saveBtn animated:YES];
                [self.navigationItem setLeftBarButtonItem:self.cancelButton animated:YES];
    }
    
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Date Selection",@"Invalid Date Selection") message:NSLocalizedString(@"Dates cannot be set to past, and From cannot be after to.",@"Dates cannot be set to past, and From cannot be after to.") delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles: nil];
        [alert show];
        [alert release];

    }
}


-(void)saveAction:(id)sender{
    self.visit.Title = self.visitTitle;
    
    if (self.visitFromDate != NSLocalizedString(@"no date selected yet",@"no date selected yet")) {
        self.visit.FromDate = [self.dateFormatter dateFromString: visitFromDate];
    }else{
        self.visit.FromDate = nil;
    }
    
    if (self.visitToDate != NSLocalizedString(@"no date selected yet",@"no date selected yet")) {
        self.visit.ToDate = [self.dateFormatter dateFromString: visitToDate];
    }else{
        self.visit.ToDate =nil;
    }
    
    self.visit.Notes = visitNotes;
    
    NSSet *tempSet = self.visit.Nations ;
    [self.visit removeNations:tempSet];
    [self.visit addNations:[NSSet setWithArray:self.visitFistNations]];
    NSError *error;
    if ((error=[appDelegate.model SaveData]))
    {
        NSLog(@"%@",[error description]);
    }
    if ([(NSObject *)(self.delegate)  isKindOfClass:[ViewAVisitViewController_iPhone class]]) {
     [((ViewAVisitViewController_iPhone *)self.delegate).tableView reloadData];
    }
    [self.delegate EditAVisitViewControllerDidSave:self];
}
-(IBAction)Cancel:(id)sender {
    if (isNew) {
       [appDelegate.model removeCanceledVisit:self.visit];
    }
  

    [self.delegate EditAVisitViewControllerDidSave:self];
    
}

#pragma mark - Controls manipulation

-(void) SetBackControls{
    [self ShiftBackView];
    NSIndexPath *dateCell1IndexPath= [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionDate];
    NSIndexPath *dateCell2IndexPath= [NSIndexPath indexPathForRow:DetailRow2 inSection:SectionDate];
    NSIndexPath *titleCellIndexPath= [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionTitle];
    NSIndexPath *noteCellIndexPath = [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionNotes];
    
    NSIndexPath * firstNationAddCellIndexPath= [NSIndexPath indexPathForRow:HeaderRow inSection:SectionFirstNationName];

    
    //deselect the current table row
    [self.infoTableView deselectRowAtIndexPath:dateCell1IndexPath animated:NO];
    [self.infoTableView deselectRowAtIndexPath:dateCell2IndexPath animated:NO];
    [self.infoTableView deselectRowAtIndexPath:titleCellIndexPath animated:NO];
    [self.infoTableView deselectRowAtIndexPath:noteCellIndexPath animated:NO];
    [self.infoTableView deselectRowAtIndexPath:firstNationAddCellIndexPath animated:NO];
    
    UITableViewCell *noteCell = [self.infoTableView cellForRowAtIndexPath:noteCellIndexPath];
    UITableViewCell *titleCell =[self.infoTableView cellForRowAtIndexPath:titleCellIndexPath];
    
    if ([titleCell isKindOfClass:[TextFieldCell_iPhone class]]) {
        [((TextFieldCell_iPhone * )[self.infoTableView cellForRowAtIndexPath:titleCellIndexPath]).textField resignFirstResponder];
        [self SetEnabledTitleCell:YES];
    }
    
    if ([noteCell isKindOfClass:[TextViewCell class]]) {
        [((TextViewCell * )[self.infoTableView cellForRowAtIndexPath:noteCellIndexPath]).textView resignFirstResponder];
    }
    [self SetEnabledFirstNationEdit:YES];
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

-(void) SetEnabledFirstNationEdit:(BOOL) enabled{
    int count = [self.infoTableView numberOfRowsInSection:SectionFirstNationName];
    for (int row = 0; row< count; row++ ){
        [[self.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:SectionFirstNationName]] setUserInteractionEnabled:enabled];
    }
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
  
    
    [self.navigationItem setRightBarButtonItem:self.doneButton animated:YES];
    [self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem animated:YES];
   [self.navigationItem setHidesBackButton:YES animated:YES]; 
    
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
    [self ShiftViewForCellAtIndexPath:ip];
}

#pragma  mark - EditFieldCellDelegate Methods
-(void)ShiftViewForCellAtIndexPath : (NSIndexPath *) indexpath{
    UITableViewCell *cell = [self.infoTableView cellForRowAtIndexPath:indexpath];
    CGFloat leftbottomEdge =cell.frame.origin.y + cell.frame.size.height; 	
	// If the bottom edge is 250 or more, we want to shift the view up
	// We chose 250 here instead of 264, so that we would have some visual buffer space
    
    CGFloat ExtraHeight ;    
    if (leftbottomEdge >= 250) {
            // Make a CGRect for the view (which should be positioned at 0,0 and be 320px wide and 480px tall)
            //CGRect viewFrame = self.view.frame;
            CGRect viewFrame = self.infoTableView.frame;
           
               if ([self.visitFistNations count] >= 1) {
                   if(indexpath.section !=1){
                   ExtraHeight =  ([self.visitFistNations count]-1 )* kRegularCellRowHeight ;
                   }
                   else{
                       ExtraHeight =  ([self.visitFistNations count]-1)* kRegularCellRowHeight ;
                   }
               } else ExtraHeight = -1 *kRegularCellRowHeight;
          
                // Determine the amount of the shift
                self.shiftForKeyboard = leftbottomEdge - 250.0f  - 20.0;
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


//////TEXT FIELD

-(void)TextFieldCellEditStarted:(TextFieldCell_iPhone *)tfc{
    [self ShiftDownDatePicker];
    [self.infoTableView setScrollEnabled:NO];
    [self SetEnabledDateCells:NO];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    NSIndexPath *titleCellIndexPath = [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionTitle];
    [self ShiftViewForCellAtIndexPath:titleCellIndexPath];
}



-(void)TextFieldCellEditDidFinish:(TextFieldCell_iPhone *)tfc{  
    if (tfc.tag == titleCellTag) {
        self.visitTitle = tfc.textField.text;
    }
   [self.navigationItem setHidesBackButton:NO animated:YES];
   [self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem animated:YES];
        if (self.presentationType==presentationTypeModal) {
            [self.navigationItem setRightBarButtonItem:self.saveBtn animated:YES];
            [self.navigationItem setLeftBarButtonItem:self.cancelButton animated:YES];
    }
    [self SetBackControls]; 
    
   
}

///// TEXT VIEW

-(void)TextViewCellEditStarted:(TextViewCell *)tvc{
    [self ShiftDownDatePicker];
    [self SetEnabledDateCells:NO];
    [self SetEnabledTitleCell:NO];
    [self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem animated:YES];
    [self.navigationItem setRightBarButtonItem:self.doneButton animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
   NSIndexPath *noteCellIndexPath = [NSIndexPath indexPathForRow:DetailRow1 inSection:SectionNotes];
  [self ShiftViewForCellAtIndexPath:noteCellIndexPath];
}


-(void)TextViewCellEditDidFinish: (TextViewCell *)tvc {  
    if (tvc.tag == noteCellTag) {
        self.visitNotes = tvc.textView.text;
    }
    [self ShiftBackView];
} 

////////



-(void)AddNation{
    isSelectingNations=YES;
    [self SetBackControls];
    BrowseViewController_iPhone * nextVC = [[BrowseViewController_iPhone alloc]initWithNibName:@"BrowseViewController_iPhone" bundle:nil];
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.title= NSLocalizedString(@"Names", @"Names");
    nextVC.browseType = ForVisitPlanner;
    nextVC.delegate = self;
    
    [self.navigationController presentModalViewController:nextVC animated:YES];
    [nextVC release];

}


#pragma  mark - BrowseViewController_iPhoneDelegate methods
-(void) BrowseViewControllerDidSelectNation:(ShortNation *)nation{
  
    Nation * newNation = [appDelegate.model getNationWithNationNumber:[nation.Number intValue]];
    [self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem animated:YES];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    if (self.presentationType==presentationTypeModal) {
        [self.navigationItem setRightBarButtonItem:self.saveBtn animated:YES];
        [self.navigationItem setLeftBarButtonItem:self.cancelButton animated:YES];
    }
    if(![self.visitFistNations containsObject:newNation]){
    [self.visitFistNations addObject:newNation];
    [self.infoTableView reloadData];
    }
    [self.navigationController dismissModalViewControllerAnimated:YES];
      isSelectingNations=NO;
}



@end
