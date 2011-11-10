//
//  MapBrowserViewController_iPhone.h
//  TheFirstNation
//
//  Created by Ladan Zahir on 11-05-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "LocationDetector.h"
#import "Reachability.h"

#import "DistrictCenterAnnotation.h"
#import "Land.h"

@interface MapBrowserViewController_iPhone:BaseViewController <MKMapViewDelegate> 
{
    MKMapView                   *mapView;
    NSArray                     *lands;
    UINavigationController      *searchListNavigationController;
    
    DistrictCenterAnnotation    * _calloutAnnotation;
	MKAnnotationView            *_selectedAnnotationView;

    NSString * language;
    CLLocationCoordinate2D originLocation;
    NSString * originAnnotationTitle;
    NSString * selectedLandName;
}


//@property (nonatomic,retain)            LocationDetector          *locationDetector;
@property (nonatomic,retain)            IBOutlet   MKMapView      *mapView;
@property (nonatomic, retain)           NSArray                   *lands;
@property (nonatomic, retain)           MKAnnotationView          *selectedAnnotationView;
@property (nonatomic, retain)           DistrictCenterAnnotation  *calloutAnnotation;
@property(nonatomic)                    CLLocationCoordinate2D     originLocation;
@property(nonatomic,retain)             NSString                   *originAnnotationTitle;
@property(nonatomic,retain)             NSString                   *selectedLandName;
@property(nonatomic)                    BOOL                        showOrigin;
-(IBAction)flyToPin:(id) sender;

-(void)  drawOverlaysOfArray: (NSArray*)landsArray;
-(UIImage*) screenshot;
-(UIImage *)GetMapviewImage;
-(IBAction)takeScreenShot :(id) sender;
@end

