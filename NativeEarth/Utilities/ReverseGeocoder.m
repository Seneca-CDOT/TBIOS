 //
//  ReverseGeocoder.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReverseGeocoder.h"
#import "Land.h"
#import "NativeEarthAppDelegate_iPhone.h"
#import <math.h>
#import "Utility+CLLocation.h"
@implementation ReverseGeocoder
@synthesize mapView;



#pragma Mark -
#pragma Mark Reverce Geocoder Public Methds

- (NSArray *) FindEstimatedMatchingLandsForCoordinateWithLat:(double)lat AndLng: (double) lng{
    
    curLatitude =lat;//round(lat*100000)/100000;
    curLongitude =lng;//round(lng*100000)/100000;
    
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    NSArray * fetchedEstimatedMatchingLands= [appDelegate.landGetter getEstimatedMatchingLandsForLatitude:curLatitude andLongitude:curLongitude];


    return fetchedEstimatedMatchingLands;
}

- (NSArray *) FindNearbyLandsForCoordinateWithLat:(double)lat andLng:(double) lng{
    curLatitude =lat;//=round(lat*100000)/100000;
    curLongitude =lng;//round(lng*100000)/100000;
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    NSArray * fetchedNearbyLands = [appDelegate.landGetter getNearbyLandsForLatitude:curLatitude andLongitude:curLongitude];
    NSMutableArray * dictArray=[NSMutableArray arrayWithCapacity:[fetchedNearbyLands count]];
    for (Land * l in  fetchedNearbyLands) {
        NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
        CLLocationDistance distance = [self DistanceOfPointCWithCLat:lat AndCLng:lng FromPolygonWithCoordinates:[Utility parseCoordinatesStringAsCLLocation:l.Coordinates]];
        [dict setValue:l forKey:@"Land"];
        [dict setValue:[NSNumber numberWithDouble:distance] forKey:@"Distance"];
    
        [dictArray addObject:dict];
        [dict release];
   }
    
   // return fetchedNearbyLands;
    return dictArray;
}

- (NSArray *) FindLandForCoordinateWithLat:(double)lat AndLng:(double) lng{
    
    NSArray *nearByLands =[self FindEstimatedMatchingLandsForCoordinateWithLat:lat AndLng:lng];

    NSMutableArray* lands= [[NSMutableArray alloc] init];
    
    for (Land  * land in nearByLands) {
         NSArray *coordinates = [Utility parseCoordinatesStringAsCLLocation:land.Coordinates];
       
        if([self PointWithLatitude: lat AndLongitude: lng BelongsToPolygonWithCoordinates:coordinates]){
            [lands addObject:land];   
        }
    }// end of for loop
    return lands;
}

#pragma Mark -
#pragma Mark Geometrical Helper Methods

-(BOOL)PointWithLatitude: (double) lat AndLongitude:(double) lng BelongsToPolygonWithCoordinates:(NSArray*) coordinates {
    

    
    if ([self PointWithLatitude:lat AndLongitude:lng IsAVerticeOfPolygonWithCoordinates:coordinates]) 
    return  YES;
    
    if([self PointWithLatitude:lat AndLongitude:lng IsOnASideOfMultyLineWithCoordinates:coordinates])
    return  YES;
    
    int N = [coordinates count] -1;//Number Of Vertices
    
    int counter = 0;
    int i;
    double xinters;
    CLLocation * p1,* p2;
     
    p1 = [coordinates objectAtIndex:0];
 
    for (i=1;i<=N;i++) {
        p2 = [coordinates objectAtIndex:(i % N)];
       // double l= [p1 coordinate].latitude;
        if (lat > MIN([p1 coordinate].latitude,[p2 coordinate].latitude)) {
            if (lat <= MAX([p1 coordinate].latitude,[p2 coordinate].latitude)) {
                if (lng <= MAX([p1 coordinate].longitude,[p2 coordinate].longitude)) {
                    if ([p1 coordinate].latitude!= [p2 coordinate].latitude) {
                        xinters = (lat -[p1 coordinate].latitude)*([p2 coordinate].longitude-[p1 coordinate].longitude)/([p2 coordinate].latitude-[p1 coordinate].latitude)+[p1 coordinate].longitude;
                        if ([p1 coordinate].longitude == [p2 coordinate].longitude || lng <= xinters)
                            counter++;
                    }
                }
            }
        }
        p1 = p2;
    }// end of for loop
    
    if (counter % 2 == 0)
        return NO;
    else
        return YES;
    
    
}

- (BOOL)PointWithLatitude:(double)lat AndLongitude:(double)lng IsOnASideOfMultyLineWithCoordinates:(NSArray *)coordinates{
    BOOL rv= NO;
    
    for (int i=0; i<[coordinates count]-1; i++) {
      
        CLLocation * loc  = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        CLLocation * locA = [coordinates objectAtIndex:i] ;
        CLLocation * locB = [coordinates objectAtIndex:i+1];
        
       CLLocationDistance distance = [self RevisedDistanceOfPointC:loc FromLineWithPointA:locA AndPointB:locB]; 
       //CLLocationDistance distance =[loc distanceFromPathWithStartPoint:locA andEndPoint:locB];
        
        if (distance ==0) {
            rv=YES;
        }
    }
    
    return  rv;
}

-(double)DistanceOfPointCWithCLat:(double)lat AndCLng:(double)lng FromPolygonWithCoordinates:(NSArray *)coordinates{
    
    double distance =0.0;
    
    if(![self PointWithLatitude:lat AndLongitude:lng BelongsToPolygonWithCoordinates:coordinates]){
    
        bool firstTime = YES;
        for (int i=0; i<[coordinates count]-1; i++) {
      
            CLLocation * loc  = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            CLLocation * locA = [coordinates objectAtIndex:i];
            CLLocation * locB = [coordinates objectAtIndex:i+1];
            
            CLLocationDistance dist ;
           
            dist = [self RevisedDistanceOfPointC:loc FromLineWithPointA:locA AndPointB:locB];
           // dist = [loc distanceFromPathWithStartPoint:locA andEndPoint:locB];
            if (firstTime) {
                distance=dist; 
                firstTime=NO;
            }else {
                if (dist<distance) {
                    distance=dist;
                }
            }
       
        }
    } 
    return distance;
    
}


- (BOOL)PointWithLatitude:(double)lat AndLongitude:(double)lng IsAVerticeOfPolygonWithCoordinates:(NSArray *)coordinates
{
    BOOL rv = NO;
    
    for (CLLocation * vertice in coordinates) {
        double la = [vertice coordinate].latitude;
        double ln = [vertice coordinate].longitude;
        if ( la == lat && ln== lng) {
            rv=YES;
        }
    }
    return  rv;
}

//not used:
// find the distance from the point (cx,cy) to the line
// determined by the points (ax,ay) and (bx,by)
//
-(double) DistanceOfPointCWithCLat: (double) cy AndCLng:(double) cx FromLineWithPointALat:(double) ay AndPointALng:(double) ax AndPointBLat:(double) by AndPointBLng:(double)bx{
    
    /*
     
     Subject 1.02: How do I find the distance from a point to a line?
     
     
     Let the point be C (Cx,Cy) and the line be AB (Ax,Ay) to (Bx,By).
     Let P be the point of perpendicular projection of C on AB.  The parameter
     r, which indicates P's position along AB, is computed by the dot product 
     of AC and AB divided by the square of the length of AB:
     
     (1)     AC dot AB
         r = ---------  
             ||AB||^2
     
     r has the following meaning:
     
     r=0      P = A
     r=1      P = B
     r<0      P is on the backward extension of AB
     r>1      P is on the forward extension of AB
     0<r<1    P is interior to AB
     
     The length of a line segment , AB is computed by:
  
     L = sqrt( (Bx-Ax)^2 + (By-Ay)^2 )
     
     and the dot product of two vectors , U dot V is computed:
     
     
     D = (Ux * Vx) + (Uy * Vy) 
     
     So (1) expands to:
     
     (Cx-Ax)(Bx-Ax) + (Cy-Ay)(By-Ay)
     r = -------------------------------
     L^2
     
     The point P can then be found:
     
     Px = Ax + r(Bx-Ax)
     Py = Ay + r(By-Ay)
     
     And the distance from A to P = r*L.
     
     Use another parameter s to indicate the location along PC, with the 
     following meaning:
     s<0      C is left of AB
     s>0      C is right of AB
     s=0      C is on AB
     
     Compute s as follows:
     
     (Ay-Cy)(Bx-Ax)-(Ax-Cx)(By-Ay)
     s = -----------------------------
     L^2
     
     
     Then the distance from C to P = |s|*L.
     
     */
    
    double distanceFromLine;   //distance from the point to the line (assuming infinite extent in both directions)
    double distanceFromSegment;//distance from the point to the line segment

    double r_numerator = (cx-ax)*(bx-ax) + (cy-ay)*(by-ay);
    double r_denomenator = (bx-ax)*(bx-ax) + (by-ay)*(by-ay);
    double r = r_numerator / r_denomenator;
    //
    //perpendicular coordinates
    double px = ax + r*(bx-ax);//lngp
    double py = ay + r*(by-ay);//latp
    //    
    double s =  ((ay-cy)*(bx-ax)-(ax-cx)*(by-ay) ) / r_denomenator;
    
    distanceFromLine = fabs(s)*sqrt(r_denomenator);
    
    //
    // (xx,yy) is the point on the lineSegment closest to (cx,cy)
    //
    double xx = px;
    double yy = py;
    
    if ( (r >= 0) && (r <= 1) )
    {
        distanceFromSegment = distanceFromLine;
        //fix here
    }
    else
    {
        //destance between c and a
        double dist1 = [self KilometerDistanceOfPointAWithLat:cy andLng:cx fromPointBWithLat:ay andLng:ax];//(cx-ax)*(cx-ax) + (cy-ay)*(cy-ay);
        
        //distance between c and b
        double dist2 = [self KilometerDistanceOfPointAWithLat:cy andLng:cx fromPointBWithLat:ay andLng:ax];//(cx-bx)*(cx-bx) + (cy-by)*(cy-by);
        if (dist1 < dist2)
        {
            xx = ax;
            yy = ay;
            distanceFromSegment = sqrt(dist1);
        }
        else
        {
            xx = bx;
            yy = by;
            distanceFromSegment = sqrt(dist2);
        }
        
        
    }
    
//    return [self KilometerDistanceOfPointAWithLat:cx andLng:cy fromPointBWithLat:px andLng:py];
    
    return distanceFromSegment;
}

-(double) RevisedDistanceOfPointC:(CLLocation*) C FromLineWithPointA:(CLLocation *) A AndPointB:(CLLocation*)B{
    
    /*
     
     Subject 1.02: How do I find the distance from a point to a line?
     
     
     Let the point be C (Cx,Cy) and the line be AB (Ax,Ay) to (Bx,By).
     Let P be the point of perpendicular projection of C on AB.  The parameter
     r, which indicates P's position along AB, is computed by the dot product 
     of AC and AB divided by the square of the length of AB:
     
     (1)     AB
     r = ---------  
     ||AB||^2
     
     r has the following meaning:
     
     r=0      P = A
     r=1      P = B
     r<0      P is on the backward extension of AB
     r>1      P is on the forward extension of AB
     0<r<1    P is interior to AB
     
     The length of a line segment , AB is computed by:
     
     L = sqrt( (Bx-Ax)^2 + (By-Ay)^2 )
     
     and the dot product of two vectors , U dot V is computed:
     
     
     D = (Ux * Vx) + (Uy * Vy) 
     
     So (1) expands to:
     
     (Cx-Ax)(Bx-Ax) + (Cy-Ay)(By-Ay)
     r = -------------------------------
     L^2
     
     The point P can then be found:
     
     Px = Ax + r(Bx-Ax)
     Py = Ay + r(By-Ay)
     
     And the distance from A to P = r*L.
     
     Use another parameter s to indicate the location along PC, with the 
     following meaning:
     s<0      C is left of AB
     s>0      C is right of AB
     s=0      C is on AB
     
     Compute s as follows:
     
     (Ay-Cy)(Bx-Ax)-(Ax-Cx)(By-Ay)
     s = -----------------------------
     L^2
     
     
     Then the distance from C to P = |s|*L.
     
     */
    /*
     @param xDistance - east-west distance in kilometers.
    @param yDistance - north-south distance in kilometers.
     kilometerPerDegree = 111;
     span.latitudeDelta = xDistance / kilometersPerDegree;
     span.longitudeDelta = yDistance / (kilometersPerDegree * cos(coord.latitude * M_PI / 180.0));
     */
  
    double cx = C.coordinate.longitude;
    double cy=C.coordinate.latitude;
    
    double ax=A.coordinate.longitude;
    double ay= A.coordinate.latitude;
    
    double bx=B.coordinate.longitude;
    double by=B.coordinate.latitude;

    double distanceFromSegment;//distance from the point to the line segment
    
      /*
     http://mathforum.org/library/drmath/view/51833.html
     
     if we have coordinates in lat and lond butwe want to calculate coordinate deltas in x an y :
       a            c
     (lng1,lat1) , (lng2,lat2)
       (a1,b1)    , (a2,b2)
       
      y = R*(b2-b1)*pi/180
     deltaY or delta lat = R*(lat2-lat1)*pi/180
       
    x  = R*(a2-a1)*(pi/180)*cos(b1)
     deltaX or deltaLng= R*(lnf2-lng1)*(pi/180)*cos(lat1)
     */
    
    //using linear algorythm to decide where the perpendicular point stands
 //   double r_numerator = (cx-ax)*(bx-ax) + (cy-ay)*(by-ay);
    
   // double r_denomenator = (bx-ax)*(bx-ax) + (by-ay)*(by-ay);
    
// converting above formulas to use lat and lng:
    
double r_numerator=(ERM*DEG_TO_RAD(cx-ax)*cos(ay))*(ERM*DEG_TO_RAD(bx-ax)*cos(ay))+(ERM*DEG_TO_RAD(cy-ay))*(ERM*DEG_TO_RAD(by-ay));
    double r_denomenator= [A distanceFromLocation:B]*[A distanceFromLocation:B];
    
    
    double r = r_numerator / r_denomenator;

    
    if ( (r >= 0) && (r <= 1) )
    {
      distanceFromSegment = [C distanceFromPathWithStartPoint:A andEndPoint:B];
    }
    else
    {
        //destance between c and a
        double dist1 = [self KilometerDistanceOfPointAWithLat:cy andLng:cx fromPointBWithLat:ay andLng:ax];
        
        //distance between c and b
        double dist2 = [self KilometerDistanceOfPointAWithLat:cy andLng:cx fromPointBWithLat:by andLng:bx];
        if (dist1 < dist2)
        {
            distanceFromSegment = dist1;
        }
        else
        {
            distanceFromSegment =dist2;
        }
    }
    
    return distanceFromSegment;
}


-(double)KilometerDistanceOfPointAWithLat:(double)latA andLng:(double) lngA fromPointBWithLat:(double)latB andLng:(double)lngB{
    CLLocationCoordinate2D pointACoordinate = CLLocationCoordinate2DMake(latA, lngA);
    CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:pointACoordinate.latitude longitude:pointACoordinate.longitude];  
    
    CLLocationCoordinate2D pointBCoordinate = CLLocationCoordinate2DMake(latB, lngB);
    CLLocation *pointBLocation = [[CLLocation alloc] initWithLatitude:pointBCoordinate.latitude longitude:pointBCoordinate.longitude];  
    
    CLLocationDistance distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
    
    [pointALocation release];
    [pointBLocation release];
    return distanceMeters/1000;
}


@end
