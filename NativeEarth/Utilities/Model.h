//
//  LocalLandGetter.h
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Land.h"
#import "Nation.h"
#import "WSNation.h"
#import "ShortNation.h"
#import "WSLand.h"
#import "WSGreeting.h"
#import "Greeting.h"
#import "Reachability.h"
#import "NetworkDataGetter.h"
#import "PlannedVisit.h"
#import "Map.h"
#import <MapKit/MapKit.h>

@interface Model : NSObject <NSFetchedResultsControllerDelegate,NetworkDataGetterDelegate>{

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
    
    NSFetchedResultsController *frcNation_;
    NSFetchedResultsController * frcShortNations_;
    NSFetchedResultsController * frcNearByNations_;
    NSFetchedResultsController *frcGreeting_;
   //NSFetchedResultsController * frcLandsForCoordinate_;
   //NSFetchedResultsController * frcNearByLands_;
    NSFetchedResultsController * frcPlannedVisits_;
    NSManagedObjectContext * __managedObjectContext;
 
    int nationNumber;
    int greetingId;
    Nation *referringNation;
    int toBeUpdatedNationNumber;
    BOOL nationNumberUpdateFlag;
    double searchDistanceKM;
   
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSFetchedResultsController * frcNation;
@property (nonatomic, retain) NSFetchedResultsController * frcShortNations;
@property (nonatomic, retain) NSFetchedResultsController * frcNearByNations;
@property (nonatomic, retain) NSFetchedResultsController *frcGreeting;


@property (nonatomic, retain) NSFetchedResultsController * frcPlannedVisits;
@property (nonatomic, retain) NSMutableArray* shortNationList;
//Network Conectivity
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus wifiConnectionStatus;
@property NetworkStatus remoteHostStatus;

-(void) updateStatusesWithReachability: (Reachability*) curReach;
-(Nation *)getNationWithNationNumber:(int)number;
-(Nation *)getNationLocallyWithNationNumber:(int)number;
-(void) getShortNationsFromWebService;
-(NSDictionary *)getShortNationsDictionary;
-(void) getNationFromWebServiceWithNationNumber:(NSNumber *)number;
-(void) checkForNationUpdatesByNationNumber:(NSNumber *)number;
-(NSMutableArray *)getShortNationArray;

- (NSArray*)getNearbyNationsForLatitude:(double)lat andLongitude:(double)lng;
-(void) setNationToBeUpdatedByNationNumber:(int)number;
-(NSArray *)getAllPlannedVisits;
-(void) updateManagedNation: (Nation *) mNation WithWNation:(WSNation *)wsNation;
-(void)updateManagedLand:(Land*) mLand withLand:(WSLand*)wsLand;
-(NSError *)SaveData;
-(NSError*)DeleteVisit:(PlannedVisit*) visit;
-(void)removeCanceledVisit:(PlannedVisit*) visit;
-(PlannedVisit *)getNewPlannedVisit;
-(Greeting *)getGreetingWithGreetingId:(int)gId;
-(Map *)getNewMap;
- (NSURL *)applicationDocumentsDirectory;
-(CLLocationDistance )DistanceToNation:(Nation*) nation;
@end
