//
//  EditAVisitViewController_iPhone.h
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
#import "PlannedVisit.h"

@interface EditAVisitViewController_iPhone : BaseViewController<UITableViewDataSource, UITableViewDelegate,TextViewCellDelegate, UIActionSheetDelegate, BrowseViewController_iPhoneDelegate,TextFieldCellDelegate> {
    
    NSDateFormatter *dateFormatter; 
    UIDatePicker *pickerView;
    UITableView *infoTableView;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *cancelButton;
    UIButton *changeButton;
    UIBarButtonItem *trashButton;
    
    PlannedVisit * visit;
    NSMutableString * visitTitle;
    NSMutableString *visitNotes;
    NSMutableString *visitFromDate;
    NSMutableString * visitToDate;
    NSArray * visitFistNations;

}
@property (nonatomic, retain) PlannedVisit * visit;

@property (nonatomic, retain) NSString * visitTitle;
@property (nonatomic, retain) NSString *visitNotes;
@property (nonatomic, retain) NSString *visitFromDate;
@property (nonatomic, retain) NSString * visitToDate;
@property (nonatomic, retain) NSArray * visitFistNations;
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
- (void)AddLand;

-(IBAction)Cancel:(id)sender;
-(void) ShiftDownDatePicker;
-(void) ShiftUpDatePicker;
-(void) SetEnabledDateCells:(BOOL) enabled;
-(void) SetEnabledTitleCell:(BOOL) enabled;
-(void) SetEnabledFirstNationEdit:(BOOL) enabled;
-(void) ShiftViewForCellAtIndexPath : (NSIndexPath *) indexpath;
-(void) ShiftBackView;
@end
