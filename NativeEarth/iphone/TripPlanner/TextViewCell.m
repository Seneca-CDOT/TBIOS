//
//  TextViewCell.m
//  PTLog
//
//  Created by Ellen Miner on 2/20/09.
//  Copyright 2009 RaddOnline. All rights reserved.
//

#import "TextViewCell.h"

// cell identifier for this custom cell
NSString* kCellTextView_ID = @"CellTextView_ID";

@implementation TextViewCell
@synthesize textView;
@synthesize  delegate;

//Helper method to create the workout cell from a nib file...
+ (TextViewCell*) createNewTextCellFromNib { 
	NSArray* nibContents = [[NSBundle mainBundle] 
							loadNibNamed:@"TextViewCell" owner:self options:nil]; 
	NSEnumerator *nibEnumerator = [nibContents objectEnumerator]; 
	TextViewCell* tCell = nil; 
	NSObject* nibItem = nil; 
	while ( (nibItem = [nibEnumerator nextObject]) != nil) { 
		if ( [nibItem isKindOfClass: [TextViewCell class]]) { 
			tCell = (TextViewCell*) nibItem; 
			if ([tCell.reuseIdentifier isEqualToString: kCellTextView_ID]) 
				break; // we have a winner 
			else 
				tCell = nil; 
		} 
	} 
	return tCell; 
} 




- (void)dealloc
{
    [self.textView release];
    [super dealloc];
}

#pragma mark UITextView delegate methods

- (void)textViewDidBeginEditing:(UITextView *)tv
{
	  [[self delegate] TextViewCellEditStarted:self];
}
-(void) textViewDidEndEditing:(UITextView *)tv
{
    
    [[self delegate] TextViewCellEditDidFinish:self];
}
-(void) textViewDidChange:(UITextView *)textView{
    self.selected = NO;
}

@end
