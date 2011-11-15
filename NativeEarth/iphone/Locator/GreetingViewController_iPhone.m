//
//  GreetingViewController.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GreetingViewController_iPhone.h"


@implementation GreetingViewController_iPhone
@synthesize language, greetings;
@synthesize  appSoundPlayer;
@synthesize btnLanguage;
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
    [self.btnLanguage release];
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
    // Do any additional setup after loading the view from its nib.
    
    NSString * btnLanguageTitle = [NSString stringWithFormat:@"  %@: %@" , NSLocalizedString(@"Language", @"Language"),self.language];
        
    [btnLanguage setTitle:btnLanguageTitle forState:UIControlStateNormal];
    [btnLanguage setTitle:btnLanguageTitle forState:UIControlStateHighlighted];
    [btnLanguage setTitle:btnLanguageTitle forState:UIControlStateDisabled];
    [btnLanguage setTitle:btnLanguageTitle forState:UIControlStateSelected];
    

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
    self.btnLanguage=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
