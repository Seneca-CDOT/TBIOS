//
//  AddAVisitViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewAVisitViewController_iPhone.h"

@protocol AddAVisitViewController_iPhoneDelegate;

@interface AddAVisitViewController_iPhone : ViewAVisitViewController_iPhone {
    
}

@end

@protocol AddAVisitViewController_iPhoneDelegate
- (void)addAVisitViewController:(ViewAVisitViewController_iPhone *)controller didFinishWithSave:(BOOL)save;
@end
