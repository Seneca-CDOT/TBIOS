//
//  ImageBrowser_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef enum{ Next, Previous} TransitionDirection;

@interface ImageBrowser_iPhone : BaseViewController {

	UIImageView *view1;
	UIImageView *view2;
	BOOL transitioning;
    UIView *containerView;
    UIImageView * imageView;
    NSArray * imageArray;
     NSInteger currentImageIndex;
     NSInteger nextImageIndex;
    
    NSArray * wSImages;
}
@property(nonatomic, retain) NSArray * wSImages;
@property(nonatomic,retain) NSArray * imageArray;
@property(nonatomic,retain) IBOutlet UIView *containerView;
@property(nonatomic,retain) IBOutlet UIImageView *imageView;
@property(nonatomic,retain) UIImageView *view1;
@property(nonatomic,retain) UIImageView *view2;
-(void)performTransitionWithDirection:(TransitionDirection)direction;
-(IBAction)nextTransition:(id)sender;
-(IBAction)previousTransition:(id)sender;

-(void) loadImagesWithDirection: (TransitionDirection) direction;
@end
