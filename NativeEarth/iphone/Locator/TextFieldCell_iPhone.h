//
//  TextFieldCell_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TextFieldCell_iPhone;  

@protocol TextFieldCellDelegate;

// cell identifier for this custom cell
extern NSString *kCellTextField_ID;


@interface TextFieldCell_iPhone : UITableViewCell<UITextFieldDelegate> {
	IBOutlet UITextField *textField;
    id <TextFieldCellDelegate> delegate;  
     
}
+ (TextFieldCell_iPhone*) createNewTextFieldCellFromNib;

@property (nonatomic, retain) IBOutlet UITextField *textField;

@property (nonatomic, assign) id <TextFieldCellDelegate> delegate;  
@end

@protocol TextFieldCellDelegate <NSObject>  
- (void)TextFieldCellEditDidFinish:(TextFieldCell_iPhone *)tf;   
- (void)TextFieldCellEditStarted:(TextFieldCell_iPhone *)tf;  
@end  
