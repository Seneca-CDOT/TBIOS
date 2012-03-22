//
//  MapLookUpViewController_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapLookUpViewController_iPhone.h"
#import "DDAnnotation.h"
#import "LocationInfoViewController_iPhone.h"


@implementation MapLookUpViewController_iPhone
@synthesize mapView;
@synthesize redoButton;
@synthesize toolbar;
@synthesize mapTypeControl;
@synthesize SearchVC;
@synthesize nationArray;
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
    [self.SearchVC release];
	[self.mapView release];
    [self.toolbar release];
    [self.redoButton release];
    [self.mapTypeControl release];
    [self.nationArray release];
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
     ReverseGeocoder *rgeocoder = [[ReverseGeocoder alloc] init];
      //  [landArray removeAllObjects];      
        pinLatitude = annotation.coordinate.latitude;
        pinLongitude = annotation.coordinate.longitude;
       pinLocationTitle =NSLocalizedString(@"Your destination!",@"Your destination!");
    self.nationArray= [NSMutableArray arrayWithArray:[rgeocoder FindNearbyNationsForCoordinateWithLat:pinLatitude andLng:pinLongitude]];

        
        if ([self.nationArray count]>0) {
            annotation.title = NSLocalizedString(@"Select",@"Select");
            annotation.subtitle = nil;
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
        
            annotationView.rightCalloutAccessoryView = rightButton;

        }else{
            annotation.title = NSLocalizedString(@"Drag to Move Pin",@"Drag to Move Pin");
            annotation.subtitle = NSLocalizedString(@"No First Nation Found", @"No First Nation Found");
            annotationView.rightCalloutAccessoryView=nil;
        }
    }
    
    
    
    
// get the land names here and add it to anotation
}

-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to load the map",@"Unable to load the map") message:NSLocalizedString(@"Check to see if you have internet access",@"Check to see if you have internet access") delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles: nil];
    [alert show];
    [alert release];
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
        draggablePinView.rightCalloutAccessoryView= nil;
    }
    draggablePinView.annotation = annotation;
    draggablePinView.draggable = YES;
    draggablePinView.canShowCallout = YES;
    if ([self.nationArray count]>0) {
        ((DDAnnotation*) annotation).title = NSLocalizedString(@"Select",@"Select");
        ((DDAnnotation*) annotation).subtitle = nil;
            draggablePinView.rightCalloutAccessoryView = rightButton;
    }else{
        ((DDAnnotation*) annotation).title = NSLocalizedString(@"Drag to Move Pin",@"Drag to Move Pin");
        ((DDAnnotation*) annotation).subtitle = NSLocalizedString(@"No First Nation Found", @"No First Nation Found");
        draggablePinView.rightCalloutAccessoryView = nil;
    }

	return draggablePinView;
}

#pragma mark - IBAction Methods
-(IBAction)dropPin:(id) sender{
    if (!pinIsDropped) {
    CLLocationCoordinate2D theCoordinate =self.mapView.centerCoordinate;
        pinLatitude = theCoordinate.latitude;
        pinLongitude= theCoordinate.longitude;
        pinLocationTitle =NSLocalizedString(@"Your destination!",@"Your destination!");
	DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
        
	
	[self.mapView addAnnotation:annotation];
        
    pinIsDropped = YES; 
        
    ReverseGeocoder *rgeocoder = [[ReverseGeocoder alloc] init];
    //[landArray removeAllObjects];
    self.nationArray= [NSMutableArray arrayWithArray:[rgeocoder FindNearbyNationsForCoordinateWithLat:pinLatitude andLng:pinLongitude]];

    }else{
        CLLocationCoordinate2D theCoordinate = [(DDAnnotation*)[self.mapView.annotations objectAtIndex:0] coordinate];
        [self flyToTheCoordinate:theCoordinate];
    }

}
-(IBAction)SearchWithAddress:(id)sender{
    self.SearchVC =[[GeopoliticalSearchViewController_iPhone alloc] initWithNibName:@"GeopoliticalSearchViewController_iPhone" bundle:nil];
    self.SearchVC.delegate = self;
    self.SearchVC.title= NSLocalizedString(@"Address", @"Address");
     [self.navigationController presentModalViewController:self.SearchVC animated:YES];
}

-(IBAction)reloadMap:(id)sender{
    [self.mapView removeAnnotations:mapView.annotations];
    pinIsDropped= NO;
    [self flyToNorthAmerica];
    
}


-(void)flyToTheCoordinate:(CLLocationCoordinate2D)coordinate{
[self.mapView setCenterCoordinate:coordinate animated:YES];

}   

-(void)flyToNorthAmerica{
    // canada: 
    //http://maps.google.ca/maps/myplaces?hl=en&ll=56.130366,-106.346771&spn=128.783236,319.570313&mpa=0&ctz=240&mpf=0&z=2&vpsrc=0
    MKCoordinateRegion region;
    region.center.latitude = 58.130366;
    region.center.longitude = -106.346771;
    region.span.latitudeDelta = 50;
    region.span.longitudeDelta = 50;
    
    MKCoordinateRegion savedRegion = [mapView regionThatFits:region];
    [self.mapView setRegion:savedRegion animated:YES];
}

-(void)showDetails: (id) sender{
    
    if ([nationArray count]>=1) {
        NationSelectViewController_iPhone *nextVC = [[NationSelectViewController_iPhone alloc]initWithStyle:UITableViewStyleGrouped];
    
        nextVC.remoteHostStatus = self.remoteHostStatus;
        nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
        nextVC.internetConnectionStatus = self.internetConnectionStatus;
    
        nextVC.nationArray=[NSMutableArray arrayWithArray: nationArray];//lands;
        
        nextVC.title= NSLocalizedString(@"Select a Land", @"Select a Land");
        CLLocationCoordinate2D origin =CLLocationCoordinate2DMake(pinLatitude, pinLongitude);
        nextVC.originLocation = origin;
        nextVC.originTitle = pinLocationTitle;
        nextVC.showOrigin=YES;
        [self.navigationController pushViewController:nextVC animated:YES];
        [nextVC release];
    }
    
}
   

#pragma mark - GeopoliticalSearchViewControllerDelegate Method

-(void) GeopoliticalSearchViewController:(GeopoliticalSearchViewController_iPhone *)controller didSelectAResult:(NSDictionary*) result{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    NSDictionary *northeast = [[[result objectForKey:@"geometry"] objectForKey:@"bounds"] objectForKey:@"northeast"];
    NSDictionary *southwest = [[[result objectForKey:@"geometry"] objectForKey:@"bounds"] objectForKey:@"southwest"];
    NSDictionary *center = [[result objectForKey:@"geometry"] objectForKey:@"location"];
    pinLocationTitle = [[result valueForKey:@"formatted_address"] description];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake( [[center objectForKey:@"lat"] floatValue], [[center objectForKey:@"lng"] floatValue]);
    
    MKCoordinateSpan span = MKCoordinateSpanMake([[northeast objectForKey:@"lat"] floatValue]-[[southwest objectForKey:@"lat"] floatValue], [[northeast objectForKey:@"lng"] floatValue]-[[southwest objectForKey:@"lng"] floatValue]);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);	

 [self.mapView setRegion:[self.mapView regionThatFits:region]animated:YES]; 
    [self.mapView removeAnnotations:mapView.annotations];
    pinIsDropped= NO;
    [self dropPin:nil];
  
    
}

@end