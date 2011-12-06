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
    NSString * originTitle;
}
@property (nonatomic, retain) Land* selectedLand;
@property (nonatomic, retain) NSArray * allLands;
@property (nonatomic) CLLocationCoordinate2D originLocation;
@property (nonatomic, retain) NSString * originTitle;
@property (nonatomic)         BOOL showOrigin;
//NavigationMethods
-(void) NavigateToGreetings;
//-(void) NavigateToImageGallery;
-(void) NavigateToGazetter;
-(void) NavigateToMap;
-(void) NavigateToScreenshotBrowser;
@end
