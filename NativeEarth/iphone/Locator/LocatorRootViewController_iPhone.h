//
//  LocatorRootViewController.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "LocationDetector.h"
#import "WSNation.h"
@interface LocatorRootViewController_iPhone : BaseTableViewController <UITableViewDataSource, UITableViewDelegate,LocationDetectorDelegate>{
    CLLocationCoordinate2D currentlocation;
    BOOL isLocationDetected;
}
@property (nonatomic,retain)   LocationDetector *locationDetector;
-(void)GoToCurrentLocation;
-(void)BrowseByName;
//-(void)BrowseByGeopoliticalName;
-(void)BrowseMap;

-(NSArray *)GetWSNationsFromDictArray:(NSArray *) dictArray;
-(WSNation *)GetWSNationForDict:(NSDictionary *)dict;
@end
