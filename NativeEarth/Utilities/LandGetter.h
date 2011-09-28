//
//  LocalLandGetter.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Land.h"
#import "LandShort.h"
#import "Reachability.h"
#import "NetworkDataGetter.h"
#import "PlannedVisit.h"
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
    NSFetchedResultsController * fetchedResultsControllerLand_;
    NSFetchedResultsController * fetchedResultsControllerShortLands_;
    NSFetchedResultsController * fetchedResultsControllerLandsForCoordinate_;
    NSFetchedResultsController * fetchedResultsControllerPlannedVisits_;
    NSManagedObjectContext * managedObjectContext_;
    int landID;
    int toBeUpdatedLandID;
    BOOL landIDUpdateFlag;
}
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerLand;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerShortLands;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerLandsForCoordinate;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerPlannedVisits;
@property (nonatomic, retain) NSMutableArray* landShortList;
//Network Conectivity
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus wifiConnectionStatus;
@property NetworkStatus remoteHostStatus;

- (void) updateStatusesWithReachability: (Reachability*) curReach;
-(id) initWithManagedObjectContext:(NSManagedObjectContext* ) context;
-(Land *)GetLandWithLandId:(int)landId;
-(Land *)GetLandLocallyWithLandId:(int)landId;
-(void) GetLandShortsFromWebService;
-(NSDictionary *)GetLandShortsDictionary;
-(void) GetLandFromWebServiceWithLandId:(NSNumber *)landId;
-(void)CheckForLandUpdatesByLandId:(NSNumber *)landId;
-(NSMutableArray *)GetLandShortArray;
-(NSArray*)getNearbyLandsForLatitute:(double)lat andLongitute:(double)lng;
-(void) setLandToBeUpdatedById:(int)landId;
-(NSArray *)GetAllPlannedVisits;
//-(void) updateList;
@end
