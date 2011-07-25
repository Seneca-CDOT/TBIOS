//
//  MapLookUpViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapLookUpViewController_iPhone.h"
#import "DDAnnotation.h"



@implementation MapLookUpViewController_iPhone
@synthesize mapView;
@synthesize redoButton;
@synthesize toolbar;
@synthesize mapTypeControl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mapView removeAnnotations:mapView.annotations];
    pinIsDropped= NO;
    [self flyToNorthAmerica];

}

- (void)dealloc
{
    self.mapView.delegate = nil;
	[self.mapView release];
    [self.toolbar release];
    [self.redoButton release];
    [self.mapTypeControl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mapView = nil;
    self.toolbar= nil;
    self.redoButton = nil;
    self.mapTypeControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];		
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
   	
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
	}
    
  UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self
                    action:@selector(showDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
    
	MKAnnotationView *draggablePinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
		
    if(!draggablePinView){
        draggablePinView = [[MKPinAnnotationView alloc]initWithAnnotation: annotation reuseIdentifier:kPinAnnotationIdentifier];
    }
    draggablePinView.annotation = annotation;
    draggablePinView.draggable = YES;
    draggablePinView.canShowCallout = YES;
    draggablePinView.rightCalloutAccessoryView = rightButton;
	return draggablePinView;
}


-(IBAction)dropPin:(id) sender{
    if (!pinIsDropped) {
    CLLocationCoordinate2D theCoordinate =self.mapView.centerCoordinate;
	DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
	annotation.title = @"Drag to Move Pin";
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	
	[self.mapView addAnnotation:annotation];
        
    pinIsDropped = YES;
        
    }else{
        CLLocationCoordinate2D theCoordinate = [(DDAnnotation*)[self.mapView.annotations objectAtIndex:0] coordinate];
        [self flyToTheCoordinate:theCoordinate];
    }
}

-(void)flyToTheCoordinate:(CLLocationCoordinate2D)coordinate{
[self.mapView setCenterCoordinate:coordinate animated:YES];

}   

-(void)flyToNorthAmerica{
    // canada: 58.263287,-104.765625
    
    MKCoordinateRegion region;
    region.center.latitude = 58.263287;
    region.center.longitude = -104.765625;
    region.span.latitudeDelta = 50;
    region.span.longitudeDelta = 50;
    
    MKCoordinateRegion savedRegion = [mapView regionThatFits:region];
    [self.mapView setRegion:savedRegion animated:YES];
}

-(IBAction)reloadMap:(id)sender{
    [self.mapView removeAnnotations:mapView.annotations];
    pinIsDropped= NO;
    [self flyToNorthAmerica];
    
}
-(IBAction)setMapType:(id)sender{
    UISegmentedControl * mapTypes = (UISegmentedControl*)sender;
    if (mapTypes.selectedSegmentIndex == Standard) {
        [self.mapView setMapType:MKMapTypeStandard];
    }else{
         [self.mapView setMapType:MKMapTypeHybrid];
    }
}
-(void)showDetails: (id) sender{
   

}
@end
