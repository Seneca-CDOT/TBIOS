//
//  ReverseGeocoder.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReverseGeocoder.h"


@implementation ReverseGeocoder

#pragma Mark -
#pragma Mark Properties 
@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

#pragma Mark -
#pragma Mark Reverce Geocoder Public Methds

- (NSArray *) findNearByLandsForPointWithLat:(double)lat AndLng: (double) lng{
    
    curLatitude =round(lat*100000)/100000;
    curLongitude =round(lng*100000)/100000;
    NSError *error;
    if(![[self fetchedResultsController]performFetch:&error]){
    //handle Error
    }
    
    NSArray * fetchedNearByLands = [self.fetchedResultsController fetchedObjects];
    return fetchedNearByLands;
}

- (NSArray *) findLandForCoordinateWithLat:(double)lat AndLng:(double) lng{
    
    NSArray *nearByLands =[self findNearByLandsForPointWithLat:lat AndLng:lng];
    if ([nearByLands count]>0) {
    
    
    }
    NSMutableArray* lands= [[NSMutableArray alloc] init];
    
    for (NSManagedObject * land in nearByLands) {
         NSArray *coordinates = [Utility parseCoordinatesStringAsCLLocation:[[land valueForKey:@"Coordinates"]description]];
        if([self PointWithLatitute: lat AndLongitute: lng BelongsToPolygonWithCoordinates:coordinates]){
            [lands addObject:land];   
        }
    }// end of for loop
    return lands;
}

#pragma Mark -
#pragma Mark Geometrical Helper Methods

-(BOOL)PointWithLatitute: (double) lat AndLongitute:(double) lng BelongsToPolygonWithCoordinates:(NSArray*) coordinates {
    
    if ([self PointWithLatitute:lat AndLongitute:lng IsAVerticeOfPolygonWithCoordinates:coordinates]) {
        return  YES;
    }else if([self PointWithLatitute:lat AndLongitute:lng IsOnASideOfMultyLineWithCoordinates:coordinates]){
        return  YES;
    }else{
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
    
}

- (BOOL)PointWithLatitute:(double)lat AndLongitute:(double)lng IsOnASideOfMultyLineWithCoordinates:(NSArray *)coordinates{
    BOOL rv= NO;
    
    for (int i=0; i<[coordinates count]-1; i++) {
        double ax= [[coordinates objectAtIndex:i] coordinate].longitude;
        double ay=[[coordinates objectAtIndex:i] coordinate].latitude;
        double bx=[[coordinates objectAtIndex:i+1] coordinate].longitude;
        double by=[[coordinates objectAtIndex:i+1] coordinate].latitude;
        double distance = [self DistanceOfPointCWithCLat:lat AndCLng:lng FromLineWithPointALat:ay AndPointALng:ax AndPointBLat:by  AndPointBLng:bx];
        
        if (distance <= 0.0002) {
            rv=YES;
        }
    }
    
    return  rv;
}





- (BOOL)PointWithLatitute:(double)lat AndLongitute:(double)lng IsAVerticeOfPolygonWithCoordinates:(NSArray *)coordinates
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
     
     The length of a line segment in d dimensions, AB is computed by:
     
     L = sqrt( (Bx-Ax)^2 + (By-Ay)^2 + ... + (Bd-Ad)^2)
     
     so in 2D:  
     
     L = sqrt( (Bx-Ax)^2 + (By-Ay)^2 )
     
     and the dot product of two vectors in d dimensions, U dot V is computed:
     
     D = (Ux * Vx) + (Uy * Vy) + ... + (Ud * Vd)
     
     so in 2D:  
     
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
    double px = ax + r*(bx-ax);
    double py = ay + r*(by-ay);
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
    }
    else
    {
        
        double dist1 = (cx-ax)*(cx-ax) + (cy-ay)*(cy-ay);
        double dist2 = (cx-bx)*(cx-bx) + (cy-by)*(cy-by);
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
    
    return distanceFromSegment;
}

#pragma Mark -
#pragma Mark fetchedResultsController delegate method
-(NSFetchedResultsController *) fetchedResultsController {
    if(fetchedResultsController_ !=nil){
        return  fetchedResultsController_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Land" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"LandName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    // set predicate
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(North>= %lf) AND (South <= %lf) AND (East >= %lf) AND (West <= %lf)",curLatitude,curLatitude,curLongitude,curLongitude];
    [fetchedRequest setPredicate:predicate];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"Land"];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Land"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return fetchedResultsController_;
}



@end
