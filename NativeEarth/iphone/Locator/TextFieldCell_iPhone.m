//
//  TextFieldCell_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-07-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextFieldCell_iPhone.h"
// cell identifier for this custom cell
NSString* kCellTextField_ID = @"CellTextField_ID";

@implementation TextFieldCell_iPhone
@synthesize textField;
@synthesize  delegate;


//Helper method to create the workout cell from a nib file...
+ (TextFieldCell_iPhone*) createNewTextFieldCellFromNib { 
	NSArray* nibContents = [[NSBundle mainBundle] 
							loadNibNamed:@"TextFieldCell_iPhone" owner:self options:nil]; 
	NSEnumerator *nibEnumerator = [nibContents objectEnumerator]; 
	TextFieldCell_iPhone* tCell = nil; 
	NSObject* nibItem = nil; 
	while ( (nibItem = [nibEnumerator nextObject]) != nil) { 
		if ( [nibItem isKindOfClass: [TextFieldCell_iPhone class]]) { 
			tCell = (TextFieldCell_iPhone*) nibItem; 
			if ([tCell.reuseIdentifier isEqualToString: kCellTextField_ID]) 
				break; // we have a winner 
			else 
				tCell = nil; 
		} 
	} 
	return tCell; 
} 


- (void)dealloc
{

    [self.textField release];
    [super dealloc];
}

#pragma mark - UITextView delegate methods


-(void)textFieldDidBeginEditing:(UITextField *)tf
{
    
    [[self delegate] TextFieldCellEditStarted:self];
}
-(void) textFieldDidEndEditing:(UITextField *)tf{
    
    [[self delegate] TextFieldCellEditDidFinish:self];
}
-(BOOL) textFieldShouldReturn:(UITextField *)tf{
    [tf resignFirstResponder];
    return YES;
}

@end
