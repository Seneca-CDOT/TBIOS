//
//  DistrictCenterAnnotationView.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "DistrictCenterAnnotation.h"
@interface DistrictCenterAnnotationView : MKAnnotationView {
    UIImageView * imageView;
}
@property (nonatomic,retain) UIImageView * imageView;;
@end
