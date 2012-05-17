//
//  LandSelectViewController.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Nation.h"

@interface NationSelectViewController_iPhone : BaseTableViewController<UITableViewDataSource,UITableViewDelegate> {
    NSString * language; 
    NSMutableArray* nationDictArray;
    NSMutableDictionary * selectedNationDict;
    CLLocationCoordinate2D originLocation;
    NSString * originTitle;
    
}
@property (nonatomic)    BOOL showOrigin;
@property (nonatomic)    CLLocationCoordinate2D  originLocation;

@property (nonatomic, retain) NSMutableArray* nationDictArray;
@property (nonatomic, retain) NSMutableDictionary *selectedNationDict;
@property (nonatomic,retain) NSString * originTitle;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;
@end
