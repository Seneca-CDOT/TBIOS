//
//  MKMapView+ZoomLevel.h
//  NativeEarth
//
//  Created by Ladan Zahir on 12-04-09.
//  Referance: http://troybrant.net/blog/2010/01/set-the-zoom-level-of-an-mkmapview/
//  
#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end