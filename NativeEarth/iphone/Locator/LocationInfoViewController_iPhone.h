//
//  LocationInfoViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Nation.h"
#import "NativeEarthAppDelegate_iPhone.h"
#import "EditAVisitViewController_iPhone.h"


@interface LocationInfoViewController_iPhone : BaseTableViewController<UITableViewDataSource,UITableViewDelegate,EditAVisitViewControllerDelegate_iPhone,UIAlertViewDelegate> {
    NSString *language;
    CLLocationCoordinate2D originLocation;
    NSString * originTitle;
     NativeEarthAppDelegate_iPhone *appDelegate;

}
@property (nonatomic, retain) Nation* selectedNation;
@property (nonatomic, retain) NSArray * allNations;
@property (nonatomic) CLLocationCoordinate2D originLocation;
@property (nonatomic, retain) NSString * originTitle;
@property (nonatomic)         BOOL showOrigin;
@property (nonatomic) BOOL shouldLetAddToVisit;
@property (nonatomic,retain) NSString * deviceType;
//NavigationMethods
-(void) NavigateToGreetings;
-(void) NavigateToMap;
-(void) NavigateToScreenshotBrowser;
-(void) NavigateToLands;
-(void) NavigateToAllMaps;
-(void) DialPhone;
-(void) OpenCommunitySite;
@end
