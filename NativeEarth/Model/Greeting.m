//
//  Greeting.m
//  NativeEarth
//
//  Created by Ladan Zahir on 12-04-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Greeting.h"
#import "Nation.h"


@implementation Greeting
@dynamic ThankYou;
@dynamic GreetingID;
@dynamic GoodByePronunciation;
@dynamic GoodBye;
@dynamic ThankYouMIMEType;
@dynamic ActorName;
@dynamic HelloMIMEType;
@dynamic Hello;
@dynamic RowVersion;
@dynamic HelloPronunciation;
@dynamic ThankYouPronunciation;
@dynamic GoodByeMIMEType;
@dynamic RecordedOn;
@dynamic Nations;

- (void)addNationsObject:(Nation *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Nations"] addObject:value];
    [self didChangeValueForKey:@"Nations" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeNationsObject:(Nation *)value {
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
