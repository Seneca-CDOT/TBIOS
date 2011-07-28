//
//  Greetings.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Greetings.h"
#import "Content.h"
#import "Land.h"


@implementation Greetings
@dynamic LandPhrase;
@dynamic HelloPronounciationFrench;
@dynamic LandPronounciationFrench;
@dynamic ActorName;
@dynamic HelloPhrase;
@dynamic ThankYouPhrase;
@dynamic LandPronounciationEnglish;
@dynamic HelloPronounciationEnglish;
@dynamic ThankYouPronounciationEnglish;
@dynamic ThankYouPronounciationFrench;
@dynamic HelloContent;
@dynamic LandContent;
@dynamic ThankYouContent;
@dynamic Land;



//-(id) initWithDictionary:(NSDictionary *) GreetingsDict ForLand:(Land *) land{
//    self=[super init];
//    if (self) {
//    self.Land = land;
//    
//    self.LandPhrase = [GreetingsDict valueForKey:@"LandPhrase"];
//    self.HelloPhrase = [GreetingsDict valueForKey:@"HelloPhrase"];
//    self.ThankYouPhrase = [GreetingsDict valueForKey:@"ThankYouPhrase"];
//    
//    self.LandPronounciationEnglish= [GreetingsDict valueForKey:@"LandPronounciationEnglish"];
//    self.LandPronounciationFrench =[GreetingsDict valueForKey:@"LandPronounciationFrench"];
//    self.HelloPronounciationEnglish=[GreetingsDict valueForKey:@"HelloPronounciationEnglish"];
//    self.HelloPronounciationFrench = [GreetingsDict valueForKey:@"HelloPronounciationFrench"];
//    self.ThankYouPronounciationEnglish =[GreetingsDict valueForKey:@"ThankYouPronounciationEnglish"];
//    self.ThankYouPronounciationFrench =[GreetingsDict valueForKey:@"ThankYouPronounciationFrench"];
//    
//    self.ActorName =[GreetingsDict valueForKey:@"ActorName"];
//   
//        NSDictionary * landContDict = [GreetingsDict valueForKey:@"LandContent"];
//        self.LandContent = [[Content alloc]initWithDictionary:landContDict AsMapOfLand:nil orHelloContentOfGreeting:nil orThankYouContentOfGreeting:nil orLandContentOfGreeting:self];
//        
//        
//        NSDictionary *helloContDict = [GreetingsDict valueForKey:@"HelloContent"];
//        self.HelloContent = [[Content alloc] initWithDictionary:helloContDict AsMapOfLand:nil orHelloContentOfGreeting:self orThankYouContentOfGreeting:nil orLandContentOfGreeting:nil];
//        
//        
//        NSDictionary * thankYouContDict = [GreetingsDict valueForKey:@"ThankYouContent"];
//        self.ThankYouContent = [[Content alloc] initWithDictionary:thankYouContDict AsMapOfLand:nil orHelloContentOfGreeting:nil orThankYouContentOfGreeting:self orLandContentOfGreeting:nil];
//        
//    }
//    return self;
//}
//
@end
