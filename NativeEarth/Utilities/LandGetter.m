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
@synthesize fetchedResultsControllerLand=fetchedResultsControllerLand_, fetchedResultsControllerShortLands=fetchedResultsControllerShortLands_, managedObjectContext=managedObjectContext_;


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
    landShortList = [[NSMutableArray arrayWithArray:[[self GetLandShortsDictionary] allValues]] retain];
    NSLog(@"initial list:\n");
    NSLog(@"%@",[landShortList description]);
    
    hostReach = [[Reachability reachabilityWithHostName: kHostName] retain];
    [hostReach startNotifier];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
    
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];
    
    self.remoteHostStatus = [hostReach currentReachabilityStatus] ;
    self.internetConnectionStatus= [internetReach currentReachabilityStatus];
    self.wifiConnectionStatus =[wifiReach currentReachabilityStatus];
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
    
    //check for updates
    if (!updateCheckStarted) {
        
        if (remoteHostStatus!=NotReachable) {
            addArray  =[[NSMutableArray alloc] init];
            deleteArray  =[[NSMutableArray alloc] init];
            updateArray  =[[NSMutableArray alloc] init];
            [self GetLandShortsFromWebService]; 
            updateCheckStarted = YES;
            NSLog(@"Update Started\n");
        }
       
    }

	
}


#pragma mark - local data reterival
-(Land *)GetLandWithLandID:(int)landId{
    Land * land = [self GetLandLocallyWithLandID:landId];
    //check for updates here
    [self CheckForLandUpdatesByLandID:[NSNumber numberWithInt: landId]];
    return land;
}
-(Land *)GetLandLocallyWithLandID:(int)landId{
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
    fetchedResultsControllerShortLands_=nil;
    NSLog(@"Retriving list locally:");
    NSError *error;
    if(![[self fetchedResultsControllerShortLands]performFetch:&error]){
        //handle Error
    }
    NSArray * results =[self.fetchedResultsControllerShortLands fetchedObjects];
    int count = [results count];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:count];
    if (self) {
        
        for (NSDictionary * land  in results) {
            LandShort * landShort = [[LandShort alloc] initWithDictionary:land];        
            [dict setObject:landShort forKey:[NSString stringWithFormat:@"%d",[ landShort.landId intValue]]];
            
        }
    }
    [results release];
    return  dict;
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

-(void) GetLandFromWebServiceWithLandID:(NSNumber *)landId{
    //pass landID and language here:
    NSLog(@"getting land %d from web service\n", [landId intValue]);
    NSString *url = [NSString stringWithFormat:@"http://localhost/~ladan/Land%d",[landId intValue]];
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc]init];
    dataGetter.delegate = self;
    
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataGetter GetResultsFromUrl:url];
    
}


-(void)CheckForLandUpdatesByLandID:(NSNumber *)landId{
    if ([updateArray count]>0 &&[updateArray containsObject:landId]) {
        [self GetLandFromWebServiceWithLandID:landId];
    }
}

#pragma mark - NetworkDataGetterDelegate Methods

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
                Land * land = [self GetLandWithLandID:[n intValue]];
                [self.managedObjectContext deleteObject:land];
            }
            
            NSError * error;
            if(![self.managedObjectContext save:&error]){
            }else{
                if  ([deleteArray count]>0) {
                    [landShortList removeAllObjects];
                    [landShortList addObjectsFromArray: [[self GetLandShortsDictionary]allValues]];
                    NSLog(@"%@",[landShortList description]);
                    // Broadcast a notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewList" object:landShortList]; 
                }
            }
        } // end of deletion
         
        
        //get objects to be addes
        if ([addArray count]>0) {
            
            for (NSNumber * n in addArray){
               [self GetLandFromWebServiceWithLandID:n];
            }
            fetchedResultsControllerShortLands_ =nil;
            fetchedResultsControllerLand_ =nil;
        }
          
        updateCheckFinished=YES;
        
        
    }else{// apply the additions and updates
        //get the object
        BOOL updating =NO;
        WSLand * newLand = [[WSLand alloc] initWithDictionary:(NSDictionary*)object];
        
        //check if the land is already there and should be deleted first:
        Land * exsistingLand= [self GetLandLocallyWithLandID:[newLand.LandID intValue]];
        if(exsistingLand!= nil){
            [self.managedObjectContext deleteObject:exsistingLand];
            updating = YES;
        }
        
      
        NSLog(@"Adding land %d",[newLand.LandID intValue]);
        Land * managedLand = [newLand ToManagedLand:self.managedObjectContext]; 
        
        NSError * error;
        if(![managedLand.managedObjectContext save:&error]){
            NSLog(@"%@",[error description]);
        } else{
             NSLog(@"Added land %d",[managedLand.LandID intValue]);
        }
        if (updating==YES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedLand" object:newLand.LandID]; 
              NSLog(@"update notification posted");
        }
      
            [landShortList removeAllObjects];
            [landShortList addObjectsFromArray: [[self GetLandShortsDictionary]allValues]];
            NSLog(@"%@",[landShortList description]);
            // Broadcast a notification
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewList" object:landShortList]; 
        
    }

    
}
-(void)DataError:(NSError *)error{
    // Reference the app's network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"%@", [error description]);
}



@end
