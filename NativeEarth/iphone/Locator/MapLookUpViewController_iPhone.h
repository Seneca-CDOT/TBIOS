//
//  MapLookUpViewController_iPhone.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "NetworkDataGetter.h"
#import "WSLand.h"
#import "LandSelectViewController_iPhone.h"
#import "ReverseGeocoder.h"
#import "GeopoliticalSearchViewController_iPhone.h"
typedef enum {
	Standard,
    Hybrid
} MapTypes;
@interface MapLookUpViewController_iPhone : BaseViewController <GeopoliticalSearchViewControllerDelegate>{ 
    MKMapView *mapView;
   BOOL pinIsDropped;
    UIBarButtonItem * redoButton;
    UIToolbar *toolbar;
    UISegmentedControl *mapTypeControl;
    CLLocationDegrees pinLatitude;
    CLLocationDegrees pinLongitude;
    NSArray * landArray;
    GeopoliticalSearchViewController_iPhone *SearchVC;
    
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mapTypeControl;
@property(nonatomic, retain) GeopoliticalSearchViewController_iPhone *SearchVC;

-(IBAction)dropPin:(id) sender;
-(void)flyToTheCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)flyToNorthAmerica;
-(IBAction)reloadMap:(id)sender;
-(IBAction)setMapType:(id)sender;

-(IBAction)SearchWithAddress:(id)sender;
@end
