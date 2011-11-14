//
//  ScreenShotTest.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Map.h"

@interface ScreenShotTest : UIViewController <UIAlertViewDelegate>{
    
}

@property(nonatomic,retain) Map * map;
@property(nonatomic,retain) IBOutlet UIImageView * imageView;
-(void)deleteImage:(id)sender;
@end
