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
#import "Toast+UIView.h"

@implementation GreetingViewController_iPhone
@synthesize language;
@synthesize  greeting;
@synthesize soundPlayer;
typedef enum {helloGreetingType,goodbyeGreetingType,thankyouGreetingType }greetingType;
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
    
    [self.soundPlayer release];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
   
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
    UITableViewCell *cell=nil;
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
 [((GreetingCell_iPhone*) cell).btnPlay addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (indexPath.row) {
            case rowHello:
               ((GreetingCell_iPhone*) cell).lblPhrase.text=NSLocalizedString(@"Hello:",@"Hello:");
                ((GreetingCell_iPhone*) cell).lblPronunciation.text=self.greeting.HelloPronunciation;
                ((GreetingCell_iPhone*) cell).btnPlay.tag=helloGreetingType;
                
                break;
            case rowGoodbye:
                ((GreetingCell_iPhone*) cell).lblPhrase.text=NSLocalizedString(@"Goodbye:",@"Goodbye:");
                ((GreetingCell_iPhone*) cell).lblPronunciation.text=greeting.GoodByePronunciation;
                ((GreetingCell_iPhone*) cell).btnPlay.tag=goodbyeGreetingType;
                
                break;
            case rowThankYou:
                ((GreetingCell_iPhone*) cell).lblPhrase.text=NSLocalizedString(@"Thank You:",@"Thank You:");
                ((GreetingCell_iPhone*) cell).lblPronunciation.text=greeting.ThankYouPronunciation;
                ((GreetingCell_iPhone*) cell).btnPlay.tag=thankyouGreetingType;
                
                break;
            default:
                break;

    }
}
}
-(void)playSound:(id)sender{
    
    if (self.remoteHostStatus!=NotReachable) {
        
    
    UIButton * button = (UIButton *)sender;

    NSString * typeSting =nil;
    switch((greetingType)button.tag) {
        case helloGreetingType:
            typeSting = @"hello";
            break;
        case goodbyeGreetingType:
            typeSting = @"goodbye";
            break;
        case thankyouGreetingType:
            typeSting = @"thankyou";
            break;
        default:
            break;
    }
    NSString *wsUrl = [NSString stringWithFormat:@"http://%@:81/dps907_113a05/ws", kHostName];

    NSString * urlString  = [NSString stringWithFormat:@"%@/greeting/%d/%@",wsUrl, [self.greeting.GreetingID intValue],typeSting];
  
    
    NSURL * URL = [NSURL URLWithString:urlString];
    NSData * webdata = [NSData dataWithContentsOfURL:URL];
   
    
    NSError *error = nil;
   //stop the soundPlayer if it is already playing
    [soundPlayer stop];
     // Instantiates the AVAudioPlayer object, initializing it with the sound
    soundPlayer= [[AVAudioPlayer alloc] initWithData:webdata error:&error];	
      if (!error) {
          // "Preparing to play" attaches to the audio hardware and ensures that playback
          //		starts quickly when the user taps Play
          [soundPlayer prepareToPlay];
          [soundPlayer play];

      }else{
          NSLog(@"%@",[error description]);
      }
    
    } else{//if host not reachable make a toast
        [self.view makeToast:NSLocalizedString(@"      No Network Connection       ", @"      No Network Connection       ")                 duration:2.0
                    position:@"bottom"]; 

    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}




@end
