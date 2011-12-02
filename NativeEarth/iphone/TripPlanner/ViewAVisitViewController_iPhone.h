//
//  ViewAVisitViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-10-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "EditAVisitViewController_iPhone.h"
#import "PlannedVisit.h"
#import "Constants.h"
@interface ViewAVisitViewController_iPhone : BaseTableViewController <UITableViewDataSource,UITableViewDelegate,EditAVisitViewControllerDelegate_iPhone>{
    
    PlannedVisit * visit;
      NSDateFormatter *dateFormatter; 

}
@property (nonatomic, retain) PlannedVisit * visit;

@property (nonatomic, retain) NSDateFormatter *dateFormatter; 
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)EditButtonAction:(id) sender;
@end
