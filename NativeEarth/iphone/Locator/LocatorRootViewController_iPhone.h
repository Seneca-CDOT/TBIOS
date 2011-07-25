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

@interface LocatorRootViewController_iPhone : BaseTableViewController <UITableViewDataSource, UITableViewDelegate,LocationDetectorDelegate>{
    
}
@property (nonatomic,retain)   LocationDetector *locationDetector;
-(void)GoToCurrentLocation;
-(void)BrowseByName;
-(void)BrowseByGeopoliticalName;
-(void)BrowseMap;
@end

/*if([self conformsToProtocol:@protocol(CLLocationManagerDelegate)]) {  // Check if the class assigning 
 [self locationError:error];
 }*/