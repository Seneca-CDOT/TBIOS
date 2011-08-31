//
//  GeopoliticalSearchViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Geocoder.h"

@protocol GeopoliticalSearchViewControllerDelegate ;


@interface GeopoliticalSearchViewController_iPhone : BaseViewController <GeocoderDelegate,UISearchBarDelegate>{
    id<GeopoliticalSearchViewControllerDelegate> delegate;
    UITableView *resultsTableView;
    UIToolbar *toolbar;
}
@property (nonatomic, retain ) NSMutableArray * results;
@property (nonatomic, assign) id<GeopoliticalSearchViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic,retain) IBOutlet UITableView * resultsTableView;
-(IBAction) CancelButtonAction:(id) sender;
@end


@protocol GeopoliticalSearchViewControllerDelegate 
-(void) GeopoliticalSearchViewController:(GeopoliticalSearchViewController_iPhone *)controller didSelectAResult:(NSDictionary*) result;
@end