//
//  ViewAVisitViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewAVisitViewController_iPhone.h"
//Text View contstants
#define kUITextViewCellRowHeight 150.0
typedef enum { SectionFirstNationName, SectionDate, SectionNotes } SectionType;

typedef enum {HeaderRow, DetailRow1, DetailRow2} RowType ;

@implementation ViewAVisitViewController_iPhone

@synthesize dateFormatter;
@synthesize toolBar;
@synthesize infoTableView;
@synthesize pickerView;
@synthesize doneButton;


- (void)dealloc
{
    [self.doneButton release];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
   // static NSString *NotesCellIdentifier= kCellTextView_ID;
    
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
        }else {
            
            if (indexPath.section == SectionFirstNationName){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:FirstNationCellIdentifier] autorelease];
                   [self configureCell:cell atIndexPath:indexPath];
            }
            else if (indexPath.section == SectionDate ) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:DateCellIdentifier] autorelease];
                   [self configureCell:cell atIndexPath:indexPath];
            }else if (indexPath.section == SectionNotes){
               
                noteCell = [TextViewCell createNewTextCellFromNib];
                NSString *lable = @"kydf dfvjg lugefv guefjg dfv  jgdfjlgdf jgef jgfev jgef jegf ufg ug ef jgef jug ef uge fukg efjlg ejfg ljeguf lfgu lfgu ljfgu ljfg jfg fjegh";
                
                CGSize stringSize = [lable sizeWithFont:[UIFont boldSystemFontOfSize:15]
                                      constrainedToSize:CGSizeMake(320, 9999)
                                          lineBreakMode:UILineBreakModeWordWrap];
                
                noteCell.textView.delegate =noteCell;                    
                
                noteCell.delegate = self;
                
    
                
              //  int index = [indexPath indexAtPosition: [indexPath length] - 1];  
                // next line is very important ...   
                // you have to set the delegate from the cell back to this class  
                [noteCell setDelegate:self];  
                // I am using the key to identify what field is user editing  
            
               
                cell = noteCell;
                
            }//end of if else
        }
    }// end of if(cell == nil)
    
    
    // Configure the cell...
 
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	        
    if (indexPath.section == SectionFirstNationName) {
        if (indexPath.row == HeaderRow) {
            cell.textLabel.text = NSLocalizedString(@"First Nation:", @"First Nation Name:") ;
            cell.userInteractionEnabled = NO;
        }else if (indexPath.row == DetailRow1){
            cell.detailTextLabel.text =@"test FN jyf yg yg yg yg";
            cell.userInteractionEnabled = YES;
           // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.numberOfLines =0;
                      
         //   UIImage *image1 = [UIImage   imageNamed:@"SpotLight.png"];
            
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
           CGRect frame1 = CGRectMake(0.0, 0.0,40,25 );//image1.size.width/1.5, image1.size.height/1.5);
            button1.frame = frame1;
           // [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
            button1.titleLabel.text= @"OK";
    
            button1.titleLabel.backgroundColor =[UIColor grayColor];
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            [button1 addTarget:self action:@selector(searchButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView =button1;
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

        } else if (indexPath.row ==DetailRow2){
                cell.textLabel.text = NSLocalizedString(@"From:", @"From:");

                cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
                cell.userInteractionEnabled = YES;
               
            }
           
    }else if(indexPath.section == SectionNotes ) {
        if(indexPath.row == HeaderRow){
        cell.textLabel.text =NSLocalizedString( @"Notes:",@"Notes:");
             cell.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled = YES;
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.text= @"kydf dfvjg lugefv guefjg dfv  jgdfjlgdf jgef jgfev jgef jegf ufg ug ef jgef jug ef uge fukg efjlg ejfg ljeguf lfgu lfgu ljfgu ljfg jfg fjegh ";
        }
    }
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == HeaderRow) {
        return 34;
    }else{
    
        if (indexPath.section == SectionFirstNationName || indexPath.section == SectionDate) {
            // Regular
            return 34;
 
        } else if(indexPath.section == SectionNotes){
		
            // Get height of summary
        
//            NSString *note = @"kydf dfvjg lugefv guefjg dfv  jgdfjlgdf jgef jgfev jgef jegf ufg ug ef jgef jug ef uge fukg efjlg ejfg ljeguf lfgu lfgu ljfgu ljfg jfg fjegh";
//	
//            CGSize s = [note sizeWithFont:[UIFont systemFontOfSize:15] 
//					   constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
//						   lineBreakMode:UILineBreakModeWordWrap];
//            return s.height ;//+ 5; // Add padding
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
             
             }
    }
    
}

- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
	[self.pickerView removeFromSuperview];
}
#pragma mark - 

- (IBAction)dateAction:(id)sender{
    NSIndexPath *indexPath = [self.infoTableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.infoTableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.pickerView.date];
}
- (IBAction)doneAction:(id)sender
{
    	NSIndexPath *indexPath = [self.infoTableView indexPathForSelectedRow];
    if ([[self.infoTableView cellForRowAtIndexPath:indexPath] isKindOfClass:[TextViewCell class]]) {
        [((TextViewCell * )[self.infoTableView cellForRowAtIndexPath:indexPath]).textView resignFirstResponder];
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
	
	// remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil;
	
	// deselect the current table row

	[self.infoTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma  mark - EditFieldCellDelegate Methods
- (void)editDidFinish:(NSMutableDictionary *)result {  
    NSString *key = [result objectForKey:@"key"];  
    NSString *value = [result objectForKey:@"text"];  
}  
-(void)editStarted:(UITextView *)field{
    self.navigationItem.rightBarButtonItem = self.doneButton;
    

}
@end
