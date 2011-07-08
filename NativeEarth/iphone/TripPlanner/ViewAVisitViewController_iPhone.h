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
@interface ViewAVisitViewController_iPhone : BaseViewController<UITableViewDataSource, UITableViewDelegate,TextViewCellDelegate> {
    
   NSDateFormatter *dateFormatter; 
    UIDatePicker *pickerView;
    UITableView *infoTableView;
 UIBarButtonItem *doneButton;
}
@property (nonatomic, retain) NSDateFormatter *dateFormatter; 

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic,retain) IBOutlet UIToolbar * toolBar;
@property (nonatomic,retain) IBOutlet UITableView * infoTableView;
@property (nonatomic, retain) IBOutlet UIDatePicker *pickerView; 
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)dateAction:(id)sender;	// when the user has changed the date picke values (m/d/y)

@end
