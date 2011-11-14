//
//  GreetingsViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GreetingsViewController_iPhone.h"


@implementation GreetingsViewController_iPhone
@synthesize greetings,appSoundPlayer;
@synthesize language;


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
    [self.greetings release];
    [self.appSoundPlayer release];
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
      self.language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
          // Do any additional setup after loading the view from its nib.
    
    NSString * languageBtnTitle = [NSString stringWithFormat:@"  %@: %@" , NSLocalizedString(@"Language", @"Language"),self.language];
    UIButton * languageBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    [languageBtn setTitle:languageBtnTitle forState:UIControlStateNormal];
    [languageBtn setTitle:languageBtnTitle forState:UIControlStateHighlighted];
    [languageBtn setTitle:languageBtnTitle forState:UIControlStateDisabled];
    [languageBtn setTitle:languageBtnTitle forState:UIControlStateSelected];
    CGRect languageBtnRect =CGRectMake(20, 40, 100,20 );
    [self.view addSubview:languageBtn];
    ////
    for (Greeting * greeting in self.greetings) {
        //Create Phrase lable
        
        UILabel * phraseLable = [[UILabel alloc] init];
        [phraseLable setText:greeting.Phrase];
        
        
        //Create Pronounciation Lable
        
        
        //Create Play Button
        
        
        
        
        //Add them to view (position them properly)
        
        
        
        NSString *btnTitle = [NSString stringWithFormat:@"  %@: ", greeting.Phrase];
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn  setTitle:btnTitle forState:UIControlStateNormal];
        [btn  setTitle:btnTitle forState:UIControlStateHighlighted];
        [btn  setTitle:btnTitle forState:UIControlStateDisabled];
        [btn  setTitle:btnTitle forState:UIControlStateSelected];
        
        
    }
   
   
  
    
  
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
	[appSoundPlayer setDelegate: self];
    [appSoundPlayer play];
    }else{
        //allert
    }
}

-(IBAction)     playSound:(id)sender{
   // change later
    int i = 1;
    [self playContent: ((Greeting*)[greetings objectAtIndex:1]).Content];
}



@end
