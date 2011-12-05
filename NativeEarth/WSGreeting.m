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
@synthesize  PhraseEnglish;
@synthesize PhraseFrench;
@synthesize  PronounciationEnglish;
@synthesize PronounciationFrench;
@synthesize  Content;
@synthesize ActorName;


-(void)dealloc{
    [self.Language release];
    [self.PhraseEnglish release];
    [self.PhraseFrench release];
    [self.PronounciationEnglish release];
    [self.PronounciationFrench release];
    [self.Content release];
    [super dealloc];
}


-(id) initWithDictionary:(NSDictionary *) greetingDict{
    self=[super init];
    if (self) {
        self.Language = [greetingDict valueForKey:@"Language"];
        self.PhraseEnglish = [greetingDict valueForKey:@"PhraseEnglish"];
        self.PhraseFrench=[greetingDict valueForKey:@"PhraseFrench"];
        self.PronounciationEnglish= [greetingDict valueForKey:@"PronounciationEnglish"];
        self.PronounciationFrench= [greetingDict valueForKey:@"PronounciationFrench"];
        
        NSDictionary * contDict = [greetingDict valueForKey:@"Content"];
        self.Content = [[WSContent alloc]initWithDictionary:contDict];
           }
    return self;

}
-(Greeting*) ToManagedGreeting:(NSManagedObjectContext*) context{
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Greeting" inManagedObjectContext:context];
    Greeting * managedGreeting = [[Greeting alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

    managedGreeting.Language=self.Language;
    managedGreeting.PhraseEnglish=self.PhraseEnglish;
    managedGreeting.PhraseFrench = self.PhraseFrench;
    managedGreeting.PronounciationEnglish=self.PronounciationEnglish;
    managedGreeting.PronounciationFrench=self.PronounciationFrench;
 
    managedGreeting.Content = [self.Content ToManagedContent:context];
    
    return managedGreeting;
}
@end
