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
}

- (void)dealloc
{
    mapView.delegate = nil;
	[mapView release];
    [toolbar release];
    [redoButton release];
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
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
        draggablePinView.rightCalloutAccessoryView = rightButton;
	} else {


        draggablePinView = [[MKPinAnnotationView alloc]initWithAnnotation: annotation reuseIdentifier:kPinAnnotationIdentifier];
       // draggablePinView.annotation = annotation;
        draggablePinView.draggable = YES;
        draggablePinView.canShowCallout = YES;
       draggablePinView.rightCalloutAccessoryView = rightButton;
        
	}		

    
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

-(IBAction)reloadMap{
    [self.mapView removeAnnotations:mapView.annotations];
    pinIsDropped= NO;
    [self.mapView reloadInputViews];
}

-(void)showDetails: (id) sender{
    
}
@end
