//
//  AddAVisitViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditAVisitViewController_iPhone.h"

@protocol AddAVisitViewController_iPhoneDelegate;

@interface AddAVisitViewController_iPhone : EditAVisitViewController_iPhone {
    
}

@end

@protocol AddAVisitViewController_iPhoneDelegate
- (void)addAVisitViewController:(EditAVisitViewController_iPhone *)controller didFinishWithSave:(BOOL)save;
@end
