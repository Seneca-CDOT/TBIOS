//
//  LandSelectViewController.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Land.h"

@interface LandSelectViewController_iPhone : BaseTableViewController<UITableViewDataSource,UITableViewDelegate> {
    NSString * language;
    Land * selectedLand;
    CLLocationCoordinate2D originLocation;
}
@property (nonatomic, retain) NSMutableArray* landArray;
@property (nonatomic) CLLocationCoordinate2D  originLocation;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
