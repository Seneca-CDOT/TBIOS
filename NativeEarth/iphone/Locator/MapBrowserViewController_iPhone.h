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
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DistrictCenterAnnotation.h"

@interface MapBrowserViewController_iPhone:BaseViewController <LocationDetectorDelegate, MKMapViewDelegate, AVAudioPlayerDelegate> 
{
    MKMapView                   *mapView;
    NSArray                     * viewDistricts;
    UINavigationController      *searchListNavigationController;
    
    DistrictCenterAnnotation    * _calloutAnnotation;
	MKAnnotationView            *_selectedAnnotationView;
    
    
    NSURL						*soundFileURL;
    AVAudioPlayer				*appSoundPlayer;
 
}


@property (nonatomic,retain)            LocationDetector          *locationDetector;
@property (nonatomic,retain)            IBOutlet   MKMapView      *mapView;

@property (nonatomic, retain)           MKAnnotationView          *selectedAnnotationView;
@property (nonatomic, retain)           DistrictCenterAnnotation  *calloutAnnotation;


-(void)         drawOverlaysOfArray: (NSArray*)districtsArray;

@end

