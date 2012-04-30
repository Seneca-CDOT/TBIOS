//
//  GreetingCell_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-12-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Greeting.h"

// cell identifier for this custom cell
extern NSString * kCellGreeting_ID ;

@interface GreetingCell_iPhone : UITableViewCell {

    NSString  *locale;
    UILabel* lblPronunciation;
    UILabel* lblPhrase;
    NSString *greetingType;
    UIButton* btnPlay; 
    
}
@property(nonatomic,retain) IBOutlet UILabel* lblPhrase;
@property(nonatomic,retain) IBOutlet UILabel* lblPronunciation;
@property(nonatomic,retain) IBOutlet UIButton* btnPlay;

+ (GreetingCell_iPhone*) createNewGretingCellFromNib;

@end
