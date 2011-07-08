//
//  GreetingsViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface GreetingsViewController_iPhone : BaseViewController {
    
    NSString * HelloAudioFileID;
    NSString * HelloAudioMimeType;
    
    NSString * WelcomeAudioFileID;
    NSString * WelcomeAudioMimeType;
    
    NSString * GoodbyeAudioFileID;
    NSString * GoodbyeAudioMimeType;
}

@property(nonatomic,retain)  NSString * HelloAudioFileID;
@property(nonatomic,retain)  NSString * HelloAudioMimeType;

@property(nonatomic,retain)  NSString * WelcomeAudioFileID;
@property(nonatomic,retain)  NSString * WelcomeAudioMimeType;

@property(nonatomic,retain)  NSString * GoodbyeAudioFileID;
@property(nonatomic,retain)  NSString * GoodbyeAudioMimeType;

@end
