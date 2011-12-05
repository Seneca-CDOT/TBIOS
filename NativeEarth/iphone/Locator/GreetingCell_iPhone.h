//
//  GreetingCell_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-12-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// cell identifier for this custom cell
NSString * kCellGreeting_ID =@"CellGreeting_ID";

@interface GreetingCell_iPhone : UITableViewCell {
    
}
@property(nonatomic,retain) IBOutlet UILabel* lblPhrase;
@property(nonatomic,retain) IBOutlet UILabel* lblPronounciation;
@property(nonatomic,retain) IBOutlet UIButton* btnPlay;
+ (GreetingCell_iPhone*) createNewGretingCellFromNib;
@end
