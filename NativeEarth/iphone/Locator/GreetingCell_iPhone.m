//
//  GreetingCell_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-12-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GreetingCell_iPhone.h"
#import "Content.h"
NSString * kCellGreeting_ID = @"CellGreeting_ID";

@implementation GreetingCell_iPhone
@synthesize lblPhrase;
@synthesize  lblPronounciation;
@synthesize  btnPlay;
@synthesize greeting;
@synthesize cellSoundPlayer;

+ (GreetingCell_iPhone*) createNewGretingCellFromNib{
    NSArray* nibContents = [[NSBundle mainBundle] 
							loadNibNamed:@"GreetingCell_iPhone" owner:self options:nil]; 
	NSEnumerator *nibEnumerator = [nibContents objectEnumerator]; 
	GreetingCell_iPhone* gCell = nil; 
	NSObject* nibItem = nil; 
	while ( (nibItem = [nibEnumerator nextObject]) != nil) { 
		if ( [nibItem isKindOfClass: [GreetingCell_iPhone class]]) { 
			gCell = (GreetingCell_iPhone*) nibItem; 
			if ([gCell.reuseIdentifier isEqualToString: kCellGreeting_ID]) 
				break; // we have a winner 
			else 
				gCell = nil; 
		} 
	} 
	return gCell; 
}

-(void) setGreeting:(Greeting *)greetingValue
{
    locale = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    if (greetingValue != greeting)
    {
        [greetingValue retain];
        [greeting release];
        greeting = greetingValue;
        if ( [locale compare:@"fr"]==0){
           self.lblPhrase.text=greetingValue.PhraseFrench;
            self.lblPronounciation.text=greetingValue.PronounciationFrench;
        }else{
            self.lblPhrase.text=greetingValue.PhraseEnglish;
            self.lblPronounciation.text=greetingValue.PronounciationEnglish;
         }
    }
}

- (void)dealloc
{
    [self.cellSoundPlayer release];
    [self.greeting release];
    [self.lblPronounciation release];
    [self.lblPhrase release];
    [self.btnPlay release];
    [super dealloc];
}

-(IBAction)playSound:(id)sender{
    Content * content =self.greeting.Content;
    NSString * urlString  = [NSString stringWithFormat:@"%@%@%@", content.DataLocation ,@".",content.MIMEType];
    
    NSURL * URL = [NSURL URLWithString:urlString];
    NSData * data = [NSData dataWithContentsOfURL:URL];
    
    
    
    NSError *error = nil;
    
    // Instantiates the AVAudioPlayer object, initializing it with the sound
    cellSoundPlayer= [[AVAudioPlayer alloc] initWithData:data error:&error];	
    
    
    // "Preparing to play" attaches to the audio hardware and ensures that playback
    //		starts quickly when the user taps Play
    [cellSoundPlayer prepareToPlay];
    //[appSoundPlayer setVolume: 1.0];
    // [appSoundPlayer setDelegate: self];
    [cellSoundPlayer play];

}




@end
