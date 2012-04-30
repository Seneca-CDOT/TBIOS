//
//  GreetingViewController.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Greeting.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface GreetingViewController_iPhone : BaseTableViewController {

}

@property (nonatomic, retain)      NSString             *language;
@property(nonatomic,retain)         Greeting            *greeting;
@property (nonatomic, retain)      AVAudioPlayer        *soundPlayer;
- (void)playSound:(id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;
@end
