//
//  GreetingCell_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-12-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GreetingCell_iPhone.h"

NSString * kCellGreeting_ID = @"CellGreeting_ID";

@implementation GreetingCell_iPhone
@synthesize lblPhrase;
@synthesize  lblPronounciation;
@synthesize  btnPlay;

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

- (void)dealloc
{
    [self.lblPronounciation release];
    [self.lblPhrase release];
    [self.btnPlay release];
    [super dealloc];
}





@end
