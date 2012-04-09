//
//  GreetingViewController.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Greeting.h"

@interface GreetingViewController_iPhone : BaseViewController<UITableViewDataSource,UITableViewDelegate> {

}

@property (nonatomic, retain)      NSString             *language;
@property(nonatomic,retain)         Greeting            *greeting;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;
@end
