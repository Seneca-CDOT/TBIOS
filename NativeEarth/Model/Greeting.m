//
//  Greeting.m
//  NativeEarth
//
//  Created by Ladan Zahir on 12-03-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Greeting.h"


@implementation Greeting
@dynamic HelloPronounciation;
@dynamic RowVersion;
@dynamic GreetingID;
@dynamic ThankYouPronounciation;
@dynamic WelcomePronounciation;
@dynamic ActorName;
@dynamic RecordedOn;
@dynamic HelloMIMEType;
@dynamic WelcomeMIMEType;
@dynamic ThankYouMIMEType;
@dynamic Hello;
@dynamic Welcome;
@dynamic ThankYou;
@dynamic Nations;

- (void)addNationsObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Nations"] addObject:value];
    [self didChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeNationsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Nations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Nations"] removeObject:value];
    [self didChangeValueForKey:@"Nations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addNations:(NSSet *)value {    
    [self willChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Nations"] unionSet:value];
    [self didChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeNations:(NSSet *)value {
    [self willChangeValueForKey:@"Nations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Nations"] minusSet:value];
    [self didChangeValueForKey:@"Nations" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
