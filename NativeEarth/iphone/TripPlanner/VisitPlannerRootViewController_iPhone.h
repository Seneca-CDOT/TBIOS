//
//  VisitPlannerRootViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "NativeEarthAppDelegate_iPhone.h"
#import "EditAVisitViewController_iPhone.h"
@interface VisitPlannerRootViewController_iPhone : BaseTableViewController {
    NSMutableArray * plannedVisits;
    NativeEarthAppDelegate_iPhone *appDelegate ;
      NSDateFormatter *dateFormatter; 
}
@property(nonatomic,retain) NSMutableArray * plannedVisits;
@property(nonatomic,retain) NSDateFormatter *dateFormatter;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
