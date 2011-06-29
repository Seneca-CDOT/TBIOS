//
//  LauncherViewController.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LauncherViewController_iPhone : BaseViewController {
    
    UIButton  *  FirstNationLocatorBtn;
    UIButton  *  PlanAVisitBtn;
    UIButton  *  SettingsBtn;
    UIButton  *  infoBtn;
}

@property (nonatomic,retain)    IBOutlet UIButton    *  FirstNationLocatorBtn;
@property (nonatomic,retain)    IBOutlet UIButton    *  PlanAVisitBtn;
@property (nonatomic,retain)    IBOutlet UIButton    *  SettingsBtn;
@property (nonatomic,retain)    IBOutlet UIButton    *  infoBtn;



-(IBAction) FirstNationLocatorBtnAction:(id) sender;
-(IBAction) planAVisitBtnAction:(id) sender;

-(IBAction) goToSettings:(id) sender;
-(IBAction) infoBtnAction:(id) sender;



@end
