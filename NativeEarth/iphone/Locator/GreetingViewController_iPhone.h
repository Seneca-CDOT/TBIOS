//
//  GreetingsViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Greeting.h"
#import "Content.h"
@interface GreetingsViewController_iPhone : BaseViewController {
    
    AVAudioPlayer				*appSoundPlayer;

}
@property (nonatomic, retain)      NSArray              *greetings;
@property (nonatomic, retain)      NSString                  *language;
@property (nonatomic, retain)      AVAudioPlayer             *appSoundPlayer;

-(IBAction)     playSound:          (id) sender;


@end
