 //
//  Model.m
//  NativeEarth
//

//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "Utility+CLLocation.h"

#define kSearchDistance 5 //km
#define kSearchExpantionParameter 2 //km
#define kSearchDistanceLimit 20 //km
#define kSearchCountLimit 6


NSInteger firstNumSort(id str1, id str2, void *context) {
    int num1 = [str1 integerValue];
    int num2 = [str2 integerValue];
    
    if (num1 < num2)
        return NSOrderedAscending;
    else if (num1 > num2)
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

@implementation Model
@synthesize frcNation=frcNation_,
frcNearByNations=frcNearByNations_,
frcShortNations=frcShortNations_, 
//frcLandsForCoordinate=frcLandsForCoordinate_,
frcPlannedVisits= frcPlannedVisits_,
//frcNearByLands=frcNearByLands_,
managedObjectContext=managedObjectContext_;


@synthesize internetConnectionStatus;
@synthesize wifiConnectionStatus;
@synthesize remoteHostStatus;
@synthesize shortNationList;

-(id) initWithManagedObjectContext:(NSManagedObjectContext* ) context{
    [super init];
    self.managedObjectContext = context;
    
    // Override point for customization after application launch.
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    self.shortNationList = [[NSMutableArray arrayWithArray:[self getShortNationArray] ] retain];
    NSLog(@"initial nation list:\n");
    NSLog(@"%@",[self.shortNationList description]);
    
    hostReach = [[Reachability reachabilityWithHostName: kHostName] retain];
    [hostReach startNotifier];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
    
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];
    
    self.remoteHostStatus = [hostReach currentReachabilityStatus] ;
    self.internetConnectionStatus= [internetReach currentReachabilityStatus];
    self.wifiConnectionStatus =[wifiReach currentReachabilityStatus];
    latitude=0.0;
    longitude=0.0;
    searchDistanceKM=kSearchDistance;
    return self;
}

-(void) dealloc{
    [self.frcNation release];
    //[self.frcLandsForCoordinate release];
    [self.frcShortNations release];
    [self.frcPlannedVisits release];
    [self.frcNearByNations release];
    [self.managedObjectContext release];
    [super dealloc];
}

#pragma Mark -
#pragma Mark fetchedResultsController delegate method

//fetched result controler for an specific nation object retrieved with number
-(NSFetchedResultsController *) frcNation{
    if(frcNation_ !=nil){
       return  frcNation_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Nation" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"OfficialName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    // set predicate
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"Number= %d", nationNumber];
    [fetchedRequest setPredicate:predicate];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"Nation"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Nation"];
    aFetchedResultsController.delegate = self;
    self.frcNation= aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return frcNation_;
}

//fetched result controler for the list of short nation objects (name , number and rowversion only)
-(NSFetchedResultsController *) frcShortNations {
    if(frcShortNations_ !=nil){
        return  frcShortNations_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Nation" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"OfficialName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    // set expression
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression1 = [NSExpression expressionForKeyPath:@"Number"];
    // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription1 = [[NSExpressionDescription alloc] init];
    [expressionDescription1 setName:@"Number"];
    [expressionDescription1 setExpression:keyPathExpression1];
    [expressionDescription1 setExpressionResultType:NSInteger32AttributeType];
    
    NSExpressionDescription *expressionDescription2 = [[NSExpressionDescription alloc] init];
    [expressionDescription2 setName:@"OfficialName"];
    [expressionDescription2 setExpression:keyPathExpression1];
    [expressionDescription2 setExpressionResultType:NSInteger32AttributeType];
    
    
    
    NSExpressionDescription *expressionDescription3 = [[NSExpressionDescription alloc] init];
    [expressionDescription3 setName:@"RowVersion"];
    [expressionDescription3 setExpression:keyPathExpression1];
    [expressionDescription3 setExpressionResultType:NSInteger32AttributeType];
    
    
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [fetchedRequest setPropertiesToFetch:[NSArray arrayWithObjects:expressionDescription1,expressionDescription2,expressionDescription3, nil]];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"ShortLNationList"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"ShortNationList"];
    aFetchedResultsController.delegate = self;
    
    self.frcShortNations = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return frcNation_;
}

// tends to get matching lands but includes the lands that could circle around the coordinate
//-(NSFetchedResultsController *) frcLandsForCoordinate{
//    if(fetchedResultsControllerLandsForCoordinate_ !=nil){
//        return  fetchedResultsControllerLandsForCoordinate_;
//    }
//    
//    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
//    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Land" inManagedObjectContext:self.managedObjectContext];
//    
//    [fetchedRequest setEntity:entity];
//    
//    // set sort key 
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"LandName" ascending:YES];
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    
//    [fetchedRequest setSortDescriptors:sortDescriptors];
//    
//    // set predicate
//    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(BoundaryN>= %lf) AND (BoundaryS<= %lf) AND (BoundaryE >= %lf) AND (BoundaryW<= %lf)",latitude,latitude,longitude,longitude];
//    [fetchedRequest setPredicate:predicate];
//    
//    //create fetchedResultsController
//    [NSFetchedResultsController deleteCacheWithName:@"Land"];
//    
//    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Land"];
//    aFetchedResultsController.delegate = self;
//    self.fetchedResultsControllerLandsForCoordinate = aFetchedResultsController;
//    
//    [aFetchedResultsController release];
//    [fetchedRequest release];
//    
//    
//    return fetchedResultsControllerLandsForCoordinate_;
//
//}

//-(NSFetchedResultsController*) frcNearByLands{
//    if(fetchedResultsControllerNearByLands_!=nil){
//        return fetchedResultsControllerNearByLands_;
//    }
// 
//  
//    CLLocation * center = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    CLLocationDegrees MinLat = [center destinationWithDistance:searchDistanceKM andDirection:180].coordinate.latitude;//south
//    CLLocationDegrees MaxLat = [center destinationWithDistance:searchDistanceKM andDirection:0].coordinate.latitude;//north
//    CLLocationDegrees MinLng = [center destinationWithDistance:searchDistanceKM andDirection:270].coordinate.longitude;//west
//    CLLocationDegrees MaxLng = [center destinationWithDistance:searchDistanceKM andDirection:90].coordinate.longitude;//east
// 
//
//    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
//    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Land" inManagedObjectContext:self.managedObjectContext];
//    
//    [fetchedRequest setEntity:entity];
//    
//    // set sort key 
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"LandName" ascending:YES];
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    
//    [fetchedRequest setSortDescriptors:sortDescriptors];
//    
//  
//    
//  //  "(((MinLat<=BoudaryN)AND(BoudaryN<=MaxLat))OR((MinLat<=BoudaryS)AND(BoudaryS<=MaxLat)) OR ((BoundaryN>=MaxLat)AND(BoundaryS<=MinLat)))AND(((MinLng<=BoudaryE)AND(BoudaryE<=MaxLng))OR((MinLng<=BoudaryW)AND(BoudaryW<=MaxLng))OR((BoundaryE>=MaxLng)AND(BoundaryW<=MinLng)))"
//  //, MinLat,MaxLat,MinLat,MaxLat,MaxLat,MinLat,MinLng,MaxLng,MinLng,MaxLng,MaxLng,MinLng
//    
//
//    
//    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(((%lf<=BoundaryN)AND(BoundaryN<=%lf))OR((%lf<=BoundaryS)AND(BoundaryS<=%lf)) OR ((BoundaryN>=%lf)AND(BoundaryS<=%lf)))AND(((%lf<=BoundaryE)AND(BoundaryE<=%lf))OR((%lf<=BoundaryW)AND(BoundaryW<=%lf))OR((BoundaryE>=%lf)AND(BoundaryW<=%lf)))",
//                             MinLat,MaxLat,MinLat,MaxLat,MaxLat,MinLat,MinLng,MaxLng,MinLng,MaxLng,MaxLng,MinLng];
//    [fetchedRequest setPredicate:predicate];
//   
//    //create fetchedResultsController
//    [NSFetchedResultsController deleteCacheWithName:@"NearByLands"];
//    
//    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"NearbyLands"];
//    aFetchedResultsController.delegate = self;
//    self.fetchedResultsControllerNearByLands = aFetchedResultsController;
//    
//    [aFetchedResultsController release];
//    [fetchedRequest release];
//    
//    
//    return fetchedResultsControllerNearByLands_;
//    
//}
//

//returns the list of plannedVisit managed objects
- (NSFetchedResultsController *)frcPlannedVisits {
    
    if (frcPlannedVisits_ != nil) {
        return frcPlannedVisits_;
    }
    
    /*
     Set up the fetched results controller.
	 */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PlannedVisit" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"FromDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
	// Clear the cache 
	[NSFetchedResultsController deleteCacheWithName:@"PlannedVisit"];
	
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"PlannedVisit"];
    aFetchedResultsController.delegate = self;
    self.frcPlannedVisits = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    
    return frcPlannedVisits_;
}   


#pragma mark- reachability
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateStatusesWithReachability: curReach];
}

- (void) updateStatusesWithReachability: (Reachability*) curReach {
    if(curReach == hostReach)
	{
        self.remoteHostStatus = [curReach currentReachabilityStatus];
        //self.viewController.remoteHostStatus =self.remoteHostStatus;
    }
    
	if(curReach == internetReach)
	{	
		
        self.internetConnectionStatus= [curReach currentReachabilityStatus];
        // self.viewController.internetConnectionStatus =self.internetConnectionStatus;
	}
	if(curReach == wifiReach)
	{
        self.wifiConnectionStatus =[curReach currentReachabilityStatus];
        // self.viewController.wifiConnectionStatus=self.wifiConnectionStatus;
	}
    
    
    if (remoteHostStatus!=NotReachable){
        if (toBeUpdatedNationNumber >0 && nationNumberUpdateFlag==NO){
         [self checkForNationUpdatesByNationNumber:[NSNumber numberWithInt: toBeUpdatedNationNumber]];
            toBeUpdatedNationNumber=0;
            nationNumberUpdateFlag=YES;
        }

        //check for updates
        if (!updateCheckStarted) {
        
            if (remoteHostStatus!=NotReachable) {
                addArray  =[[NSMutableArray alloc] init];
                deleteArray  =[[NSMutableArray alloc] init];
                updateArray  =[[NSMutableArray alloc] init];
            
                [self getShortNationsFromWebService]; 
                // change from here 
            
                updateCheckStarted = YES;
                NSLog(@"Update Started\n");
            
            }
       
        }
	
    }
}


#pragma mark - local data reterival

- (NSMutableArray*) shortNationList{
    return [NSMutableArray arrayWithArray:[self getShortNationArray]];
}

-(void) setNationToBeUpdatedByNationNumber:(int)number{
    toBeUpdatedNationNumber=number;
    nationNumberUpdateFlag=NO;
}

//-(NSArray*)getEstimatedMatchingLandsForLatitude:(double)lat andLongitude:(double)lng{
//    latitude=lat;
//    longitude=lng;
//    fetchedResultsControllerLandsForCoordinate_=nil;
//    NSError *error;
//        if(![[self fetchedResultsControllerLandsForCoordinate]performFetch:&error]){
//       //handle Error
//        }
//        
//       NSArray * fetchedEstimatedMatchingLands = [self.fetchedResultsControllerLandsForCoordinate fetchedObjects];
//    latitude=0.0;
//    longitude=0.0;
//    return fetchedEstimatedMatchingLands;
//}

//-(NSArray*)getNearbyLandsForLatitude:(double)lat andLongitude:(double)lng{
//    latitude=lat;
//    longitude=lng;
//    fetchedResultsControllerNearByLands_=nil;
//    NSError * error;
//    if(![[self fetchedResultsControllerNearByLands]performFetch:&error]){
//        //handle Error
//    }
//    NSMutableArray * fetchedNearByLands = [NSMutableArray arrayWithArray:[self.fetchedResultsControllerNearByLands fetchedObjects]];
//    
//    
//    if ([fetchedNearByLands count]>=kSearchCountLimit || searchDistanceKM>kSearchDistanceLimit) {
//        latitude=0.0;
//        longitude=0.0;
//
//    }else {
//        searchDistanceKM += kSearchExpantionParameter;
//       fetchedNearByLands= [NSMutableArray arrayWithArray:[self getNearbyLandsForLatitude:latitude andLongitude:longitude]];
//    }
//    return fetchedNearByLands; 
//}

- (NSArray*)getNearbyNationsForLatitude:(double)lat andLongitude:(double)lng{
    latitude=lat;
    longitude=lng;
    frcNearByNations_=nil;
    NSError * error;
    if(![[self frcNearByNations]performFetch:&error]){
        //        //handle Error
    }
     NSMutableArray * fetchedNearByNations = [NSMutableArray arrayWithArray:[self.frcNearByNations fetchedObjects]];
        if ([fetchedNearByNations count]>=kSearchCountLimit || searchDistanceKM>kSearchDistanceLimit) {
            latitude=0.0;
            longitude=0.0;
    
        }else {
            searchDistanceKM += kSearchExpantionParameter;
          fetchedNearByNations= [NSMutableArray arrayWithArray:[self getNearbyNationsForLatitude:latitude andLongitude:longitude]];
        }
        return fetchedNearByNations; 

}

//gets the managed Nation locally and sets it to be updated
-(Nation *)getNationWithNationNumber:(int)number{

    Nation * nation = [self getNationLocallyWithNationNumber:number];
    //check for updates here
    toBeUpdatedNationNumber= number;
    NSLog(@"nation to be updated: %d\n",toBeUpdatedNationNumber);
    nationNumberUpdateFlag= NO;
   
    return nation;
}

//gets the managed nation locally
-(Nation *)getNationLocallyWithNationNumber:(int)number{
    frcNation_=nil;
    nationNumber = number;
    NSError *error;
    if(![[self frcNation]performFetch:&error]){
        //handle Error
    }
    
    NSArray * results = [self.frcNation fetchedObjects];
    if([results count]>0)
        return [results objectAtIndex:0];
    else
        return nil;
}


//gets the array of ShortNationObjects locally
-(NSArray*)getShortNationArray{
    frcNation_=nil;
    NSError* error;
    if(![[self frcShortNations]performFetch:&error]){
        //handle error
    }
    NSArray * results=[self.frcShortNations fetchedObjects];
    NSMutableArray * shortNationArray= [[NSMutableArray alloc] initWithCapacity:[results count]];
    for (NSDictionary * nation  in results) {
        ShortNation * shortNation = [[ShortNation alloc] initWithDictionary:nation];        
        [shortNationArray addObject:shortNation];
        
    }
    return shortNationArray;
}
//returns a dictionary with keys as nation numbers and values as ShortNation objects

-(NSDictionary *)getShortNationsDictionary{
    NSArray * shortNationArray =[self getShortNationArray];
    int count = [shortNationArray count];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:count];
    if (self) {
        
        for (ShortNation * shortNation  in shortNationArray) 
            [dict setObject:shortNation forKey:[NSString stringWithFormat:@"%d",[ shortNation.Number intValue]]];
        
    }
    return  dict;
}

#pragma mark - Planned Visits
-(NSArray *)getAllPlannedVisits{
    frcPlannedVisits_=nil;
    NSError* error;
    if(![[self frcPlannedVisits]performFetch:&error]){
        //handle error
    }
    NSArray * results=[self.frcPlannedVisits fetchedObjects];
    return results;
}

//creates a new managed PlannedVisit object in the context
-(PlannedVisit *)getNewPlannedVisit{
    
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"PlannedVisit" inManagedObjectContext:self.managedObjectContext];
    PlannedVisit * aVisit = [[PlannedVisit alloc] initWithEntity:entity insertIntoManagedObjectContext: self.managedObjectContext];
    return  aVisit;
    
}


#pragma mark - Map
//creates a new managed Map object in the context
-(Map *)getNewMap{
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Map" inManagedObjectContext:self.managedObjectContext];
    Map * aMap = [[Map alloc] initWithEntity:entity insertIntoManagedObjectContext: self.managedObjectContext];
    return  aMap;

}

#pragma mark - Network data reterival
-(void) getShortNationsFromWebService{
    NSString *url = [NSString stringWithFormat:@"%@/nations/names",kHostName];//@"http://localhost/~ladan/FirstNationList";
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
}

-(void) getNationFromWebServiceWithNationNumber:(NSNumber *)number{
    //pass landID and language here:
    NSLog(@"getting Nation %d from web service\n", [number intValue]);
    NSString *url = [NSString stringWithFormat:@"%@/nation/%d",kHostName,[number intValue]];
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
    
}

-(void)checkForNationUpdatesByNationNumber:(NSNumber *)number{
   if (remoteHostStatus!=NotReachable) {
    if ([updateArray count]>0 &&[updateArray containsObject:number]) {
        [self getNationFromWebServiceWithNationNumber:number];
        [updateArray removeObject:number];
    }
   } 
}


#pragma mark - NetworkDataGetterDelegate Methods
//this method is a delegate method which might receive a list dictionary of a single land or a dictionary of land ids as keys and landShort objects as values. main data update operation takes place here.
-(void)DataUpdate:(id)object{
    if(!updateCheckFinished){// check for updates
        //first get the local dictionary 
        NSDictionary * localShortNationDict= [self getShortNationsDictionary];
        //get the largest local land id 
        NSArray * localKeyArray= [[localShortNationDict allKeys] sortedArrayUsingFunction:firstNumSort context:nil];
        int localLargestNumber = [[localKeyArray lastObject] intValue];
        
        //second get the network array:
        NSArray * networkArray = (NSArray* )object;
        NSMutableDictionary * networkDict=[[NSMutableDictionary alloc] initWithCapacity:[networkArray count]];
    //    NSArray * networkIDArray =[[networkArray allKeys] sortedArrayUsingFunction: firstNumSort context:NULL ];
        NSMutableArray *networkIDArray=[[NSMutableArray alloc]init];
        for (NSDictionary *  dict in networkArray) {
            ShortNation *sn =[[ShortNation alloc] initWithDictionary:dict];
            [networkIDArray addObject:sn.Number];
            [networkDict setValue:sn forKey:[NSString stringWithFormat:@"%d", sn.Number] ];
        }
        networkIDArray=[NSMutableArray arrayWithArray:[networkIDArray sortedArrayUsingFunction: firstNumSort context:NULL ]];
         //get the largest network land id 
        int netWorkLargestNumber =[[networkIDArray lastObject] intValue];
        
        // get the maximum of largest ids
        int max = MAX(localLargestNumber, netWorkLargestNumber);
        
        // figure out additiond, deletions and updates
        for (int i=0 ; i<=max; i++) {
            BOOL nationExistLocally = [localKeyArray containsObject: [NSString stringWithFormat:@"%d",i]];
            BOOL nationExistRemothly =[networkIDArray containsObject:[NSNumber numberWithInt:i]];
            
            if(nationExistLocally && nationExistRemothly){
                ShortNation *sn = (ShortNation*)[localShortNationDict valueForKey:[NSString stringWithFormat:@"%d",i]];
                NSNumber  * localVersion=sn.RowVersion;
                NSNumber * remotVersion=[[networkDict valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"VersionIdentifier"];
                if ([remotVersion intValue]!=[localVersion intValue]) {
                    [updateArray addObject:[NSNumber numberWithInt:i]];
                }
            }else if(nationExistLocally){ // it should be deleted
                [deleteArray addObject:[NSNumber numberWithInt:i]];
            }else if (nationExistRemothly){
                [addArray addObject:[NSNumber numberWithInt:i]];
            }

        }// end of for
        //apply deletes:
        if ([deleteArray count]>0) {
            for (NSNumber * n in deleteArray) {
                Nation * nation = [self getNationWithNationNumber:[n intValue]];
                [self.managedObjectContext deleteObject:nation];
            }
            
            NSError * error;
            //if(![self.managedObjectContext save:&error]){
            if (!(error=[self SaveData])) {
               
            
            }else{
                if  ([deleteArray count]>0) {
                    [self.shortNationList removeAllObjects];
                    [self.shortNationList addObjectsFromArray: [self getShortNationArray]];
                    NSLog(@"%@",[self.shortNationList description]);
                    // Broadcast a notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewList" object:self.shortNationList]; 
                }
            }
        } // end of deletion
         
        //get objects to be addes
        if ([addArray count]>0) {
            
            for (NSNumber * n in addArray){
               [self getNationFromWebServiceWithNationNumber:n];
            }
            frcShortNations_ =nil;
            frcNation_ =nil;
        }
          
        updateCheckFinished=YES;
    }else{// apply the additions and updates
        //get the object
        BOOL updating =NO;
        WSNation * newNation = [[WSNation alloc] initWithDictionary:(NSDictionary*)object];
//        if (toBeUpdatedLandID>0 && landIDUpdateFlag ==NO) {
//            toBeUpdatedLandID=0;
//            landIDUpdateFlag=YES;
//        }
        //check if the land is already there and should be deleted first:
        Nation * exsistingNation= [self getNationLocallyWithNationNumber:[newNation.Number intValue]];
        if(exsistingNation!= nil){
            NSLog(@"Updating Nation %d",[newNation.Number intValue]);
            //[self.managedObjectContext deleteObject:exsistingNation];
             updating = YES;
            [self updateManagedNation:exsistingNation WithWNation:newNation];
                
        }else{
            NSLog(@"Adding Nation %d",[newNation.Number intValue]);
            Nation * newManagedNation = [newNation ToManagedNation:self.managedObjectContext]; 
        
            NSError * error;

            if (!(error=[self SaveData])) {
            
                NSLog(@"%@",[error description]);
            } else{
                NSLog(@"Added Nation %d",[newManagedNation.Number intValue]);
            }
        }
        if (updating==YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedNation" object:exsistingNation]; 
              NSLog(@"update Nation notification posted");
        }
   
         NSLog(@"new List notification posted");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewList" object:self.shortNationList]; 
        
    }

    nationNumber=0;
}

-(void)DataError:(NSError *)error{
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"%@", [error description]);
}

-(void) updateManagedNation:(Nation *)mNation WithWNation:(WSNation *)wsNation{
    Nation * newManagedNation = [wsNation ToManagedNation:self.managedObjectContext];
    mNation.OfficialName =newManagedNation.OfficialName;
     mNation.Number =newManagedNation.Number;
     mNation.RowVersion =newManagedNation.RowVersion;
     mNation.Address =newManagedNation.Address;
     mNation.CommunitySite =newManagedNation.CommunitySite  ;
     mNation.CenterLat =newManagedNation.CenterLat;
     mNation.CenterLong =newManagedNation.CenterLong;
    mNation.Phone = newManagedNation.Phone;
    mNation.PostCode= newManagedNation.PostCode;
    
    if (mNation.Greeting) {
        //
    }
    mNation.Greeting= nil;
  
    mNation.Greeting= newManagedNation.Greeting;
    [self.managedObjectContext deleteObject:newManagedNation];
    
    NSError * error;
   // if(![self.managedObjectContext save:&error]){
    if (!(error=[self SaveData])) {
   
        NSLog(@"%@",[error description]);
    } else{
        NSLog(@"updated nation %d",[mNation.Number intValue]);
    }      
}

-(NSError *)SaveData{
    NSError * error;
    if(![self.managedObjectContext save:&error]) 
        return error;
    else 
        return nil;
    
}
-(NSError*)DeleteVisit:(PlannedVisit*) visit{
    NSError * error;
    [self.managedObjectContext deleteObject:visit];
    if(![self.managedObjectContext save:&error]) return error;
    else return nil;
}
@end
