 //
//  LocalLandGetter.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LandGetter.h"
#import "WSLand.h"
NSInteger firstNumSort(id str1, id str2, void *context) {
    int num1 = [str1 integerValue];
    int num2 = [str2 integerValue];
    
    if (num1 < num2)
        return NSOrderedAscending;
    else if (num1 > num2)
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

@implementation LandGetter
@synthesize fetchedResultsControllerLand=fetchedResultsControllerLand_, 
fetchedResultsControllerShortLands=fetchedResultsControllerShortLands_, 
fetchedResultsControllerLandsForCoordinate=fetchedResultsControllerLandsForCoordinate_,
managedObjectContext=managedObjectContext_;


@synthesize internetConnectionStatus;
@synthesize wifiConnectionStatus;
@synthesize remoteHostStatus;
@synthesize landShortList;

-(id) initWithManagedObjectContext:(NSManagedObjectContext* ) context{
    [super init];
    self.managedObjectContext = context;
    
    // Override point for customization after application launch.
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    self.landShortList = [[NSMutableArray arrayWithArray:[self GetLandShortArray] ] retain];
    NSLog(@"initial list:\n");
    NSLog(@"%@",[self.landShortList description]);
    
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
    return self;
}
-(void) dealloc{
    [self.fetchedResultsControllerLand release];
    [self.managedObjectContext release];
    [super dealloc];
}

#pragma Mark -
#pragma Mark fetchedResultsController delegate method
-(NSFetchedResultsController *) fetchedResultsControllerLand {
    if(fetchedResultsControllerLand_ !=nil){
       return  fetchedResultsControllerLand_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Land" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"LandName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    // set predicate
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"LandID= %d", landID];
    [fetchedRequest setPredicate:predicate];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"Land"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Land"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsControllerLand = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return fetchedResultsControllerLand_;
}

-(NSFetchedResultsController *) fetchedResultsControllerShortLands {
    if(fetchedResultsControllerShortLands_ !=nil){
        return  fetchedResultsControllerShortLands_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Land" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"LandName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    // set expression
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression1 = [NSExpression expressionForKeyPath:@"LandID"];
    // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription1 = [[NSExpressionDescription alloc] init];
    [expressionDescription1 setName:@"LandID"];
    [expressionDescription1 setExpression:keyPathExpression1];
    [expressionDescription1 setExpressionResultType:NSInteger32AttributeType];
    
    // NSExpression *keyPathExpression2 = [NSExpression expressionForKeyPath:@"LandName"];
    NSExpressionDescription *expressionDescription2 = [[NSExpressionDescription alloc] init];
    [expressionDescription2 setName:@"LandName"];
    [expressionDescription2 setExpression:keyPathExpression1];
    [expressionDescription2 setExpressionResultType:NSInteger32AttributeType];
    
    
    
    // NSExpression *keyPathExpression3 = [NSExpression expressionForKeyPath:@"VersionIdentifier"];
    NSExpressionDescription *expressionDescription3 = [[NSExpressionDescription alloc] init];
    [expressionDescription3 setName:@"VersionIdentifier"];
    [expressionDescription3 setExpression:keyPathExpression1];
    [expressionDescription3 setExpressionResultType:NSInteger32AttributeType];
    
    
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [fetchedRequest setPropertiesToFetch:[NSArray arrayWithObjects:expressionDescription1,expressionDescription2,expressionDescription3, nil]];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"ShortLandList"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"ShortLandList"];
    aFetchedResultsController.delegate = self;
    
    self.fetchedResultsControllerShortLands = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return fetchedResultsControllerShortLands_;
}

-(NSFetchedResultsController *) fetchedResultsControllerLandsForCoordinate{
    if(fetchedResultsControllerLandsForCoordinate_ !=nil){
        return  fetchedResultsControllerLandsForCoordinate_;
    }
    
    NSFetchRequest *fetchedRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Land" inManagedObjectContext:self.managedObjectContext];
    
    [fetchedRequest setEntity:entity];
    
    // set sort key 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"LandName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchedRequest setSortDescriptors:sortDescriptors];
    
    // set predicate
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(BoundaryN>= %lf) AND (BoundaryS<= %lf) AND (BoundaryE >= %lf) AND (BoundaryW<= %lf)",latitude,latitude,longitude,longitude];
    [fetchedRequest setPredicate:predicate];
    
    //create fetchedResultsController
    [NSFetchedResultsController deleteCacheWithName:@"Land"];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchedRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Land"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsControllerLandsForCoordinate = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchedRequest release];
    
    
    return fetchedResultsControllerLandsForCoordinate_;

}


#pragma mark- reachability
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateStatusesWithReachability: curReach];
}
- (void) updateStatusesWithReachability: (Reachability*) curReach
{
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
        if (toBeUpdatedLandID >0 && landIDUpdateFlag==NO){
         [self CheckForLandUpdatesByLandId:[NSNumber numberWithInt: toBeUpdatedLandID]];
            toBeUpdatedLandID=0;
            landIDUpdateFlag=YES;
        }

        //check for updates
        if (!updateCheckStarted) {
        
            if (remoteHostStatus!=NotReachable) {
                addArray  =[[NSMutableArray alloc] init];
                deleteArray  =[[NSMutableArray alloc] init];
                updateArray  =[[NSMutableArray alloc] init];
            
                [self GetLandShortsFromWebService]; 
                // change from here 
            
                updateCheckStarted = YES;
                NSLog(@"Update Started\n");
            
            }
       
        }
	
    }
}


-(NSMutableArray*) landShortList{
    return [NSMutableArray arrayWithArray:[self GetLandShortArray]];
}

#pragma mark - local data reterival
-(void) setLandToBeUpdatedById:(int)landId{
    toBeUpdatedLandID=landId;
    landIDUpdateFlag=NO;
}
-(NSArray*)getNearbyLandsForLatitute:(double)lat andLongitute:(double)lng{
    latitude=lat;
    longitude=lng;
    fetchedResultsControllerLandsForCoordinate_=nil;
    NSError *error;
        if(![[self fetchedResultsControllerLandsForCoordinate]performFetch:&error]){
       //handle Error
        }
        
       NSArray * fetchedNearByLands = [self.fetchedResultsControllerLandsForCoordinate fetchedObjects];
    latitude=0.0;
    longitude=0.0;
    return fetchedNearByLands;
}

-(Land *)GetLandWithLandId:(int)landId{

    Land * land = [self GetLandLocallyWithLandId:landId];
    //check for updates here
    toBeUpdatedLandID = landId;
    NSLog(@"land to be updated: %d\n",toBeUpdatedLandID);
    landIDUpdateFlag= NO;
   
    return land;
}

-(Land *)GetLandLocallyWithLandId:(int)landId{
    fetchedResultsControllerLand_=nil;
    landID = landId;
    NSError *error;
    if(![[self fetchedResultsControllerLand]performFetch:&error]){
        //handle Error
    }
    
    NSArray * results = [self.fetchedResultsControllerLand fetchedObjects];
    if([results count]>0)
        return [results objectAtIndex:0];
    else
        return nil;
}

-(NSDictionary *)GetLandShortsDictionary{
    NSArray * landShortArray =[self GetLandShortArray];
    int count = [landShortArray count];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:count];
    if (self) {
        
        for (LandShort * landShort  in landShortArray) 
            [dict setObject:landShort forKey:[NSString stringWithFormat:@"%d",[ landShort.landId intValue]]];
        
    }
    return  dict;
}


-(NSArray*)GetLandShortArray{
    fetchedResultsControllerShortLands_=nil;
    NSError* error;
    if(![[self fetchedResultsControllerShortLands]performFetch:&error]){
        //handle error
    }
    NSArray * results=[self.fetchedResultsControllerShortLands fetchedObjects];
    NSMutableArray * landShortArray= [[NSMutableArray alloc] initWithCapacity:[results count]];
    for (NSDictionary * land  in results) {
        LandShort * landShort = [[LandShort alloc] initWithDictionary:land];        
        [landShortArray addObject:landShort];
        
    }
    return landShortArray;
}


#pragma mark - Network data reterival
-(void) GetLandShortsFromWebService{
    NSString *url = @"http://localhost/~ladan/FirstNationList";
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
}

-(void) GetLandFromWebServiceWithLandId:(NSNumber *)landId{
    //pass landID and language here:
    NSLog(@"getting land %d from web service\n", [landId intValue]);
    NSString *url = [NSString stringWithFormat:@"http://localhost/~ladan/Land%d",[landId intValue]];
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
    
}


-(void)CheckForLandUpdatesByLandId:(NSNumber *)landId{
   if (remoteHostStatus!=NotReachable) {
    if ([updateArray count]>0 &&[updateArray containsObject:landId]) {
        [self GetLandFromWebServiceWithLandId:landId];
        [updateArray removeObject:landId];
    }
   }
}

#pragma mark - NetworkDataGetterDelegate Methods

//this method is a delegate method which might receive a list dictionary of a single land or a dictionary of land ids as keys and landShort objects as values. main data update operation takes place here.
-(void)DataUpdate:(id)object{
    if(!updateCheckFinished){// check for updates
        //first get the local dictionary 
        NSDictionary * localLandShortDict= [self GetLandShortsDictionary];
        //get the largest local land id 
        NSArray * localKeyArray= [[localLandShortDict allKeys] sortedArrayUsingFunction:firstNumSort context:nil];
        int localLargestID = [[localKeyArray lastObject] intValue];
        
        //second get the network array:
        NSDictionary * networkDict = (NSDictionary* )object;
        NSArray * networkIDArray =[[networkDict allKeys] sortedArrayUsingFunction: firstNumSort context:NULL ];
         //get the largest network land id 
        int netWorkLargestID =[[networkIDArray lastObject] intValue];
        
        // get the maximum of largest ids
        int max = MAX(localLargestID, netWorkLargestID);
        
        // figure out additiond, deletions and updates
        for (int i=0 ; i<=max; i++) {
            BOOL landExistLocally = [localKeyArray containsObject: [NSString stringWithFormat:@"%d",i]];
            BOOL landExistRemothly =[networkIDArray containsObject:[NSString stringWithFormat:@"%d",i]];
            
            if(landExistLocally && landExistRemothly){
                LandShort *l = (LandShort*)[localLandShortDict valueForKey:[NSString stringWithFormat:@"%d",i]];
                NSNumber  * localVersion=l.versionIdentifier;
                NSNumber * remotVersion=[[networkDict valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"VersionIdentifier"];
                if ([remotVersion intValue]!=[localVersion intValue]) {
                    [updateArray addObject:[NSNumber numberWithInt:i]];
                }
            }else if(landExistLocally){ // it should be deleted
                [deleteArray addObject:[NSNumber numberWithInt:i]];
            }else if (landExistRemothly){
                [addArray addObject:[NSNumber numberWithInt:i]];
            }

        }// end of for
        //apply deletes:
        if ([deleteArray count]>0) {
            for (NSNumber * n in deleteArray) {
                Land * land = [self GetLandWithLandId:[n intValue]];
                [self.managedObjectContext deleteObject:land];
            }
            
            NSError * error;
            if(![self.managedObjectContext save:&error]){
            }else{
                if  ([deleteArray count]>0) {
                    [self.landShortList removeAllObjects];
                    [self.landShortList addObjectsFromArray: [self GetLandShortArray]];
                    NSLog(@"%@",[self.landShortList description]);
                    // Broadcast a notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewList" object:self.landShortList]; 
                }
            }
        } // end of deletion
         
        //get objects to be addes
        if ([addArray count]>0) {
            
            for (NSNumber * n in addArray){
               [self GetLandFromWebServiceWithLandId:n];
            }
            fetchedResultsControllerShortLands_ =nil;
            fetchedResultsControllerLand_ =nil;
        }
          
        updateCheckFinished=YES;
    }else{// apply the additions and updates
        //get the object
        BOOL updating =NO;
        WSLand * newLand = [[WSLand alloc] initWithDictionary:(NSDictionary*)object];
//        if (toBeUpdatedLandID>0 && landIDUpdateFlag ==NO) {
//            toBeUpdatedLandID=0;
//            landIDUpdateFlag=YES;
//        }
        //check if the land is already there and should be deleted first:
        Land * exsistingLand= [self GetLandLocallyWithLandId:[newLand.LandID intValue]];
        if(exsistingLand!= nil){
            [self.managedObjectContext deleteObject:exsistingLand];
            updating = YES;
        }
        
      
        NSLog(@"Adding land %d",[newLand.LandID intValue]);
        Land * newManagedLand = [newLand ToManagedLand:self.managedObjectContext]; 
        
        NSError * error;
        if(![newManagedLand.managedObjectContext save:&error]){
            
            NSLog(@"%@",[error description]);
        } else{
             NSLog(@"Added land %d",[newManagedLand.LandID intValue]);
        }
        if (updating==YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedLand" object:newManagedLand]; 
              NSLog(@"update land notification posted");
        }
      
   
         NSLog(@"new List notification posted");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewList" object:self.landShortList]; 
        
    }

    landID=0;
}
-(void)DataError:(NSError *)error{
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"%@", [error description]);
}



@end
