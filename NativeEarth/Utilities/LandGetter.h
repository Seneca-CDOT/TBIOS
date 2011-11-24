//
//  LocalLandGetter.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Land.h"
#import "WSLand.h"
#import "LandShort.h"
#import "Reachability.h"
#import "NetworkDataGetter.h"
#import "PlannedVisit.h"
#import "Map.h"
#import <MapKit/MapKit.h>

@interface LandGetter : NSObject <NSFetchedResultsControllerDelegate,NetworkDataGetterDelegate>{

    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    NetworkStatus internetConnectionStatus;
    NetworkStatus wifiConnectionStatus;
    NetworkStatus remoteHostStatus;
    
    NSMutableArray *  addArray ;
    NSMutableArray *  deleteArray ;
    NSMutableArray *  updateArray ;
    
    BOOL updateCheckStarted;
    BOOL updateCheckFinished;
    double latitude;
    double longitude;
    double Radious;
    NSFetchedResultsController * fetchedResultsControllerLand_;
    NSFetchedResultsController * fetchedResultsControllerShortLands_;
    NSFetchedResultsController * fetchedResultsControllerLandsForCoordinate_;
    NSFetchedResultsController * fetchedResultsControllerNearByLands_;
    NSFetchedResultsController * fetchedResultsControllerPlannedVisits_;
    NSManagedObjectContext * managedObjectContext_;
    int landID;
    int toBeUpdatedLandID;
    BOOL landIDUpdateFlag;
    double searchDistanceKM;
   
}
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerLand;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerShortLands;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerLandsForCoordinate;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerNearByLands;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerPlannedVisits;
@property (nonatomic, retain) NSMutableArray* landShortList;
//Network Conectivity
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus wifiConnectionStatus;
@property NetworkStatus remoteHostStatus;

-(void) updateStatusesWithReachability: (Reachability*) curReach;
-(id) initWithManagedObjectContext:(NSManagedObjectContext* ) context;
-(Land *)getLandWithLandId:(int)landId;
-(Land *)getLandLocallyWithLandId:(int)landId;
-(void) getLandShortsFromWebService;
-(NSDictionary *)getLandShortsDictionary;
-(void) getLandFromWebServiceWithLandId:(NSNumber *)landId;
-(void) checkForLandUpdatesByLandId:(NSNumber *)landId;
-(NSMutableArray *)getLandShortArray;
-(NSArray*)getEstimatedMatchingLandsForLatitude:(double)lat andLongitude:(double)lng;
-(NSArray*)getNearbyLandsForLatitude:(double)lat andLongitude:(double)lng;
-(void) setLandToBeUpdatedById:(int)landId;
-(NSArray *)getAllPlannedVisits;
-(void) updateManagedLand: (Land*) mLand WithWSLand:(WSLand *)webLand;
-(NSError *)SaveData;
-(PlannedVisit *)getNewPlannedVisit;
-(Map *)getNewMap;
@end
