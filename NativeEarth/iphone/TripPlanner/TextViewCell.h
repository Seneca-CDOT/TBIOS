//
//  TextViewCell.h
//  PTLog
//
//  Created by Ellen Miner on 2/20/09.
//  Copyright 2009 RaddOnline. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TextViewCell;  

@protocol TextViewCellDelegate <NSObject>  

- (void)TextViewCellEditDidFinish:(TextViewCell *)tvc;   
- (void)TextViewCellEditStarted:(TextViewCell *)tvc;  

@end  
// cell identifier for this custom cell
extern NSString *kCellTextView_ID;

@interface TextViewCell : UITableViewCell<UITextViewDelegate> {
	IBOutlet UITextView *textView;

     id <TextViewCellDelegate> delegate;  
}
+ (TextViewCell*) createNewTextCellFromNib;

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, assign) id <TextViewCellDelegate> delegate;  
@end

