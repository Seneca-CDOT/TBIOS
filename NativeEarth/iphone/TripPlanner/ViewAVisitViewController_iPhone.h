//
//  ViewAVisitViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-10-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "PlannedVisit.h"
@interface ViewAVisitViewController_iPhone : BaseTableViewController {
    
    PlannedVisit * visit;
}
@property (nonatomic, retain) PlannedVisit * visit;
@end
