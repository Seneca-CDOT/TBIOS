//
//  Utility+CLLocation.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-11-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utility+CLLocation.h"

#define  ERM  6378137 //earth radious in m 
#define RAD_TO_DEG(r) ((r) * (180 / M_PI))
#define DEG_TO_RAD(d) (((d) * M_PI)/180)

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
   
    CLLocationDegrees lat1 = DEG_TO_RAD(self.coordinate.latitude);
    CLLocationDegrees lng1 = DEG_TO_RAD(self.coordinate.longitude);
    CLLocationDegrees lat2 = DEG_TO_RAD(location.coordinate.latitude);
    CLLocationDegrees lng2 = DEG_TO_RAD(location.coordinate.longitude);
    
    CLLocationDegrees deltaLong = lng2 - lng1;
    
    CLLocationDegrees yComponent = sin(deltaLong) * cos(lat2);
    CLLocationDegrees xComponent = (cos(lat1) * sin(lat2)) - (sin(lat1) * cos(lat2) * cos(deltaLong));
    CLLocationDegrees brng = atan2(yComponent, xComponent);
    
    CLLocationDegrees degrees = RAD_TO_DEG(brng) + 360;
    
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
    double ER = ERM/1000;
    distance = distance/ER;
    direction = DEG_TO_RAD(direction);
    
    CLLocationDegrees lat1= DEG_TO_RAD( self.coordinate.latitude);
    CLLocationDegrees lng1= DEG_TO_RAD (self.coordinate.longitude);
    
    CLLocationDegrees lat2= asin(sin(lat1)* cos(distance/ER) + cos(lat1)* sin(distance/ER)*cos(direction));
    CLLocationDegrees lng2 = lng1+ atan2(sin(direction)*sin(distance/ER)*cos(lat1), cos(distance/ER)-sin(lat1)*sin(lat2));
    lng2 = fmod((lng2+3*M_PI), (2*M_PI))-M_PI;
    CLLocation * destination = [[CLLocation alloc] initWithLatitude:RAD_TO_DEG(lat2) longitude:RAD_TO_DEG(lng2)];
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
    double ER = ERM/1000;
    
    CLLocationDistance  distanceFromStartPoint = [startPoint distanceFromLocation:self]/1000; //d13
    CLLocationDirection directionFromStartPoint = [startPoint directionToLocation:self];//θ13
    CLLocationDirection directionFromStartToEnd = [startPoint directionToLocation:endPoint];//θ12
    
    return  fabs(asin(sin(distanceFromStartPoint/ER)*sin(directionFromStartPoint-directionFromStartToEnd))*ER);
    
    
}

@end
