//
//  GreetingViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GreetingViewController_iPhone.h"
#import "GreetingCell_iPhone.h"
#import "Constants.h"

@implementation GreetingViewController_iPhone
@synthesize language;
@synthesize  greeting;

typedef enum {sectionLanguage, sectionGreeting, sectionCount}sectionType;
typedef enum {rowHello,rowGoodbye,rowThankYou,rowCount}rowType;
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
    
   
    [self.greeting release];
    [self.language release];
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
    

    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma  mark - Tableview datasource and delegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    int rv=0;
    if (section == sectionLanguage) {
        rv=1;
    }else if(section==sectionGreeting)
    {
        rv=3;
    }
    return rv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==sectionGreeting) {
        return kGreetingCellRowHeight;
    }else return kRegularCellRowHeight+15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    GreetingCell_iPhone * greetingCell;
   
    if (indexPath.section==sectionLanguage) {
    
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
    
    [self configureCell:cell atIndexPath:indexPath];
  
    }
    else if(indexPath.section== sectionGreeting){
        
         greetingCell= (GreetingCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:kCellGreeting_ID];
        if (greetingCell==nil) {
            greetingCell = [GreetingCell_iPhone createNewGretingCellFromNib];
        }
        [self configureCell:greetingCell atIndexPath:indexPath];
        cell=greetingCell;
    }
        
    return cell; 
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    cell.selectionStyle =UITableViewCellEditingStyleNone;
    cell.textLabel.font= [UIFont boldSystemFontOfSize:15] ;
    cell.detailTextLabel.font= [UIFont systemFontOfSize:15] ;

    if (indexPath.section ==sectionLanguage) {
          cell.userInteractionEnabled=NO;
        cell.textLabel.text = NSLocalizedString(@"Actor Name",@"Actor Name");
        cell.detailTextLabel.numberOfLines=0;
        cell.detailTextLabel.text=greeting.ActorName;
        
    }else if(indexPath.section== sectionGreeting){
        cell.userInteractionEnabled=YES;
        ((GreetingCell_iPhone*) cell).greetingId=self.greeting.GreetingID;
        switch (indexPath.row) {
            case rowHello:
               ((GreetingCell_iPhone*) cell).lblPhrase.text=NSLocalizedString(@"Hello:",@"Hello:");
                ((GreetingCell_iPhone*) cell).lblPronunciation.text=self.greeting.HelloPronunciation;
                ((GreetingCell_iPhone *)cell).data = greeting.Hello;
                ((GreetingCell_iPhone *)cell).greetingType=@"hello";
                break;
            case rowGoodbye:
                ((GreetingCell_iPhone*) cell).lblPhrase.text=NSLocalizedString(@"Goodbye:",@"Goodbye:");
                ((GreetingCell_iPhone*) cell).lblPronunciation.text=greeting.GoodByePronunciation;
                ((GreetingCell_iPhone *)cell).data = greeting.GoodBye;
                ((GreetingCell_iPhone *)cell).greetingType=@"goodbye";
                break;
            case rowThankYou:
                ((GreetingCell_iPhone*) cell).lblPhrase.text=NSLocalizedString(@"Thank You:",@"Thank You:");
                ((GreetingCell_iPhone*) cell).lblPronunciation.text=greeting.ThankYouPronunciation;
                ((GreetingCell_iPhone *)cell).data = greeting.ThankYou;
                ((GreetingCell_iPhone *)cell).greetingType=@"thankyou";
                break;
            default:
                break;
//        int index=indexPath.row;
//        [((GreetingCell_iPhone*)cell) setGreeting:(Greeting*)[self.greeting objectAtIndex:index]];
//         if (self.remoteHostStatus!=NotReachable) {
//             cell.userInteractionEnabled=NO;
//         }
    }
}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

-(void) updateStatusesWithReachability:(Reachability *)curReach{
  //  make cells disabled if no reachability
//    for (UITableViewCell * cell in ) {
//        
//    }
//         
//         
//         if (self.remoteHostStatus!=NotReachable) {
//        cell.userInteractionEnabled=NO;
//    }

}



@end
