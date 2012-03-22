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

@interface LocationInfoViewController_iPhone : BaseTableViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate> {
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
//NavigationMethods
-(void) NavigateToGreetings;
//-(void) NavigateToImageGallery;
-(void) NavigateToMap;
-(void) NavigateToScreenshotBrowser;

@end
