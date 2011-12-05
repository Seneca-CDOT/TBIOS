//
//  ImageBrowser_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WSContent.h"
typedef enum{ Next, Previous} TransitionDirection;

@interface ImageBrowser_iPhone : BaseViewController {

	UIImageView *view1;
	UIImageView *view2;
	BOOL transitioning;
    UIView *containerView;
    UIImageView * imageView;
     NSInteger currentImageIndex;
     NSInteger nextImageIndex;
    NSString *locale;
    NSArray * managedImages;
}
@property(nonatomic, retain) NSArray * managedImages;
@property(nonatomic,retain) IBOutlet UIView *containerView;
@property(nonatomic,retain) IBOutlet UIImageView *imageView;
@property(nonatomic,retain) UIImageView *view1;
@property(nonatomic,retain) UIImageView *view2;
@property (nonatomic, retain) IBOutlet UILabel *lableTitle;
-(void)performTransitionWithDirection:(TransitionDirection)direction;
-(IBAction)nextTransition:(id)sender;
-(IBAction)previousTransition:(id)sender;

-(void) loadImagesWithDirection: (TransitionDirection) direction;

- (UIImage *)imageAtIndex:(int)index;

@end
