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
#import "Nation.h"
@class OverlayGroup;
@interface MapBrowserViewController_iPhone:BaseViewController <MKMapViewDelegate> 
{
    MKMapView                   *mapView;
    NSArray                     *nations;
    UINavigationController      *searchListNavigationController;
    
    DistrictCenterAnnotation    * _calloutAnnotation;
	MKAnnotationView            *_selectedAnnotationView;

    NSString * language;
    CLLocationCoordinate2D originLocation;
    NSString * originAnnotationTitle;
    NSString * selectedNationName;
    BOOL isBrowsingNation;//NO if a single land of a nation is being browsed.
    Land * referringLand;
    Nation * referringNation;
    NSMutableArray * overlayGroups;
}


@property (nonatomic,retain)            IBOutlet   MKMapView      *mapView;
@property (nonatomic, retain)           NSArray                   *nations;
@property (nonatomic, retain)           MKAnnotationView          *selectedAnnotationView;
@property (nonatomic, retain)           DistrictCenterAnnotation  *calloutAnnotation;
@property (nonatomic,retain)             NSString                   *originAnnotationTitle;
@property (nonatomic,retain)             NSString                   *selectedNationName;
@property (nonatomic, retain )          Land                        * referringLand;
@property (nonatomic, retain )          Nation                      * referringNation;
@property (nonatomic)                    BOOL                        showOrigin;
@property (nonatomic)                    CLLocationCoordinate2D     originLocation;
@property (nonatomic)                   BOOL                        isBrowsingNation;


-(IBAction)flyToPin:(id) sender;

-(void)  drawOverlaysOfArray: (NSArray*)nationsArray;
-(UIImage*) screenshot;
-(UIImage *)GetMapviewImage;
-(IBAction)takeScreenShot :(id) sender;
@end

