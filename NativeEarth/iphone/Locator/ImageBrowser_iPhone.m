//
//  ImageBrowser_iPhone.m
//  NativeEarth
//
//  Created by Ladan Zahir on 11-06-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageBrowser_iPhone.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageBrowser_iPhone
@synthesize  imageArray;
@synthesize containerView;
@synthesize imageView;
@synthesize  view1;
@synthesize view2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.imageView release];
    [self.imageArray release];
    [self.view1 release];
    [self.view2 release];
    [self.containerView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    currentImageIndex =0;
    [self loadImagesWithDirection:Next];
    view2.hidden=YES;
    [self.containerView addSubview:view1];
    [self.containerView addSubview:view2];
    transitioning=NO;
    
}

-(void) loadImagesWithDirection: (TransitionDirection) direction {
    if ([imageArray count]> currentImageIndex) {
        

        if (view1==nil) {
              view1 =[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:currentImageIndex]];
        
        }else{
            [view1 setImage:[imageArray objectAtIndex:currentImageIndex]];
        }
          

        if (view2==nil) {
        view2 =[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:nextImageIndex]];
        }else{
            [view2 setImage:[imageArray objectAtIndex:nextImageIndex]];
        }
    }
    
}
- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imageView=nil;
    self.containerView= nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)performTransitionWithDirection:(TransitionDirection)direction {
    // First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.75;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	NSString *subtypes[2] = {kCATransitionFromLeft, kCATransitionFromRight};//,kCATransitionFromTop, kCATransitionFromBottom};
	int rnd = random() % 4;
    rnd=0;
	transition.type = types[rnd];
	if(rnd < 3) // if we didn't pick the fade transition, then we need to set a subtype too
	{
        if (direction == Next) {
           transition.subtype = subtypes[1]; 
        }else
        {
            transition.subtype=subtypes[0];
        }
		
	}
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transitioning = YES;
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[containerView.layer addAnimation:transition forKey:nil];
	
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	view1.hidden = YES;
	view2.hidden = NO;
	
	// And so that we will continue to swap between our two images, we swap the instance variables referencing them.

  UIImageView *tmp = view2;
	view2 = view1;
	view1 = tmp;
    
    
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	transitioning = NO;
}

-(IBAction)nextTransition:(id)sender
{
    int size = [imageArray count];
	if(!transitioning)
	{
        if (currentImageIndex<size) {
            
            nextImageIndex = (currentImageIndex+1)%size;
            [self loadImagesWithDirection:Next];
        }

		[self performTransitionWithDirection:Next];
        
            currentImageIndex=(currentImageIndex+1)%[imageArray count];  

        }

}


-(IBAction)previousTransition:(id)sender
{
    int size = [imageArray count];
	if(!transitioning)
	{
  
            nextImageIndex= currentImageIndex-1;
            if (nextImageIndex <0) {
                    nextImageIndex= size -1;
                }
        
            [self loadImagesWithDirection:Previous];
        }
        
		[self performTransitionWithDirection:Previous];
    currentImageIndex--;
    if (currentImageIndex < 0) {
        currentImageIndex = size-1;
    }
}


@end