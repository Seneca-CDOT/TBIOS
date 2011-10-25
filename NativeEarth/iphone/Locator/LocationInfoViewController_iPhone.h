//
//  LocationInfoViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Land.h"

@interface LocationInfoViewController_iPhone : BaseTableViewController<UITableViewDataSource,UITableViewDelegate> {
    NSString *language;
    CLLocationCoordinate2D originLocation;
}
@property (nonatomic, retain) Land* selectedLand;
@property (nonatomic, retain) NSArray * allLands;
@property (nonatomic) CLLocationCoordinate2D originLocation;
//NavigationMethods
-(void) NavigateToGreetings;
-(void) NavigateToImageGallery;
-(void) NavigateToGazetter;
-(void) NavigateToMap;

@end
