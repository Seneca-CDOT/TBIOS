//
//  GreetingCell_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-12-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Greeting.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
// cell identifier for this custom cell
extern NSString * kCellGreeting_ID ;

@interface GreetingCell_iPhone : UITableViewCell {
    Greeting *greeting;
     NSString             *locale;
 UILabel* lblPronounciation;
 UILabel* lblPhrase;
 UIButton* btnPlay; 
    
}
@property(nonatomic,retain) Greeting* greeting;
@property(nonatomic,retain) IBOutlet UILabel* lblPhrase;
@property(nonatomic,retain) IBOutlet UILabel* lblPronounciation;
@property(nonatomic,retain) IBOutlet UIButton* btnPlay;
@property (nonatomic, retain)      AVAudioPlayer        *cellSoundPlayer;
+ (GreetingCell_iPhone*) createNewGretingCellFromNib;
-(IBAction)playSound:(id)sender;
@end
