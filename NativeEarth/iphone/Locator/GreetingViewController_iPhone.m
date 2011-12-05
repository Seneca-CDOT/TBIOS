//
//  GreetingViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GreetingViewController_iPhone.h"
#import "GreetingCell_iPhone.h"

@implementation GreetingViewController_iPhone
@synthesize language, greetings;
@synthesize  appSoundPlayer;
typedef enum {sectionLanguage, sectionGreeting, sectionCount}sectionType;

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
    
    [self.appSoundPlayer release];
    [self.greetings release];
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
    
   locale = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];

    
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
        rv=[self.greetings count];
    }
    return rv;
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
            greetingCell = [[GreetingCell_iPhone createNewGretingCellFromNib] autorelease];
            [self configureCell:greetingCell atIndexPath:indexPath];
            cell=greetingCell;
        }
    }
        
    return cell; 
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==sectionLanguage) {
        cell.userInteractionEnabled=NO;
        cell.textLabel.text = NSLocalizedString(@"Language:",@"Language:");
        cell.detailTextLabel.numberOfLines=0;
        cell.detailTextLabel.text=self.language;
        
    }else if(indexPath.section== sectionLanguage){
        int index=indexPath.row;
        if ( [locale compare:@"fr"]==0)  {
            ((GreetingCell_iPhone*)cell).lblPhrase.text=((Greeting*)[self.greetings objectAtIndex:index]).PhraseFrench;
            ((GreetingCell_iPhone*)cell).lblPronounciation.text=((Greeting*)[self.greetings objectAtIndex:index]).PronounciationFrench;
        }else {
            ((GreetingCell_iPhone*)cell).lblPhrase.text=((Greeting*)[self.greetings objectAtIndex:index]).PhraseEnglish;
            ((GreetingCell_iPhone*)cell).lblPronounciation.text=((Greeting*)[self.greetings objectAtIndex:index]).PronounciationEnglish;
        }
        
        
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
            
    
    
}





#pragma mark - Soundplayer Methods
- (void) playContent:(Content *)content {
	
    if (self.remoteHostStatus!=NotReachable) {
        NSString * urlString  = [NSString stringWithFormat:@"%@%@%@", content.DataLocation ,@".",content.MIMEType];
        
        NSURL * URL = [NSURL URLWithString:urlString];
        NSData * data = [NSData dataWithContentsOfURL:URL];
        
        
        
        NSError *error = nil;
        
        // Instantiates the AVAudioPlayer object, initializing it with the sound
        appSoundPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];	
        
        
        // "Preparing to play" attaches to the audio hardware and ensures that playback
        //		starts quickly when the user taps Play
        [appSoundPlayer prepareToPlay];
        //[appSoundPlayer setVolume: 1.0];
       // [appSoundPlayer setDelegate: self];
        [appSoundPlayer play];
    }else{
        //allert
    }
}

-(void)playSound:(id)sender{
    // change later
    int i = 1;
    [self playContent: ((Greeting*)[greetings objectAtIndex:i]).Content];
}


@end
