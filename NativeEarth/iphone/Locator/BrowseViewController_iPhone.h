//
//  BrowseViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NetworkDataGetter.h"
#import "WSNation.h"


typedef enum {
	ForLocator= 0,
    ForVisitPlanner
} BrowseType;
@class ShortNation;// has to be defined later.

@protocol BrowseViewController_iPhoneDelegate;

@interface BrowseViewController_iPhone : BaseViewController<UISearchDisplayDelegate, UISearchBarDelegate > {
    BrowseType browseType;
    NSMutableArray * completeList;
    NSMutableArray * filteredList;
    id<BrowseViewController_iPhoneDelegate> delegate;
    UITableView * resultsTableView;
    UIToolbar * toolbar;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    BOOL nationIsSelected;
    BOOL isGrouped;
    NSFetchedResultsController * frcShortNations;
    }
@property (nonatomic) BrowseType browseType;

@property (nonatomic, assign) id<BrowseViewController_iPhoneDelegate> delegate;

@property (nonatomic, retain ) NSMutableArray * completeList;

@property (nonatomic, retain) NSMutableArray * filteredList;

@property (nonatomic, retain) NSMutableData *dataStream;

@property(nonatomic,retain) NSFetchedResultsController * frcShortNations;

@property(nonatomic,retain) IBOutlet UITableView * resultsTableView;

@property(nonatomic,retain) IBOutlet UIToolbar* toolbar;
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain) IBOutlet UISearchDisplayController *searchDisplayController;

-(IBAction) CancelButtonAction:(id) sender;

-(void) GetShortNationList;
-(Nation*) GetNationByNationNumber:(int) number;
@end

@protocol BrowseViewController_iPhoneDelegate

-(void) BrowseViewControllerDidSelectNation:(ShortNation *) nation;

@end
