//
//  GreetingsViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "WSGreetings.h"
#import "WSContent.h"
@interface GreetingsViewController_iPhone : BaseViewController < AVAudioPlayerDelegate>{
    Greetings                   *greetings;
    AVAudioPlayer				*appSoundPlayer;
    UILabel                     *helloLabel;
    UILabel                     *landLabel;
    UILabel                     *thankYouLabel;
    UIButton                    *languageButton;//is used just as lable.
    UIButton                    *helloButton;
    UIButton                    *thankYouButton;
    UIButton                    *landButton;
    NSString                    *language;
}
@property (nonatomic, retain)      Greetings               *greetings;
@property (nonatomic, retain)      AVAudioPlayer             *appSoundPlayer;
@property (nonatomic, retain)      IBOutlet UILabel          *helloLabel;
@property (nonatomic, retain)      IBOutlet UILabel          *landLabel;
@property (nonatomic, retain)      IBOutlet UILabel          *thankYouLabel;
@property (nonatomic, retain)      IBOutlet UIButton         *languageButton;
@property (nonatomic, retain)      IBOutlet UIButton         *helloButton;
@property (nonatomic, retain)      IBOutlet UIButton         *thankYouButton;
@property (nonatomic, retain)      IBOutlet UIButton         *landButton;

-(IBAction)     playHello:          (id) sender;
-(IBAction)     playThankYou:		(id) sender;
-(IBAction)     playLand:           (id) sender;
@end
