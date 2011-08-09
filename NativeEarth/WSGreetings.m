//
//  WSGreetings.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WSGreetings.h"
#import "WSContent.h"

@implementation WSGreetings
@synthesize  Language;
@synthesize  LandPhrase;
@synthesize  ActorName;
@synthesize  HelloPhrase;
@synthesize  ThankYouPhrase;
@synthesize WelcomePhrase;

@synthesize  LandPronounciationEnglish;
@synthesize LandPronounciationFrench;
@synthesize  HelloPronounciationEnglish;
@synthesize HelloPronounciationFrench;
@synthesize  ThankYouPronounciationEnglish;
@synthesize ThankYouPronounciationFrench;
@synthesize WelcomePronounciationEnglish;
@synthesize WelcomePronounciationFrench;

@synthesize  HelloContent;
@synthesize  LandContent;
@synthesize  ThankYouContent;
@synthesize WelcomeContent;

-(void)dealloc{
    [self.Language release];
    [self.LandPhrase release];
    [self.ActorName release];
    [self.HelloPhrase release];
    [self.ThankYouPhrase release];
    [self.WelcomePhrase release];
    [self.LandPronounciationEnglish release];
    [self.LandPronounciationFrench release];
    [self.HelloPronounciationEnglish release];
    [self.HelloPronounciationFrench release];
    [self.ThankYouPronounciationEnglish release];
    [self.ThankYouPronounciationFrench release];
    [self.WelcomePronounciationEnglish release];
    [self.WelcomePronounciationFrench release];
    [self.WelcomeContent release];
    [self.HelloContent release]; 
    [self.LandContent release];
    [self.ThankYouContent release];
    
    [super dealloc];
}


-(id) initWithDictionary:(NSDictionary *) greetingsDict{
    self=[super init];
    if (self) {
        self.Language = [greetingsDict valueForKey:@"Language"];
        self.LandPhrase = [greetingsDict valueForKey:@"LandPhrase"];
        self.HelloPhrase = [greetingsDict valueForKey:@"HelloPhrase"];
        self.ThankYouPhrase = [greetingsDict valueForKey:@"ThankYouPhrase"];
        self.WelcomePhrase = [greetingsDict valueForKey:@"WelcomePhrase"];
         
        self.LandPronounciationEnglish= [greetingsDict valueForKey:@"LandPronounciationEnglish"];
        self.LandPronounciationFrench= [greetingsDict valueForKey:@"LandPronounciationFrench"];

        self.HelloPronounciationEnglish=[greetingsDict valueForKey:@"HelloPronounciationEnglish"];
        self.HelloPronounciationFrench=[greetingsDict valueForKey:@"HelloPronounciationFrench"];
        
        self.ThankYouPronounciationEnglish =[greetingsDict valueForKey:@"ThankYouPronounciationEnglish"];
        self.ThankYouPronounciationFrench =[greetingsDict valueForKey:@"ThankYouPronounciationFrench"];
     
        self.WelcomePronounciationEnglish=[greetingsDict valueForKey:@"WelcomePronounciationEnglish"];
        self.WelcomePronounciationFrench=[greetingsDict valueForKey:@"WelcomePronounciationFrench"];
        
        
        self.ActorName =[greetingsDict valueForKey:@"ActorName"];
        
        NSDictionary * landContDict = [greetingsDict valueForKey:@"LandContent"];
        self.LandContent = [[WSContent alloc]initWithDictionary:landContDict];
        
        
        NSDictionary *helloContDict = [greetingsDict valueForKey:@"HelloContent"];
        self.HelloContent = [[WSContent alloc] initWithDictionary:helloContDict];
        
        
        NSDictionary * thankYouContDict = [greetingsDict valueForKey:@"ThankYouContent"];
        self.ThankYouContent = [[WSContent alloc] initWithDictionary:thankYouContDict];
        
        NSDictionary * welcomeContentDict =[greetingsDict valueForKey:@"WelcomeContent"];
        self.WelcomeContent =[[WSContent alloc]initWithDictionary:welcomeContentDict];
    }
    return self;

}
-(Greetings*) ToManagedGreetings:(NSManagedObjectContext*) context{
    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Greetings" inManagedObjectContext:context];
    Greetings * managedGreetings = [[Greetings alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

    managedGreetings.Language=self.Language;
    
    managedGreetings.LandPhrase=self.LandPhrase;
    managedGreetings.LandPronounciationEnglish=self.LandPronounciationEnglish;
    managedGreetings.LandPronounciationFrench=self.LandPronounciationFrench;
    
    managedGreetings.HelloPhrase=self.HelloPhrase;
    managedGreetings.HelloPronounciationEnglish= self.HelloPronounciationEnglish;
    managedGreetings.HelloPronounciationFrench=self.HelloPronounciationFrench;
    
    managedGreetings.ThankYouPhrase=self.ThankYouPhrase;
    managedGreetings.ThankYouPronounciationEnglish=self.ThankYouPronounciationEnglish;
    managedGreetings.ThankYouPronounciationFrench=self.ThankYouPronounciationFrench;
    
    managedGreetings.WelcomePhrase = self.WelcomePhrase;
    managedGreetings.WelcomePronounciationEnglish=self.WelcomePronounciationEnglish;
    managedGreetings.WelcomePronounciationFrench=self.WelcomePronounciationFrench;
    
    managedGreetings.LandContent = [self.LandContent ToManagedContent:context];
    managedGreetings.HelloContent=[self.HelloContent ToManagedContent:context];
    managedGreetings.ThankYouContent=[self.ThankYouContent ToManagedContent:context];
    managedGreetings.WelcomeContent=[self.WelcomeContent ToManagedContent:context];
    
    return managedGreetings;
}
@end
