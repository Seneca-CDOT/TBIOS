//
//  WSGreetings.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSGreeting.h"


@implementation WSGreeting

@synthesize  HelloPronounciation;
@synthesize  RowVersion;
@synthesize GreetingID;
@synthesize  ThankYouPronounciation;
@synthesize WelcomePronounciation;
@synthesize  ActorName;
@synthesize RecordedOn;
@synthesize HelloMIMEType;
@synthesize WelcomeMIMEType;
@synthesize ThankYouMIMEType;
@synthesize Hello;
@synthesize Welcome;
@synthesize ThankYou;



-(void)dealloc{
    [self.HelloPronounciation release];
    [self.RowVersion release];
    [self.GreetingID release];
    [self.ThankYouPronounciation release];
    [self.WelcomePronounciation release];
    [self.ActorName release];
    [self.RecordedOn release];
    [self.HelloMIMEType release];
    [self.WelcomeMIMEType release];
    [self.ThankYouMIMEType release];
    [self.Hello release];
    [self.Welcome release];
    [self.ThankYou release];
    [super dealloc];
}

//initiates the object with the data comming from the webservice

-(id) initWithDictionary:(NSDictionary *) greetingDict{
    self=[super init];
    if (self) {
        self.HelloPronounciation = [greetingDict valueForKey:@"HelloPronounciation"];
        self.HelloMIMEType=[greetingDict valueForKey:@"HelloMIMEType"];
        self.Hello=[greetingDict valueForKey:@"Hello"];
        
        self.Welcome=[greetingDict valueForKey:@"Welcome"];
        self.WelcomeMIMEType=[greetingDict valueForKey:@"WelcomeMIMEType"];
        self.WelcomePronounciation=[greetingDict valueForKey:@"WelcomePronounciation"];
        self.ThankYou=[greetingDict valueForKey:@"ThankYou"];
        self.ThankYouMIMEType=[greetingDict valueForKey:@"ThankYouMIMEType"];
        self.ThankYouPronounciation=[greetingDict valueForKey:@"ThankYouPronounciation"];  
        
        self.RowVersion=[greetingDict valueForKey:@"RowVersion"];
        self.RecordedOn= [greetingDict valueForKey:@"RecordedOn"];
        self.ActorName= [greetingDict valueForKey:@"ActorName"];
        
    } 
    return self;
}    

//converts this object to a managed object.
-(Greeting*) ToManagedGreeting:(NSManagedObjectContext*) context{
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Greeting" inManagedObjectContext:context];
    Greeting * managedGreeting = [[Greeting alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

    managedGreeting.WelcomePronounciation=self.WelcomePronounciation;
    managedGreeting.HelloPronounciation=self.HelloPronounciation;
    managedGreeting.ThankYouPronounciation=self.ThankYouPronounciation;
    managedGreeting.Welcome=self.Welcome;
    managedGreeting.Hello=self.Hello;
    managedGreeting.ThankYou=self.ThankYou;
    managedGreeting.WelcomeMIMEType=self.WelcomeMIMEType;
    managedGreeting.HelloMIMEType=self.HelloMIMEType;
    managedGreeting.ThankYouMIMEType=self.ThankYouMIMEType;
    managedGreeting.RecordedOn=self.RecordedOn;
    managedGreeting.RowVersion=self.RowVersion;
    
    return managedGreeting;
}
@end
