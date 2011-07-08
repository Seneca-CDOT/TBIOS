//
//  BrowseViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
typedef enum {
	ByName = 0,
    ByGeopoliticalName
} BrowseType;
@interface BrowseViewController_iPhone : BaseTableViewController<UISearchDisplayDelegate, UISearchBarDelegate> {
    BrowseType browseType;
    NSMutableArray * completeList;
    NSMutableArray * filteredList;
}
@property (nonatomic) BrowseType browseType;

@property (nonatomic, retain ) NSMutableArray * completeList;

@property (nonatomic, retain) NSMutableArray * filteredList;

@property (nonatomic, retain) NSMutableData *dataStream;

-(void) GetFirstNationListFromWebService;

@end
