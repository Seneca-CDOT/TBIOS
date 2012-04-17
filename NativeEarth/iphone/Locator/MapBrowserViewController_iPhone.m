//
//  MapBrowserViewController_iPhone.m
//  TheFirstNation
//
//  Created by Ladan Zahir on 11-05-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapBrowserViewController_iPhone.h"
#import "ReverseGeocoder.h"
#import "ShortNation.h"
#import "UIImage+Resizing.h"
#import "DistrictCenterAnnotation.h"
#import "DistrictCenterAnnotationView.h"
#import "CalloutMapAnnotationView.h"
#import "Map.h"
#import "MKMapView+ZoomLevel.h"
#import "NativeEarthAppDelegate_iPhone.h"
#import "Toast+UIView.h"
#import <QuartzCore/QuartzCore.h>
#import "KMLParser.h"
@interface OverlayGroup : NSObject {
    UIColor* color;
    NSMutableArray* polygons;
}
@property (nonatomic,retain ) NSMutableArray * polygons;
@property (nonatomic,retain )  UIColor* color;
-(UIColor *)getRandomColor;
@end

@implementation OverlayGroup
@synthesize polygons;
@synthesize color;
-(id) init{
    [super init];
    self.color = [self getRandomColor];
     return self;
}
-(UIColor *)getRandomColor{
    float r = rand() % 360; 
    return [UIColor colorWithHue:(r)/360 saturation:0.5f brightness:0.8f alpha:0.5f];
}
@end
@implementation MapBrowserViewController_iPhone

@synthesize     mapView;
@synthesize     nations;
@synthesize     originLocation;
@synthesize     selectedAnnotationView = _selectedAnnotationView;
@synthesize     calloutAnnotation = _calloutAnnotation;
@synthesize originAnnotationTitle, selectedNationName,showOrigin;
@synthesize referringLand;
@synthesize isBrowsingNation;
@synthesize  overlayFillColor;
@synthesize referringNation;

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
    [self.nations release];
    [self.referringNation release];
    [self.referringLand release];
    [self.calloutAnnotation release];
    [self.selectedAnnotationView release];
    [self.originAnnotationTitle release];
    [self.selectedNationName release];
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
    
    [self drawOverlaysOfArray:nations];
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

-(void)drawOverlaysOfArray:(NSArray*)nationsArray{
    //clear the map first
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
   overlayGroups =[[NSMutableArray alloc]initWithCapacity:[nationsArray count]]; 
 if (self.isBrowsingNation) {
    if(nationsArray !=nil ){
        NSMutableArray *annotations =[[NSMutableArray alloc]init];
        for (Nation * nation in nationsArray) {
            //start the group
            OverlayGroup* group = [[OverlayGroup alloc] init];
             group.polygons =[[NSMutableArray alloc]init];
            NSArray * lands = [nation.Lands allObjects];
            for (Land * land in lands) {
                
                NSData * kmlData = [land.Kml dataUsingEncoding: NSUTF8StringEncoding];
                KMLParser * kml = [KMLParser parseKMLWithData:kmlData];    
                NSArray * overlays = [kml overlays];
                //put the overlays of a nation in one group
                [group.polygons addObjectsFromArray:overlays];
                
               //[mapView addOverlays:overlays]; 
            }//end on inner for loop
            //add group to groups
            if ([group.polygons count]>0) {
                [overlayGroups addObject:group]; 
            }
            [group release];
            //annotation:
            DistrictCenterAnnotation * annotation = [[[DistrictCenterAnnotation alloc]initWithLatitude:[nation.CenterLat doubleValue] andLongitude:[nation.CenterLong doubleValue]]autorelease];
            annotation.title = nation.OfficialName;
            [annotations addObject:annotation];      
        }//end of outer for loop
        for (OverlayGroup * og  in overlayGroups) {
            [mapView addOverlays:og.polygons];
        }
        
        [mapView addAnnotations:annotations];
        //Add Annotation for originLocation: 
        if (showOrigin==YES) {
        DistrictCenterAnnotation * originAnnotation = [[[DistrictCenterAnnotation alloc]initWithLatitude:originLocation.latitude andLongitude:originLocation.longitude] autorelease];
        originAnnotation.title = self.originAnnotationTitle;
        [mapView addAnnotation:originAnnotation]; 
        }
        for (DistrictCenterAnnotation * annot in mapView.annotations) {       
            if (annot.title == self.originAnnotationTitle || annot.title== self.selectedNationName) {
                [mapView selectAnnotation:annot animated:FALSE];
            }
        }
    [self flyToPin:nil];
    }else{
        NSMutableArray *annotations =[[NSMutableArray alloc]init];
        
            //start the group
            OverlayGroup* group = [[OverlayGroup alloc] init];
            group.polygons =[[NSMutableArray alloc]init];
            NSArray * lands = [self.referringNation.Lands allObjects];
            for (Land * land in lands) {
                
                NSData * kmlData = [land.Kml dataUsingEncoding: NSUTF8StringEncoding];
                KMLParser * kml = [KMLParser parseKMLWithData:kmlData];    
                NSArray * overlays = [kml overlays];
                //put the overlays of a nation in one group
                [group.polygons addObjectsFromArray:overlays];
                
                //[mapView addOverlays:overlays]; 
            }//end on inner for loop
            //add group to groups
            if ([group.polygons count]>0) {
                [overlayGroups addObject:group]; 
            }
            [group release];
            //annotation:
            DistrictCenterAnnotation * annotation = [[[DistrictCenterAnnotation alloc]initWithLatitude:[self.referringNation.CenterLat doubleValue] andLongitude:[self.referringNation.CenterLong doubleValue]]autorelease];
            annotation.title = self.referringNation.OfficialName;
            [annotations addObject:annotation];      
      
        for (OverlayGroup * og  in overlayGroups) {
            [mapView addOverlays:og.polygons];
        }
        
        [mapView addAnnotations:annotations];
        //Add Annotation for originLocation: 
        if (showOrigin==YES) {
            DistrictCenterAnnotation * originAnnotation = [[[DistrictCenterAnnotation alloc]initWithLatitude:originLocation.latitude andLongitude:originLocation.longitude] autorelease];
            originAnnotation.title = self.originAnnotationTitle;
            [mapView addAnnotation:originAnnotation]; 
        }
        for (DistrictCenterAnnotation * annot in mapView.annotations) {       
            if (annot.title == self.originAnnotationTitle || annot.title== self.selectedNationName) {
                [mapView selectAnnotation:annot animated:FALSE];
            }
        }
        [self flyToPin:nil];
 
    }
 }else{
         NSData * kmlData = [referringLand.Kml dataUsingEncoding: NSUTF8StringEncoding];
        KMLParser * kml = [KMLParser parseKMLWithData:kmlData];    
        NSArray * overlays = [kml overlays];
        OverlayGroup * group = [[OverlayGroup alloc]init];
        group.polygons =[NSMutableArray arrayWithArray:overlays];
        [overlayGroups addObject:group];
        [mapView addOverlays:overlays];
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
    if ([mapView.overlays count]==0 && [mapView.annotations count]==1) {
        DistrictCenterAnnotation* annot = [mapView.annotations objectAtIndex:0];
        [mapView setCenterCoordinate:annot.coordinate zoomLevel:8 animated:YES];
    }else{
    
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(flyTo);
        MKCoordinateRegion savedRegion = [mapView regionThatFits:region];
        [self.mapView setRegion:savedRegion animated:YES];
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
        view.strokeColor =[[UIColor redColor] colorWithAlphaComponent:0.3];
     
        for (OverlayGroup * ogroup in overlayGroups) {
            if ([ogroup.polygons containsObject:overlay]) {
                view.fillColor = ogroup.color;
            } 
        }    
        
        
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

#pragma mark - screenshot
-(IBAction)takeScreenShot :(id) sender{
    UIImage * image = [self GetMapviewImage];//[self screenshot];
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    Map * map =[appDelegate.model getNewMap];
    map.Image= image;
    CGSize thumbSize = CGSizeMake(image.size.width/3, image.size.height/3);
    map.Thumb=[image scaleToSize:thumbSize];
    [referringNation addMapsObject:map];
   // [appDelegate.model SaveData];
    NSError *error;
    if (error=[appDelegate.model SaveData])
    {
        NSLog(@"%@",[error description]);
    }
    
  [self.view makeToast:NSLocalizedString(@"        Map image is saved.         ", @"        Map image is saved.         ")                 duration:2.0  position:@"bottom"];
}

///not used:
-(UIImage*) screenshot{//http://developer.apple.com/library/ios/#qa/qa1703/_index.html
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) 
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  (-[window bounds].size.height * [[window layer] anchorPoint].y)-10);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        } 
        //Crop image:
    // Create rect for image
  
    }
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
     //////Crop it:
     CGRect rect = CGRectMake(0, 0,image.size.width , image.size.height -110);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, CGRectMake(0,0, image.size.width, image.size.height));

    
    // Translate to compensate for the different positions of the image
  CGContextTranslateCTM(ctx, -((image.size.width*0.5)-(rect.size.width*0.5)),
                         (image.size.height*0.5)-(rect.size.height*0.5));
    
    // Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
    CGContextTranslateCTM(ctx, 0.0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    // Draw view into context
    CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height),image.CGImage);
    
    // Create the new UIImage from the context
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the drawing
    UIGraphicsEndImageContext();
    
    return image;
}
//this one is currently used
-(UIImage *)GetMapviewImage{
    UIGraphicsBeginImageContext(self.mapView.bounds.size);
    [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    return mapImage;
}
@end