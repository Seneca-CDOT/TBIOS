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
#import "Greeting.h"
#import "Content.h"
@interface GreetingsViewController_iPhone : BaseViewController < AVAudioPlayerDelegate>{
    NSArray                   *greetings;
    AVAudioPlayer				*appSoundPlayer;
    UILabel                     *helloLabel;
    UILabel                     *landLabel;
    UILabel                     *thankYouLabel;
    UIButton                    *languageButton;//is used just as lable.
    UIButton                    *helloButton;
    UIButton                    *thankYouButton;
    UIButton                    *landButton;
}
@property (nonatomic, retain)      NSArray              *greetings;
@property (nonatomic, retain)      NSString                  *language;
@property (nonatomic, retain)      AVAudioPlayer             *appSoundPlayer;

-(IBAction)     playSound:          (id) sender;

@end
