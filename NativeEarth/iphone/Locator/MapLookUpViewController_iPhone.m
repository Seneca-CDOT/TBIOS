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
     ReverseGeocoder *rgeocoder = [[ReverseGeocoder alloc] init];
    rgeocoder.managedObjectContext= self.managedObjectContext;
    landArray= [rgeocoder findLandForCoordinateWithLat:annotation.coordinate.latitude AndLng:annotation.coordinate.longitude];
        
        
        if ([landArray count]>0) {
            annotation.title = NSLocalizedString(@"Select",@"Select");
            annotation.subtitle = nil;
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
        
            annotationView.rightCalloutAccessoryView = rightButton;

        }else{
            annotation.title = @"Drag to Move Pin";
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
    }
    draggablePinView.annotation = annotation;
    draggablePinView.draggable = YES;
    draggablePinView.canShowCallout = YES;
    if ([landArray count]>0) {
        ((DDAnnotation*) annotation).title = NSLocalizedString(@"Select",@"Select");
        ((DDAnnotation*) annotation).subtitle = nil;
            draggablePinView.rightCalloutAccessoryView = rightButton;
    }else{
        ((DDAnnotation*) annotation).title = @"Drag to Move Pin";
        ((DDAnnotation*) annotation).subtitle = NSLocalizedString(@"No First Nation Found", @"No First Nation Found");
    }


	return draggablePinView;
}


-(IBAction)dropPin:(id) sender{
    if (!pinIsDropped) {
    CLLocationCoordinate2D theCoordinate =self.mapView.centerCoordinate;
        
	DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
        pinLatitude= annotation.coordinate.latitude;
        pinLongitude= annotation.coordinate.longitude;
        
         
	//annotation.title = @"Drag to Move Pin";
    //annotation.subtitle = NSLocalizedString(@"No First Nation Found", @"No First Nation Found");// [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	
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
    
    if ([landArray count]>1) {
        
    
    LandSelectViewController_iPhone *nextVC = [[LandSelectViewController_iPhone alloc]initWithStyle:UITableViewStyleGrouped];
    
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.managedObjectContext = self.managedObjectContext;
    
    nextVC.landArray=landArray;//lands;
    nextVC.title= NSLocalizedString(@"Select a Land", @"Select a Land");
    
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
    }else if ([landArray count]==1){
        LocationInfoViewController_iPhone * nextVC = [[LocationInfoViewController_iPhone alloc]init];
        nextVC.remoteHostStatus = self.remoteHostStatus;
        nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
        nextVC.internetConnectionStatus = self.internetConnectionStatus;
        nextVC.managedObjectContext = self.managedObjectContext;
        nextVC.selectedLand = [landArray objectAtIndex:0];
        nextVC.allLands=landArray;
        [self.navigationController pushViewController:nextVC animated:YES];
        [nextVC release];
    }
    
}

#pragma  mark - NetworkDataGetter Delegate

-(void)DataUpdate:(id)object{

    LandSelectViewController_iPhone *nextVC = [[LandSelectViewController_iPhone alloc]initWithStyle:UITableViewStyleGrouped];
    
    nextVC.remoteHostStatus = self.remoteHostStatus;
    nextVC.wifiConnectionStatus = self.wifiConnectionStatus;
    nextVC.internetConnectionStatus = self.internetConnectionStatus;
    nextVC.managedObjectContext = self.managedObjectContext;
    
    nextVC.landArray=[self GetWSLandsFromDictArray:(NSArray *)object];//lands;
    nextVC.title= NSLocalizedString(@"Select", @"Select");
    
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];


}
-(void)DataError:(NSError *)error{
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"%@", [error description]);
}

-(void) GetFirstNationLandFromWebServiceWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees) longitude {
//get Land By latitude and longitude an language from web service
    
    NSString *url = @"http://localhost/~ladan/AlgonquinOverLap";
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
    
}

#pragma  mark - converter
-(NSArray *)GetWSLandsFromDictArray:(NSArray *) dictArray{
    
    NSMutableArray * wSLands = [[NSMutableArray alloc]init];
    for (NSDictionary* dict in dictArray) {
        [wSLands addObject:[self GetWSLandForDict:dict]];
    }
    return wSLands;
}

-(WSLand *)GetWSLandForDict:(NSDictionary *)dict{
    return  [[WSLand alloc] initWithDictionary:dict];
}
@end