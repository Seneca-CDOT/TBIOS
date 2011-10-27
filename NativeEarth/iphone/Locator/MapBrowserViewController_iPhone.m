//
//  MapBrowserViewController_iPhone.m
//  TheFirstNation
//
//  Created by Ladan Zahir on 11-05-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapBrowserViewController_iPhone.h"
#import "ReverseGeocoder.h"
#import "LandShort.h"
//#import "SearchListController.h"
#import "DistrictCenterAnnotation.h"
#import "DistrictCenterAnnotationView.h"
#import "CalloutMapAnnotationView.h"
#import "WSLand.h"

@implementation MapBrowserViewController_iPhone

@synthesize     mapView;
@synthesize lands;
@synthesize     originLocation;
@synthesize     selectedAnnotationView = _selectedAnnotationView;
@synthesize     calloutAnnotation = _calloutAnnotation;
@synthesize originAnnotationTitle, selectedLandName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)dealloc 
{
    [self .lands release];
    [self.calloutAnnotation release];
    [self.selectedAnnotationView release];
    [self.originAnnotationTitle release];
    [self.selectedLandName release];
    [self.mapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    
    [self drawOverlaysOfArray:lands];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mapView =nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Drawing
-(void)drawOverlaysOfArray:(NSArray*)landsArray{
    //clear the map first
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    if(landsArray !=nil ){
    NSMutableArray * polygons = [[NSMutableArray alloc]init];
    NSMutableArray *annotations =[[NSMutableArray alloc]init];
        
   for (Land * land in landsArray) {

      NSString * coordinateString = land.Coordinates;
     
       NSUInteger length=0;
       CLLocationCoordinate2D * CoordinateArray = parseCoordinatesStringAsCLLocationCoordinate2D(coordinateString, &length);
 
        MKPolygon *poly = [MKPolygon polygonWithCoordinates:CoordinateArray count:length interiorPolygons:nil];
       [polygons addObject:poly];
       //annotation:
       NSString *centerCoordinatesString = land.CenterPoint; 
       NSUInteger len=0;
       CLLocationCoordinate2D * centreCoordinates =parseCoordinatesStringAsCLLocationCoordinate2D(centerCoordinatesString, &len);
       if (len>0) {
           DistrictCenterAnnotation * annotation = [[[DistrictCenterAnnotation alloc]initWithLatitude:centreCoordinates[0].latitude andLongitude:centreCoordinates[0].longitude]autorelease];
           
           annotation.title = land.LandName;
           annotation.subTitle= [land.DateFrom description];
           [annotations addObject:annotation];
       } 
    }
	[mapView addOverlays:(NSArray*)polygons];   
    [mapView addAnnotations:annotations];
    
        //Add Annotation for originLocation: 
        
        DistrictCenterAnnotation * originAnnotation = [[[DistrictCenterAnnotation alloc]initWithLatitude:originLocation.latitude andLongitude:originLocation.longitude] autorelease];
        originAnnotation.title = self.originAnnotationTitle;
        [mapView addAnnotation:originAnnotation];
        for (DistrictCenterAnnotation * annot in mapView.annotations) {       
            if (annot.title == self.originAnnotationTitle || annot.title== self.selectedLandName) {
                [mapView selectAnnotation:annot animated:FALSE];
            }
        }
        
    [self flyToPin:nil];

    }

}
-(IBAction)flyToPin:(id) sender{
    
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKOverlay> overlay in mapView.overlays) {
        if (MKMapRectIsNull(flyTo)) {
            flyTo = [overlay boundingMapRect];
        } else {
            flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
        }
    }
    
    
    ///
    for (id <MKAnnotation> annotation in mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }

    ///
    
    
    
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(flyTo);
        
        MKCoordinateRegion savedRegion = [mapView regionThatFits:region];
        [self.mapView setRegion:savedRegion animated:YES];

    
}

#pragma  mark - Map View Delegate
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    
}

- (void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
  

}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonView * view = [[[MKPolygonView alloc] initWithOverlay:overlay] autorelease];
        
        view.lineWidth = 2;
        view.strokeColor =[[UIColor redColor] colorWithAlphaComponent:0.2];
        view.fillColor =[[UIColor blueColor] colorWithAlphaComponent:0.2];
        return  view;
    }
    return nil;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        //[annotation setTitle:@"You are here!"];
      return nil;
    }
      
		MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 	reuseIdentifier:@"Annotation"] autorelease];
		annotationView.canShowCallout = YES;
    if (((DistrictCenterAnnotation*)annotation).title == self.originAnnotationTitle) {
        annotationView.pinColor = MKPinAnnotationColorRed;
    }else 	annotationView.pinColor = MKPinAnnotationColorPurple;
		return annotationView;
	
	return nil;

}



@end