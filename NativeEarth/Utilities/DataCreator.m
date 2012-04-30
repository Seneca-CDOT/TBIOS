//
//  DataCreator.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-05-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCreator.h"
#import "Nation.h"
#import "WSNation.h"
#import "Reachability.h"
@implementation DataCreator

-(id) initWithContext:(NSManagedObjectContext*) context{
    [super init];
    managedObjectContext = context;
    return self;
}

-(void) createDataFromWebService{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",kHostName,@"/nations"];
    NetworkDataGetter * dataGetter = [[NetworkDataGetter alloc] init];
    dataGetter.delegate = self;
    [dataGetter GetResultsFromUrl:urlString];
}

-(void)DataUpdate:(id)object{
    NSError *error;
    NSArray * nationArray = (NSArray*)object;
    for (NSDictionary * nationDict  in nationArray) {
        WSNation *wsNation = [[WSNation alloc] initWithDictionary:nationDict];
        [wsNation ToManagedNation:managedObjectContext];
        [wsNation release];
        if(! [managedObjectContext save:&error]){
            NSLog(@"Context save error %@, %@", error, [error userInfo]);
			abort();
        }else{
        NSLog(@"initial data is saved.\n");
        }
    }
    
}
-(void)DataError:(NSError *)error{
     NSLog(@"data error.\n");
}


@end
