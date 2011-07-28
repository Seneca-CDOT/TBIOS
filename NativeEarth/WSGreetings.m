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
@synthesize  LandPhrase;
@synthesize  HelloPronounciationFrench;
@synthesize  LandPronounciationFrench;
@synthesize  ActorName;
@synthesize  HelloPhrase;
@synthesize  ThankYouPhrase;
@synthesize  LandPronounciationEnglish;
@synthesize  HelloPronounciationEnglish;
@synthesize  ThankYouPronounciationEnglish;
@synthesize  ThankYouPronounciationFrench;
@synthesize  HelloContent;
@synthesize  LandContent;
@synthesize  ThankYouContent;

-(void)dealloc{
    [self.LandPhrase release];
    [self.HelloPronounciationFrench release];
    [self.LandPronounciationFrench release];
    [self.ActorName release];
    [self.HelloPhrase release];
    [self.ThankYouPhrase release];
    [self.LandPronounciationEnglish release];
    [self.HelloPronounciationEnglish release];
    [self.ThankYouPronounciationEnglish release];
    [self.ThankYouPronounciationFrench release];
    [self.HelloContent release]; 
    [self.LandContent release];
    [self.ThankYouContent release];
    
    [super dealloc];
}


-(id) initWithDictionary:(NSDictionary *) greetingsDict{
    self=[super init];
    if (self) {
        
        self.LandPhrase = [greetingsDict valueForKey:@"LandPhrase"];
        self.HelloPhrase = [greetingsDict valueForKey:@"HelloPhrase"];
        self.ThankYouPhrase = [greetingsDict valueForKey:@"ThankYouPhrase"];
        
        self.LandPronounciationEnglish= [greetingsDict valueForKey:@"LandPronounciationEnglish"];
        self.LandPronounciationFrench =[greetingsDict valueForKey:@"LandPronounciationFrench"];
        self.HelloPronounciationEnglish=[greetingsDict valueForKey:@"HelloPronounciationEnglish"];
        self.HelloPronounciationFrench = [greetingsDict valueForKey:@"HelloPronounciationFrench"];
        self.ThankYouPronounciationEnglish =[greetingsDict valueForKey:@"ThankYouPronounciationEnglish"];
        self.ThankYouPronounciationFrench =[greetingsDict valueForKey:@"ThankYouPronounciationFrench"];
        
        self.ActorName =[greetingsDict valueForKey:@"ActorName"];
        
        NSDictionary * landContDict = [greetingsDict valueForKey:@"LandContent"];
        self.LandContent = [[WSContent alloc]initWithDictionary:landContDict];
        
        
        NSDictionary *helloContDict = [greetingsDict valueForKey:@"HelloContent"];
        self.HelloContent = [[WSContent alloc] initWithDictionary:helloContDict];
        
        
        NSDictionary * thankYouContDict = [greetingsDict valueForKey:@"ThankYouContent"];
        self.ThankYouContent = [[WSContent alloc] initWithDictionary:thankYouContDict];
        
    }
    return self;

}
@end
