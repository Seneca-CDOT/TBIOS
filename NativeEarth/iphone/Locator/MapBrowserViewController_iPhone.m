//
//  MapBrowserViewController_iPhone.m
//  TheFirstNation
//
//  Created by Ladan Zahir on 11-05-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapBrowserViewController_iPhone.h"
#import "ReverseGeocoder.h"
#import "FirstNation.h"
//#import "SearchListController.h"
#import "DistrictCenterAnnotation.h"
#import "DistrictCenterAnnotationView.h"
#import "CalloutMapAnnotationView.h"


@implementation MapBrowserViewController_iPhone

@synthesize     mapView;
@synthesize     locationDetector;
//@synthesize     searchList;
@synthesize     selectedAnnotationView = _selectedAnnotationView;
@synthesize     calloutAnnotation = _calloutAnnotation;


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
   
    [self.calloutAnnotation release];
    [self.selectedAnnotationView release];
    [self.locationDetector release];
    //[self.searchList release];
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
    // Do any additional setup after loading the view from its nib.
    
    // GPS point
//    ReverseGeocoder * rgc = [[ReverseGeocoder alloc] init];
//    rgc.managedObjectContext = self.managedObjectContext;
//    
//    
//    NSArray * districts= [rgc findDistrictForCoordinateWithLat:currentLatitude AndLng:currentLongitude];
//    
//    NSString * result1= [[[districts objectAtIndex:0] valueForKey:@"DistrictName"] description];
//     
 
    if (self.remoteHostStatus == NotReachable ) 
        self.locationDetector =[[LocationDetector alloc]initWithRetrieveOption:Locally WithManagedObjectContext: self.managedObjectContext];
   else self.locationDetector =[[LocationDetector alloc]initWithRetrieveOption:Network WithManagedObjectContext:self.managedObjectContext];
    
    self.locationDetector.delegate = self;
    
  [self.locationDetector.locationManager startUpdatingLocation];
    
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


#pragma mark- LocationDetectorDelegate
-(void)locationUpdate:(CLLocation *)location{
    
   
 
}

-(void)LocationError:(NSError *)error{
  //  lable.text = [error description];
}

-(void)DistrictUpdate:(NSArray *)districts{
    if ([districts count]>0) {
       //lable.text = [[districts objectAtIndex:0]valueForKey:@"DistrictName"];
    
 
        [self drawOverlaysOfArray:districts];

    } 
}


#pragma mark - Drawing


-(void)drawOverlaysOfArray:(NSArray*)districtsArray{
    //clear the map first
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    
    if(districtsArray !=nil ){
    NSMutableArray * polygons = [[NSMutableArray alloc]init];
    NSMutableArray *annotations =[[NSMutableArray alloc]init];
        
   for (NSDictionary* district in districtsArray) {

      NSString * coordinateString = [district valueForKey:@"Coordinates"];
     
       NSUInteger length=0;
       CLLocationCoordinate2D * CoordinateArray = parseCoordinatesStringAsCLLocationCoordinate2D(coordinateString, &length);
 
        MKPolygon *poly = [MKPolygon polygonWithCoordinates:CoordinateArray count:length interiorPolygons:nil];
       [polygons addObject:poly];
       
       
       //annotation:
       NSString *centerCoordinatesString =[(NSDictionary*)[district valueForKey:@"FirstNation"]valueForKey:@"CentreCoordinates" ];
       NSUInteger len=0;
       CLLocationCoordinate2D * centreCoordinates =parseCoordinatesStringAsCLLocationCoordinate2D(centerCoordinatesString, &len);
       if (len>0) {
           DistrictCenterAnnotation * annotation = [[[DistrictCenterAnnotation alloc]initWithLatitude:centreCoordinates[0].latitude andLongitude:centreCoordinates[0].longitude]autorelease];
           annotation.title = [[district valueForKey:@"Name"] description];
           annotation.subTitle= [[district valueForKey:@"Description"] description];
           [annotations addObject:annotation];
       }
       
       
    }
	[mapView addOverlays:(NSArray*)polygons];   
    [mapView addAnnotations:annotations];
       
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKOverlay> overlay in polygons) {
        if (MKMapRectIsNull(flyTo)) {
            flyTo = [overlay boundingMapRect];
        } else {
            flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
            
        }
    }
 
    // Position the map so that all overlays are visible on screen.
    mapView.visibleMapRect = flyTo;

    }
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
      
    
    if (annotation == self.calloutAnnotation) {
		CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
        
		if (!calloutMapAnnotationView) {
			calloutMapAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation 
																			 reuseIdentifier:@"CalloutAnnotation"] autorelease];
			calloutMapAnnotationView.contentHeight = 78.0f;
            
            
			UIImage *asynchronyLogo = [UIImage imageNamed:@"asynchrony-logo-small.png"];
			UIImageView *asynchronyLogoView = [[[UIImageView alloc] initWithImage:asynchronyLogo] autorelease];
            
                UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                   [rightButton addTarget:self
                                action:@selector(showDetails:)
                        forControlEvents:UIControlEventTouchUpInside];
            [ calloutMapAnnotationView.contentView addSubview: rightButton];
                 
            
			asynchronyLogoView.frame = CGRectMake(5, 2, asynchronyLogoView.frame.size.width, asynchronyLogoView.frame.size.height);
			[calloutMapAnnotationView.contentView addSubview:asynchronyLogoView];
		}
		calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
		calloutMapAnnotationView.mapView = self.mapView;
		return calloutMapAnnotationView;
	} else {
		MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
																			   reuseIdentifier:@"Annotation"] autorelease];
		annotationView.canShowCallout = NO;
		annotationView.pinColor = MKPinAnnotationColorGreen;
		return annotationView;
	}	
	
	return nil;

}

- (void)showDetails:(id)sender
{
    // the detail view does not want a toolbar so hide it
 //   [self.navigationController setToolbarHidden:YES animated:NO];
    
   // [self.navigationController pushViewController:self.detailViewController animated:YES];
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view { 
           if (self.calloutAnnotation == nil) {
            self.calloutAnnotation= [[DistrictCenterAnnotation alloc]
                                      initWithLatitude:view.annotation.coordinate.latitude
                                      andLongitude:view.annotation.coordinate.longitude];
        } else {
            self.calloutAnnotation.latitude= view.annotation.coordinate.latitude;
            self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
        }
        [self.mapView addAnnotation:self.calloutAnnotation];
        self.selectedAnnotationView = view;
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (self.calloutAnnotation) {
        [self.mapView removeAnnotation: self.calloutAnnotation];
    }
}


@end