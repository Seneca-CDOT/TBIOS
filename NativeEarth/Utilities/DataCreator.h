//
//  DataCreator.h
//  TheNativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Utility.h"
#import "KMLParser.h"
#import "NetworkDataGetter.h"

@interface DataCreator : NSObject <NetworkDataGetterDelegate>{
    KMLParser *kml;
    NSManagedObjectContext * managedObjectContext;
}
-(id) initWithContext:(NSManagedObjectContext*) context;
-(void) createDataFromKML;
-(void) createDataFromWebServive;
@end
