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
    UIButton  *  okButton;
    
    UIView *launcherView;
    UIView *infoView;
    UIView *blackView;
}

@property (nonatomic,retain)    IBOutlet UIButton    *  FirstNationLocatorBtn;
@property (nonatomic,retain)    IBOutlet UIButton    *  PlanAVisitBtn;
@property (nonatomic,retain)    IBOutlet UIButton    *  SettingsBtn;
@property (nonatomic,retain)    IBOutlet UIButton    *  infoBtn;
@property (nonatomic,retain)    IBOutlet UIButton    *  okBtn;

@property (nonatomic, retain) IBOutlet UIView *launcherView;
@property (nonatomic, retain) IBOutlet UIView *infoView;
@property (nonatomic, retain) IBOutlet UIView *blackView;

-(IBAction) FirstNationLocatorBtnAction:(id) sender;
-(IBAction) planAVisitBtnAction:(id) sender;

-(IBAction) goToSettings:(id) sender;
-(IBAction) flipAction:(id) sender;



@end
