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

@interface GreetingsViewController_iPhone : BaseViewController < AVAudioPlayerDelegate>{

}
@property (nonatomic , retain) id greetings;

@end
