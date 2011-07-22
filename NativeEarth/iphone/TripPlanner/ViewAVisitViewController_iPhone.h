//
//  ViewAVisitViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TextViewCell.h"
#import "TextFieldCell_iPhone.h"
#import "BrowseViewController_iPhone.h"
@interface ViewAVisitViewController_iPhone : BaseViewController<UITableViewDataSource, UITableViewDelegate,TextViewCellDelegate, UIActionSheetDelegate, BrowseViewController_iPhoneDelegate,TextFieldCellDelegate> {
    
    NSDateFormatter *dateFormatter; 
    UIDatePicker *pickerView;
    UITableView *infoTableView;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *cancelButton;
    UIButton *changeButton;
    UIBarButtonItem *trashButton;
}


@property (nonatomic, retain) NSDateFormatter *dateFormatter; 
// Number of pixels to shift the view up or down
@property CGFloat shiftForKeyboard;
@property (nonatomic,retain) IBOutlet UIToolbar * toolBar;
@property (nonatomic,retain) IBOutlet UITableView * infoTableView;
@property (nonatomic, retain) IBOutlet UIDatePicker *pickerView; 
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *trashButton;
@property (nonatomic, retain) UIButton *changeButton;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

-(void)SetBackControls;
- (IBAction)dateAction:(id)sender;	// when the user has changed the date picke values (m/d/y)
- (IBAction)doneAction:(id)sender;
- (void)changeButtonTapped:(id)sender;

- (UIButton *)newButtonWithTitle:(NSString *)title
                          target:(id)target
                        selector:(SEL)selector
                           frame:(CGRect)frame
                           image:(UIImage *)image
                    imagePressed:(UIImage *)imagePressed
                   darkTextColor:(BOOL)darkTextColor;
-(IBAction)Cancel:(id)sender;
-(void) shiftDownDatePicker;
-(void) setEnabledDateCells:(BOOL) enabled;
-(void) setEnabledTitleCell:(BOOL) enabled;
@end
