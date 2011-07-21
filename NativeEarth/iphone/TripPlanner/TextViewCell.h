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

// we will make one function mandatory to include  
- (void)editDidFinish:(NSMutableDictionary *)result;  

@optional  
// and the other one is optional (this function has not been used in this tutorial)  
- (void)editStarted:(UITextView *)tv;  

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
