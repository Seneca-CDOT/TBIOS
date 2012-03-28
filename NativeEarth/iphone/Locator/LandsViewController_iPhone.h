//
//  LandsViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
@class Nation;
@class Land;
@interface LandsViewController_iPhone :BaseTableViewController  {
     NSMutableArray * landList;
    Nation *referringNation ;
    NSString * locale;
    Land *selectedLand;
    
}
@property (nonatomic, retain ) NSMutableArray * landList;
@property (nonatomic, retain ) Nation * referringNation;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;
-(void)navigateToMap;
@end
