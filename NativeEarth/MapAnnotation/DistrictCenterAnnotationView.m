//
//  DistrictCenterAnnotationView.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DistrictCenterAnnotationView.h"
#define kHeight  40
#define kWidth  37
#define kBorder 2

@implementation DistrictCenterAnnotationView
@synthesize imageView;
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    DistrictCenterAnnotation * annot =(DistrictCenterAnnotation*) annotation;
    self= [super initWithAnnotation:annot reuseIdentifier:reuseIdentifier];
    self.frame =CGRectMake(0,0,kWidth,kWidth);
    self.backgroundColor=[UIColor clearColor];
    
    imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paperPlane.png"]];
    imageView.frame = CGRectMake(kBorder, kBorder, kWidth-2*kBorder, kHeight-2 *kBorder);
    [self addSubview:imageView];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    return self;
}
@end
