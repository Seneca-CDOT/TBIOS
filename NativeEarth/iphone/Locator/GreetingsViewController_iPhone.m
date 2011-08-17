//
//  GreetingsViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GreetingsViewController_iPhone.h"


@implementation GreetingsViewController_iPhone
@synthesize greetings,appSoundPlayer,helloLabel,landLabel,thankYouLabel;
@synthesize languageButton, helloButton,thankYouButton,landButton;


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
    [self.helloLabel release];
    [self.thankYouLabel release];
    [self.landLabel release];
    [self.languageButton release];
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
      language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
          // Do any additional setup after loading the view from its nib.
    NSString * languageBtnTitle = [NSString stringWithFormat:@"  %@: %@" , NSLocalizedString(@"Language", @"Language"),self.greetings.Language];
    
    [self.languageButton setTitle:languageBtnTitle forState:UIControlStateNormal];
    [self.languageButton setTitle:languageBtnTitle forState:UIControlStateHighlighted];
    [self.languageButton setTitle:languageBtnTitle forState:UIControlStateDisabled];
    [self.languageButton setTitle:languageBtnTitle forState:UIControlStateSelected];
   
    NSString *helloBtnTitle = [NSString stringWithFormat:@"  %@: ", NSLocalizedString(@"Hello", @"Hello")];
    
     [self.helloButton setTitle:helloBtnTitle forState:UIControlStateNormal];
     [self.helloButton setTitle:helloBtnTitle forState:UIControlStateHighlighted];
     [self.helloButton setTitle:helloBtnTitle forState:UIControlStateDisabled];
     [self.helloButton setTitle:helloBtnTitle forState:UIControlStateSelected];
     

    
    NSString *landBtnTitle = [NSString stringWithFormat:@"  %@: ", self.greetings.LandPhrase];
    
    [self.landButton setTitle:landBtnTitle forState:UIControlStateNormal];
    [self.landButton setTitle:landBtnTitle forState:UIControlStateHighlighted];
    [self.landButton setTitle:landBtnTitle forState:UIControlStateDisabled];
    [self.landButton setTitle:landBtnTitle forState:UIControlStateSelected];

    NSString *thankYouBtnTitle = [NSString stringWithFormat:@"  %@: ", NSLocalizedString(@"Thank You", @"Thank You")];
    
    [self.thankYouButton setTitle:thankYouBtnTitle forState:UIControlStateNormal];
    [self.thankYouButton setTitle:thankYouBtnTitle forState:UIControlStateHighlighted];
    [self.thankYouButton setTitle:thankYouBtnTitle forState:UIControlStateDisabled];
    [self.thankYouButton setTitle:thankYouBtnTitle forState:UIControlStateSelected];
    if ([language compare:@"fr"]==0) {
        self.thankYouLabel.text = greetings.ThankYouPronounciationFrench;
        self.helloLabel.text = greetings.HelloPronounciationFrench;
        self.landLabel.text = greetings.LandPronounciationFrench;
    }else{
    
        self.thankYouLabel.text = greetings.ThankYouPronounciationEnglish;
        self.helloLabel.text = greetings.HelloPronounciationEnglish;
        self.landLabel.text = greetings.LandPronounciationEnglish;
    }
  
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.landLabel= nil;
    self.languageButton = nil;
    self.thankYouLabel=nil;
    self.helloLabel = nil;
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

-(IBAction)     playHello:          (id) sender{
    [self playContent:(Content*)greetings.HelloContent];
}

-(IBAction)     playLand:          (id) sender{
    [self playContent:(Content*)greetings.LandContent];
}
-(IBAction)     playThankYou:          (id) sender{
    [self playContent:(Content*)greetings.ThankYouContent];
}

@end
