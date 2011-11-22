//
//  Utility+CLLocation.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utility+CLLocation.h"

#define  ER  6371 // km
#define RAD_TO_DEG(r) ((r) * (180 / M_PI))

@implementation CLLocation (Utility)
//http://forrst.com/posts/Direction_between_2_CLLocations-uAo
//http://www.movable-type.co.uk/scripts/latlong.html

- (CLLocationDirection)directionToLocation:(CLLocation *)location { 
    //bearing
    /*
     Formula:	θ =	atan2(	sin(Δlong).cos(lat2),
     cos(lat1).sin(lat2) − sin(lat1).cos(lat2).cos(Δlong) )
     
     JavaScript:	
     var y = Math.sin(dLon) * Math.cos(lat2);
     var x = Math.cos(lat1)*Math.sin(lat2) -
     Math.sin(lat1)*Math.cos(lat2)*Math.cos(dLon);
     var brng = Math.atan2(y, x).toDeg();
     */
    CLLocationCoordinate2D coord1 = self.coordinate;
    CLLocationCoordinate2D coord2 = location.coordinate;
    
    CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
    CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
    CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));
    
    CLLocationDegrees radians = atan2(yComponent, xComponent);
    CLLocationDegrees degrees = RAD_TO_DEG(radians) + 360;
    
    return fmod(degrees, 360);
}

- (CLLocation *) destinationWithDistance:(CLLocationDistance) distance andDirection:(CLLocationDirection) direction{
    /*
     Formula:
     
     lat2 = asin(sin(lat1)*cos(d/R) + cos(lat1)*sin(d/R)*cos(θ))
     lon2 = lon1 + atan2(sin(θ)*sin(d/R)*cos(lat1), cos(d/R)−sin(lat1)*sin(lat2))
     θ is the bearing (in radians, clockwise from north);
     d/R is the angular distance (in radians), where d is the distance travelled and R is the earth’s radius
     */
    
    CLLocationDegrees lat2= asin(sin(self.coordinate.latitude)* cos(distance/ER) + cos(self.coordinate.latitude)* sin(distance/ER)*cos(direction));
    CLLocationDegrees lng2 = self.coordinate.longitude + atan2(sin(direction)*sin(distance/ER)*cos(self.coordinate.latitude), cos(distance/ER)-sin(self.coordinate.latitude)*sin(lat2));
    CLLocation * destination = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    return destination;
}

- (CLLocationDistance)distanceFromPathWithStartPoint:(CLLocation *)startPoint andEndPoint :(CLLocation*)endPoint{
    /*
     Formula:	dxt = asin(sin(d13/R)*sin(θ13−θ12)) * R
    where	 d13 is distance from start point to third point
    θ13 is (initial) bearing from start point to third point
    θ12 is (initial) bearing from start point to end point
    R is the earth’s radius
     
    JavaScript:	
    var dXt = Math.asin(Math.sin(d13/R)*Math.sin(brng13-brng12)) * R;
     */

//My test:
    
   // CLLocationDistance shortestdistance ;
    
//  CLLocationDistance pathLength= [startPoint distanceFromLocation:endPoint]/1000;
//    CLLocationDistance distToEnd =[self distanceFromLocation:endPoint]/1000;
//    CLLocationDistance distToStart = [self distanceFromLocation:startPoint]/1000;
//    CLLocationDirection directionToEndPoint = [self directionToLocation:endPoint];
//    CLLocationDirection directionToStartPoint = [self directionToLocation:startPoint];
//   CLLocationDirection directionFromStartToEnd = [startPoint directionToLocation:endPoint];
//    
//    
//    if (directionToStartPoint-directionToEndPoint ==0) {//on one line and out side segment
//        
//        if (distToStart<distToEnd) {
//            shortestdistance= distToStart;
//        }else{
//            shortestdistance= distToEnd;
//        }
//    } else if( directionToEndPoint-directionToStartPoint == 180){// on one line and inside segment
//        shortestdistance = 0.0;
//    } else {
    
//     shortestdistance= fabs(asin(sin(distToStart/ER)*sin(directionToStartPoint-directionFromStartToEnd))*ER);
//    }
//    
    
    
    CLLocationDistance distanceToStartPoint = [self distanceFromLocation:startPoint]/1000; //d13
    CLLocationDirection directionToStartPoint = [self directionToLocation:startPoint];//013
    CLLocationDirection directionFromStartToEnd = [startPoint directionToLocation:endPoint];//012
    
    return  fabs(asin(sin(distanceToStartPoint/ER)*sin(directionToStartPoint-directionFromStartToEnd))*ER);
    
    
}

@end
