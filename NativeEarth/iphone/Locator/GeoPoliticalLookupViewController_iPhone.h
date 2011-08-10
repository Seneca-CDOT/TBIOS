//
//  GeoPoliticalLookupViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TextFieldCell_iPhone.h"
#import "NetworkDataGetter.h"

typedef enum {
	LookupForLocator= 0,
    LookUpForVisitPlanner
} GeoLookupType;
@class LandShort;// has to be defined later.
@protocol GeoPoliticalLookupViewController_iPhoneDelegate;

@interface GeoPoliticalLookupViewController_iPhone : BaseViewController<UITableViewDataSource,UITableViewDelegate ,TextFieldCellDelegate,NetworkDataGetterDelegate> {
      GeoLookupType geoLookupType;
    UITableView *tableView;
    id<GeoPoliticalLookupViewController_iPhoneDelegate> delegate;
    UIToolbar * toolbar;
    NSArray * resultList;
    UIButton *searchButton;
}
@property (nonatomic, retain) NSMutableData *dataStream;

@property (nonatomic, retain) NSArray *resultList;

@property (nonatomic) GeoLookupType geoLookupType;

@property (nonatomic, assign) id<GeoPoliticalLookupViewController_iPhoneDelegate> delegate;

@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic,retain) IBOutlet UIButton *searchButton;

@property(nonatomic,retain) IBOutlet UIToolbar* toolbar;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

-(IBAction) CancelButtonAction:(id) sender;

-(void) GetFirstNationListFromWebService;

- (void)searchButtonTapped:(id)sender;

- (UIButton *)newButtonWithTitle:(NSString *)title
                          target:(id)target
                        selector:(SEL)selector
                           frame:(CGRect)frame
                           image:(UIImage *)image
                    imagePressed:(UIImage *)imagePressed
                   darkTextColor:(BOOL)darkTextColor;

@end


@protocol GeoPoliticalLookupViewController_iPhoneDelegate

-(void) GeoPoliticalLookupViewControllerDidSelectFirstNation:(LandShort *) nation;

@end
