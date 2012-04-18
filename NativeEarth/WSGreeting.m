//
//  WSGreetings.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSGreeting.h"


@implementation WSGreeting

@synthesize  HelloPronunciation;
@synthesize  RowVersion;
@synthesize GreetingID;
@synthesize  ThankYouPronunciation;
@synthesize WelcomePronunciation;
@synthesize  ActorName;
@synthesize RecordedOn;
@synthesize HelloMIMEType;
@synthesize WelcomeMIMEType;
@synthesize ThankYouMIMEType;
@synthesize Hello;
@synthesize Welcome;
@synthesize ThankYou;



-(void)dealloc{
    [self.HelloPronunciation release];
    [self.RowVersion release];
    [self.GreetingID release];
    [self.ThankYouPronunciation release];
    [self.WelcomePronunciation release];
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
        @try {
            
       
      
        self.GreetingID= [NSNumber numberWithInt:[[greetingDict valueForKey:@"GreetingID"] intValue]];
        int hLen =0;
        hLen=sizeof([greetingDict valueForKey:@"Hello" ]) * [[greetingDict valueForKey:@"Hello" ] count]; 
       self.Hello = [NSData dataWithBytes:[greetingDict valueForKey:@"Hello" ]  length:hLen ];
        self.HelloPronunciation = [[greetingDict valueForKey:@"HelloPronunciation"] description];
        self.HelloMIMEType=[[greetingDict valueForKey:@"HelloMIMEType"] description];

        int wLen =0;
        wLen=sizeof([greetingDict valueForKey:@"Welcome" ]) * [[greetingDict valueForKey:@"Welcome" ] count]; 
        self.Welcome=[NSData dataWithBytes:[greetingDict valueForKey:@"Welcome" ]  length: wLen];
        self.WelcomeMIMEType=[[greetingDict valueForKey:@"WelcomeMIMEType"] description];
        self.WelcomePronunciation=[[greetingDict valueForKey:@"WelcomePronunciation"] description];
        
        
        int tLen =0;
        tLen=sizeof([greetingDict valueForKey:@"ThankYou" ]) * [[greetingDict valueForKey:@"ThankYou" ] count]; 
        self.ThankYou=[NSData dataWithBytes:[greetingDict valueForKey:@"ThankYou" ]  length: tLen];
        self.ThankYouMIMEType=[[greetingDict valueForKey:@"ThankYouMIMEType"] description];
        self.ThankYouPronunciation=[[greetingDict valueForKey:@"ThankYouPronunciation"] description];  
        self.ActorName= [[greetingDict valueForKey:@"ActorName"] description];

  
        self.RowVersion=[[greetingDict valueForKey:@"rowversion"]description];
        
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss ZZZ"];
        
        self.RecordedOn= [dateFormatter dateFromString:[greetingDict valueForKey:@"RecordedOn"]];

        }
        @catch (NSException *exception) {
            NSLog(@"Error:  %@",[exception description]);
        }
        
    } 
    return self;
}    

//converts this object to a managed object.
-(Greeting*) ToManagedGreeting:(NSManagedObjectContext*) context{
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Greeting" inManagedObjectContext:context];
    Greeting * managedGreeting = [[Greeting alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

    managedGreeting.WelcomePronunciation=self.WelcomePronunciation;
    managedGreeting.HelloPronunciation=self.HelloPronunciation;
    managedGreeting.ThankYouPronunciation=self.ThankYouPronunciation;
    managedGreeting.Welcome=self.Welcome;
    managedGreeting.Hello=self.Hello;
    managedGreeting.ThankYou=self.ThankYou;
    managedGreeting.WelcomeMIMEType=self.WelcomeMIMEType;
    managedGreeting.HelloMIMEType=self.HelloMIMEType;
    managedGreeting.ThankYouMIMEType=self.ThankYouMIMEType;
    managedGreeting.RecordedOn= self.RecordedOn;
    managedGreeting.RowVersion=self.RowVersion;
    managedGreeting.ActorName=self.ActorName;
    managedGreeting.GreetingID=self.GreetingID;
    return managedGreeting;
}
@end
