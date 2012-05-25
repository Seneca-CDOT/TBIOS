 //
//  ReverseGeocoder.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReverseGeocoder.h"
#import "NativeEarthAppDelegate_iPhone.h"
@implementation ReverseGeocoder


#pragma Mark - Reverce Geocoder Public Methds


-(NSArray *) FindNearbyNationsForCoordinateWithLat:(double)lat andLng:(double) lng{
    curLatitude =lat;
    curLongitude =lng;
       NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    NSArray * fetchedNearbyNations = [appDelegate.model getNearbyNationsForLatitude:curLatitude andLongitude:curLongitude];
       NSMutableArray * nationArray=[NSMutableArray arrayWithCapacity:[fetchedNearbyNations count]];
        for (Nation * n in  fetchedNearbyNations) {
            CLLocationDistance distance =[appDelegate.model DistanceToNation:n];
            n.Distance = [NSNumber numberWithDouble: distance];//setting the transient property 
            [nationArray addObject:n];

       }
    
        return nationArray;
}

@end
