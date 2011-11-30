//
//  UIImage+Resizing.m
//  Professors
//
//  Created by Peter McIntyre on 2009/11/29, and refreshed on 2011/02/09.
//  Copyright 2009 Seneca College. All rights reserved.
//

// CATEGORY IMPLEMENTATION
// See http://developer.apple.com/iphone/library/documentation/General/Conceptual/DevPedia-CocoaCore/Category.html 
// Adds a method to the UIImage class without subclassing
// See this source file's implementation (at the bottom) for the CATEGORY DECLARATION

// This is the right way to do this
// Note the pattern...
// 1) Place the category code in its own source code file, named (class)+CategoryName .h and .m
// 2) In the .h interface, import the header for the class that is getting the new method(s) 
// 3) In the .m implementation, import the header for the interface, (class)+CategoryName.h 
// 4) Wherever you use it in other code modules, import the header there too 

#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

// ADDITIONAL METHOD ON THE CLASS
- (UIImage*)scaleToSize:(CGSize)size {
	
	// Begin working with an image context
	UIGraphicsBeginImageContext(size);
	
	// Setup resizing settings
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	// Perform the resizing
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
	
	// Save the results in a new image
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// Shut down the image context
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

@end
