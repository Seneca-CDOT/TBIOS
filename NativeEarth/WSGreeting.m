//
//  WSGreetings.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSGreeting.h"
#import "WSContent.h"

@implementation WSGreeting

@synthesize  Language;
@synthesize  Phrase;
@synthesize  PronounciationEnglish;
@synthesize PronounciationFrench;
@synthesize  Content;
@synthesize ActorName;


-(void)dealloc{
    [self.Language release];
    [self.Phrase release];
    [self.PronounciationEnglish release];
    [self.PronounciationFrench release];
    [self.Content release];
    [super dealloc];
}


-(id) initWithDictionary:(NSDictionary *) greetingDict{
    self=[super init];
    if (self) {
        self.Language = [greetingDict valueForKey:@"Language"];
        self.Phrase = [greetingDict valueForKey:@"Phrase"];
        self.PronounciationEnglish= [greetingDict valueForKey:@"PronounciationEnglish"];
        self.PronounciationFrench= [greetingDict valueForKey:@"PronounciationFrench"];
        
        NSDictionary * contDict = [greetingDict valueForKey:@"Content"];
        self.Content = [[WSContent alloc]initWithDictionary:contDict];
           }
    return self;

}
-(Greeting*) ToManagedGreeting:(NSManagedObjectContext*) context{
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Greetings" inManagedObjectContext:context];
    Greeting * managedGreeting = [[Greeting alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

    managedGreeting.Language=self.Language;
    managedGreeting.Phrase=self.Phrase;
    managedGreeting.PronounciationEnglish=self.PronounciationEnglish;
    managedGreeting.PronounciationFrench=self.PronounciationFrench;
 
    managedGreeting.Content = [self.Content ToManagedContent:context];
    
    return managedGreeting;
}
@end
