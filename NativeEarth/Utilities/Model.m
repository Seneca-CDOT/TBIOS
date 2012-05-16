 //
//  Model.m
//  NativeEarth
//

//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "Constants.h"



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
frcSectionedShortNations=frcSectionedShortNations_,
frcPlannedVisits= frcPlannedVisits_,
frcGreeting=frcGreeting_;

@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

@synthesize internetConnectionStatus;
@synthesize wifiConnectionStatus;
@synthesize remoteHostStatus;
@synthesize shortNationList;

-(id) init{
    [super init];
    
    // Override point for customization after application launch.
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    self.shortNationList = [[NSMutableArray arrayWithArray:[self getShortNationArray] ] retain];
 //   NSLog(@"initial nation list:\n");
 //   NSLog(@"%@",[self.shortNationList description]);
    
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
    [self.frcGreeting release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
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
-(NSFetchedResultsController *) frcNearByNations{
    if(frcNearByNations_ !=nil){
        return  frcNearByNations_;
    }
     NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Nation" inManagedObjectContext:self.managedObjectContext];
    [fetchedRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"OfficialName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
     [fetchedRequest setSortDescriptors:sortDescriptors];
    
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"NearByNations"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"NearByNations"];
    aFetchedResultsController.delegate = self;
    self.frcNearByNations= aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return frcNearByNations_;

}
-(NSFetchedResultsController *) frcGreeting{
    if(frcGreeting_ !=nil){
        return  frcGreeting_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Greeting" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    // set sort key 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"GreetingID" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];

    
    // set predicate
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"GreetingID= %d", greetingId];
    [fetchedRequest setPredicate:predicate];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"Greeting"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Greeting"];
    aFetchedResultsController.delegate = self;
    self.frcGreeting= aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return frcGreeting_;
}



//fetched result controler for the list of short nation objects (name , number and rowversion only)
-(NSFetchedResultsController *) frcSectionedShortNations {
    if(frcSectionedShortNations_ !=nil){
        return  frcSectionedShortNations_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Nation" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"Province" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"OfficialName" ascending:YES];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    [fetchedRequest setResultType:NSDictionaryResultType];
    
    // set expression
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression1 = [NSExpression expressionForKeyPath:@"Number"];
    NSExpressionDescription *expressionDescription1 = [[NSExpressionDescription alloc] init];
    [expressionDescription1 setName:@"Number"];
    [expressionDescription1 setExpression:keyPathExpression1];
    [expressionDescription1 setExpressionResultType:NSInteger32AttributeType];
    [keyPathExpression1 release];
    // Create an expression for the key path.
    NSExpression *keyPathExpression2 = [NSExpression expressionForKeyPath:@"OfficialName"];
    NSExpressionDescription *expressionDescription2 = [[NSExpressionDescription alloc] init];
    [expressionDescription2 setName:@"OfficialName"];
    [expressionDescription2 setExpression:keyPathExpression2];
    [expressionDescription2 setExpressionResultType:NSStringAttributeType];
    [keyPathExpression2 release];
    // Create an expression for the key path.
    NSExpression *keyPathExpression3 = [NSExpression expressionForKeyPath:@"rowversion"];
    NSExpressionDescription *expressionDescription3 = [[NSExpressionDescription alloc] init];
    [expressionDescription3 setName:@"rowversion"];
    [expressionDescription3 setExpression:keyPathExpression3];
    [expressionDescription3 setExpressionResultType:NSStringAttributeType];
    [keyPathExpression3 release];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression4 = [NSExpression expressionForKeyPath:@"Province"];
    NSExpressionDescription *expressionDescription4 = [[NSExpressionDescription alloc] init];
    [expressionDescription4 setName:@"Province"];
    [expressionDescription4 setExpression:keyPathExpression4];
    [expressionDescription4 setExpressionResultType:NSStringAttributeType];
    [keyPathExpression4 release];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [fetchedRequest setPropertiesToFetch:[NSArray arrayWithObjects:expressionDescription1,expressionDescription2,expressionDescription3,expressionDescription4, nil]];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"ShortNationList"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"Province" cacheName:@"ShortNationList"];
    aFetchedResultsController.delegate = self;
    
    self.frcSectionedShortNations = aFetchedResultsController;
    
    [expressionDescription1 release];
    [expressionDescription2 release];
    [expressionDescription3 release];
    [expressionDescription4 release];
    
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return frcSectionedShortNations_;
}
-(NSFetchedResultsController *) frcShortNations {
    if(frcShortNations_ !=nil){
        return  frcShortNations_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Nation" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    // NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"Province" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"OfficialName" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    [fetchedRequest setResultType:NSDictionaryResultType];
    
    // set expression
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression1 = [NSExpression expressionForKeyPath:@"Number"];
    NSExpressionDescription *expressionDescription1 = [[NSExpressionDescription alloc] init];
    [expressionDescription1 setName:@"Number"];
    [expressionDescription1 setExpression:keyPathExpression1];
    [expressionDescription1 setExpressionResultType:NSInteger32AttributeType];
    [keyPathExpression1 release];
    // Create an expression for the key path.
    NSExpression *keyPathExpression2 = [NSExpression expressionForKeyPath:@"OfficialName"];
    NSExpressionDescription *expressionDescription2 = [[NSExpressionDescription alloc] init];
    [expressionDescription2 setName:@"OfficialName"];
    [expressionDescription2 setExpression:keyPathExpression2];
    [expressionDescription2 setExpressionResultType:NSStringAttributeType];
    [keyPathExpression2 release];
    // Create an expression for the key path.
    NSExpression *keyPathExpression3 = [NSExpression expressionForKeyPath:@"rowversion"];
    NSExpressionDescription *expressionDescription3 = [[NSExpressionDescription alloc] init];
    [expressionDescription3 setName:@"rowversion"];
    [expressionDescription3 setExpression:keyPathExpression3];
    [expressionDescription3 setExpressionResultType:NSStringAttributeType];
    [keyPathExpression3 release];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression4 = [NSExpression expressionForKeyPath:@"Province"];
    NSExpressionDescription *expressionDescription4 = [[NSExpressionDescription alloc] init];
    [expressionDescription4 setName:@"Province"];
    [expressionDescription4 setExpression:keyPathExpression4];
    [expressionDescription4 setExpressionResultType:NSStringAttributeType];
    [keyPathExpression4 release];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [fetchedRequest setPropertiesToFetch:[NSArray arrayWithObjects:expressionDescription1,expressionDescription2,expressionDescription3,expressionDescription4, nil]];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"ShortNationList"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"ShortNationList"];
    aFetchedResultsController.delegate = self;
    
    self.frcShortNations = aFetchedResultsController;
    
    [expressionDescription1 release];
    [expressionDescription2 release];
    [expressionDescription3 release];
    [expressionDescription4 release];
    
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return frcShortNations_;
}





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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"FromDate" ascending:YES];
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
    }
    
	if(curReach == internetReach)
	{	
		
        self.internetConnectionStatus= [curReach currentReachabilityStatus];
    
	}
	if(curReach == wifiReach)
	{
        self.wifiConnectionStatus =[curReach currentReachabilityStatus];
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
                deleteArray  =[[NSMutableArray alloc] init] ;
                updateArray  =[[NSMutableArray alloc] init] ;
            
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


- (NSArray*)getNearbyNationsForLatitude:(double)lat andLongitude:(double)lng{
    latitude=lat;
    longitude=lng;
    frcNearByNations_=nil;
    NSError * error;
    if(![[self frcNearByNations]performFetch:&error]){
        //        //handle Error
        NSLog(@"%@",[error description]);
    }
    NSMutableArray * allNations = [NSMutableArray arrayWithArray:[self.frcNearByNations fetchedObjects]];
    
    
    NSPredicate * predicate =[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {

        return ([self DistanceToNation:(Nation*)evaluatedObject] <= searchDistanceKM);
    }];

    NSArray * nearByNations = [allNations filteredArrayUsingPredicate:predicate];
   
        if ([nearByNations count]>=kSearchCountLimit || searchDistanceKM>kSearchDistanceLimit) {
    
        }else {
            searchDistanceKM += kSearchExpantionParameter;
            [nearByNations release];
          nearByNations= [NSMutableArray arrayWithArray:[self getNearbyNationsForLatitude:latitude andLongitude:longitude]];
        }
        return nearByNations; 

}
-(CLLocationDistance )DistanceToNation:(Nation*) nation{
        CLLocation * currentLoc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocation * centerLoc = [[CLLocation alloc]initWithLatitude:[nation.CenterLat doubleValue] longitude:[nation.CenterLong doubleValue]] ;
    CLLocationDistance dist= [currentLoc distanceFromLocation:centerLoc]/1000;  
        return dist;
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

-(NSFetchedResultsController *)getShortNationFetchedResults{
    frcSectionedShortNations_=nil;
    NSError* error;
    if(![[self frcSectionedShortNations]performFetch:&error]){
        //handle error
    }
    return  self.frcSectionedShortNations;
}

//gets the array of ShortNationObjects locally
-(NSArray*)getShortNationArray{
    frcShortNations_=nil;
    NSError* error;
    if(![[self frcShortNations]performFetch:&error]){
        NSLog(@"%@",[error userInfo] );
              }
    NSArray * results=[self.frcShortNations fetchedObjects];
    NSMutableArray * shortNationArray= [[NSMutableArray alloc] initWithCapacity:[results count]];
    for (NSDictionary * nation  in results) {
        ShortNation * shortNation = [[ShortNation alloc] initWithDictionary:nation];        
        [shortNationArray addObject:shortNation];
        [shortNation release];
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
#pragma mark - Greeting
//gets the greeting object by id
-(Greeting *)getGreetingWithGreetingId:(int)gId{
    
    frcGreeting_=nil;
    greetingId = gId;
    NSError *error;
    if(![[self frcGreeting]performFetch:&error]){
        //handle Error
    }
    
    NSArray * results = [self.frcGreeting fetchedObjects];
    if([results count]>0)
        return [results objectAtIndex:0];
    else
        return nil;
   
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
#pragma mark -Land


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
    NSString *url = [NSString stringWithFormat:@"%@/nation/%d/alldata",kHostName,[number intValue]];
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
    if(!updateCheckFinished){// check for updates (here the object is the array of shortNations)
        //first get the local dictionary 
        NSDictionary * localShortNationDict= [self getShortNationsDictionary];
        //get the largest local land id 
        NSArray * localKeyArray= [[localShortNationDict allKeys] sortedArrayUsingFunction:firstNumSort context:nil];
        int localLargestNumber = [[localKeyArray lastObject] intValue];
        
        //second get the network array:
        NSArray * networkArray = (NSArray* )object;
        NSMutableDictionary * networkDict=[[NSMutableDictionary alloc] initWithCapacity:[networkArray count]];
        NSMutableArray *networkIDArray=[[NSMutableArray alloc]init];
        for (NSDictionary *  dict in networkArray) {
            ShortNation *sn =[[ShortNation alloc] initWithDictionary:dict];
            [networkIDArray addObject:sn.Number];
            [networkDict setObject:sn forKey:[NSString stringWithFormat:@"%d", [sn.Number intValue]] ];
          
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
                //get local object rowversion
                ShortNation *lsn = (ShortNation*)[localShortNationDict valueForKey:[NSString stringWithFormat:@"%d",i]];
                NSString *localVersion=lsn.RowVersion; 
                //get remote onject rowversion
                NSString * key = [NSString stringWithFormat:@"%d",i];
                ShortNation * rsn = (ShortNation*)[networkDict objectForKey: key];
                NSString * remoteVersion=rsn.RowVersion;
                if (![remoteVersion isEqualToString: localVersion ]) {  // data must be the same here but it is not
                    [updateArray addObject:[NSNumber numberWithInt:i]];
                }
            }
            else if(nationExistLocally){ // it should be deleted
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
                [nation release];
            }
            
            NSError * error;
            if (error=[self SaveData]) {
                NSLog(@"%@",[error description]);
            }else{// after delets are saved refresh the shortNationList and post notfication for new list
                    [self.shortNationList removeAllObjects];
                    [self.shortNationList addObjectsFromArray: [self getShortNationArray]];
                    // Broadcast a notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewList" object:self.shortNationList]; 
              
            }
        } // end of deletion
         
        //get objects to be addes
        if ([addArray count]>0) {
            
            for (NSNumber * n in addArray){ 
               [self getNationFromWebServiceWithNationNumber:n];
            }
            frcShortNations_ =nil;
            frcNation_ =nil;
            frcGreeting_=nil;
        }
          
        updateCheckFinished=YES;
        [localShortNationDict release];
        [networkArray release];
        [networkDict release];

    }
    else{// here it has already figured out the add and update array values and it is now applying them 
         //(here the object is a Nation not the array of shortNations)
        //get the object
        BOOL updating =NO; // to defrentiate between update and add
        //convert the object to WSNation 
        WSNation * newNation = [[WSNation alloc] initWithDictionary:(NSDictionary*)object] ;
        //check if the nation is already there and should be deleted first:
        Nation * exsistingNation= [self getNationLocallyWithNationNumber:[newNation.Number intValue]];
        if(exsistingNation!= nil){
            NSLog(@"Updating Nation %d",[newNation.Number intValue]);

             updating = YES;
            [self updateManagedNation:exsistingNation WithWNation:newNation];
                
        }
        else{
            NSLog(@"Adding Nation %d",[newNation.Number intValue]);
            Nation * newManagedNation = [newNation ToManagedNation:self.managedObjectContext]; 
        
            NSError * error;

            if (!(error=[self SaveData])) {
             NSLog(@"Added Nation %d",[newManagedNation.Number intValue]);
            } else{
                NSLog(@"%@",[error description]);
            }
        
            [newManagedNation release];
        }
        [newNation release];
        if (updating==YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedNation" object:exsistingNation]; 
            [exsistingNation release];
        }
        
   
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

    mNation.OfficialName =wsNation.OfficialName;
    mNation.Number =wsNation.Number;
    mNation.rowversion =wsNation.RowVersion;
    mNation.Address =wsNation.Address;
    mNation.CommunitySite =wsNation.CommunitySite;
    mNation.CenterLat =wsNation.CenterLat;
    mNation.CenterLong =wsNation.CenterLong;
    mNation.Phone = wsNation.Phone;
    mNation.PostCode=wsNation.PostCode; 
    mNation.Province=wsNation.Province;
    
    //reload all lands
    for (Land* land in [mNation.Lands allObjects]) {
        [self.managedObjectContext deleteObject:land];
    }
    for (WSLand *wsland  in wsNation.Lands) {
        [mNation addLandsObject:[[wsland ToManagedLand:self.managedObjectContext]autorelease]];
    }
       
    
    // updating Greeting 
    if (mNation.greeting  && wsNation.greeting) { // if both had greeting
        int localId=[mNation.greeting.GreetingID intValue];
        int remoteId=[wsNation.greeting.GreetingID intValue];
        if (localId==remoteId) {//if both greetings are the same one (same id)
            if (![mNation.greeting.RowVersion isEqualToString:wsNation.greeting.RowVersion] ) {
                mNation.greeting.Hello=wsNation.greeting.Hello;
                mNation.greeting.HelloMIMEType=wsNation.greeting.HelloMIMEType;
                mNation.greeting.HelloPronunciation=wsNation.greeting.HelloPronunciation;
                mNation.greeting.GoodBye=wsNation.greeting.GoodBye;
                mNation.greeting.GoodByeMIMEType=wsNation.greeting.GoodByeMIMEType;
                mNation.greeting.GoodByePronunciation=wsNation.greeting.GoodByePronunciation;
                mNation.greeting.ThankYou=wsNation.greeting.ThankYou;
                mNation.greeting.ThankYouMIMEType=wsNation.greeting.ThankYouMIMEType;
                mNation.greeting.ThankYouPronunciation=wsNation.greeting.ThankYouPronunciation;
                mNation.greeting.ActorName=wsNation.greeting.ActorName;
                mNation.greeting.RecordedOn=wsNation.greeting.RecordedOn;
                mNation.greeting.RowVersion=wsNation.greeting.RowVersion;
            }
        }else{//if the greeting id has changed
        //First keep the old greeting somewhere
            Greeting * tempGreeting = mNation.greeting;
             //check if the new greeting exist locally:
            Greeting * aGreeting = [self getGreetingWithGreetingId:[wsNation.greeting.GreetingID intValue]];
            if (aGreeting) {//if yes
                [mNation.greeting removeNationsObject:mNation];//break the relationship of old greeting with nation
                [aGreeting addNationsObject:mNation];//then assign the new Greeting to the nation
            }else{ //if No
                [mNation.greeting removeNationsObject:mNation];//break the relationship of old greeting with nation
                Greeting * newGreeting = [wsNation.greeting ToManagedGreeting:self.managedObjectContext];//create a new greeting 
                [newGreeting addNationsObject:mNation]; //give it to nation
            }
            if ([tempGreeting.Nations count]==0) {// now check to see if the old greeting is in use anymore
                [self.managedObjectContext deleteObject:tempGreeting];
            }
          
        }
        
    }
    else if(wsNation.greeting){
        //check if the new greeting exist locally:
        Greeting * aGreeting = [[self getGreetingWithGreetingId:[wsNation.greeting.GreetingID intValue]] autorelease];
        if (aGreeting) {//if yes
            [aGreeting addNationsObject:mNation];//then assign the new Greeting to the nation
        }else{
        [[[wsNation.greeting ToManagedGreeting:self.managedObjectContext] autorelease] addNationsObject:mNation];
        }
    }
    else if(mNation.greeting){
        Greeting * tempGreeting = mNation.greeting;
        [mNation.greeting removeNationsObject:mNation];
        if ([tempGreeting.Nations count]==0) {// now check to see if the old greeting is in use anymore
            [self.managedObjectContext deleteObject:tempGreeting];
        }
        
    }
    
    
//saving the Nation
    NSError * error;
    if (!(error=[self SaveData])) {
         NSLog(@"updated nation %d",[mNation.Number intValue]);
    } else{
       NSLog(@"%@",[error userInfo]);
    }      
}



-(NSError*)DeleteVisit:(PlannedVisit*) visit{
    NSError * error;
    [self.managedObjectContext deleteObject:visit];
    if(![self.managedObjectContext save:&error]) return error;
    else return nil;
}

-(void)removeCanceledVisit:(PlannedVisit*) visit{
    [self.managedObjectContext deleteObject:visit];
}

-(NSError *)SaveData{
    NSError * error;
    if([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) 
        return error;
    else 
        return nil;
    
}


#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NativeEarth" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NativeEarth.sqlite"];
    
    
    
    //Light Weight migration support code:
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    
    // pass the option to the init method:
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    { 
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
