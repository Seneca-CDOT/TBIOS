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
    
    NSFetchedResultsController * fetchedResultsControllerLand_;
    NSFetchedResultsController * fetchedResultsControllerShortLands_;
    NSManagedObjectContext * managedObjectContext_;
    int landID;
}
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerLand;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsControllerShortLands;
@property (nonatomic, copy) NSMutableArray* landShortList;
//Network Conectivity
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus wifiConnectionStatus;
@property NetworkStatus remoteHostStatus;

- (void) updateStatusesWithReachability: (Reachability*) curReach;
-(id) initWithManagedObjectContext:(NSManagedObjectContext* ) context;
-(Land *)GetLandWithLandID:(int)landId;
-(Land *)GetLandLocallyWithLandID:(int)landId;
-(void) GetLandShortsFromWebService;
-(NSDictionary *)GetLandShortsDictionary;
-(void) GetLandFromWebServiceWithLandID:(NSNumber *)landId;
-(void)CheckForLandUpdatesByLandID:(NSNumber *)landId;
@end
