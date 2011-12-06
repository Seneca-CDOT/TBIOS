
/*
     File: RootViewController.m
 Abstract: View controller to manage a scrollview that displays a zoomable image.
 
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "ScreenshotBrowser.h"
#import "Map.h"
#import "Land.h"
#import "NativeEarthAppDelegate_iPhone.h"
#define ZOOM_VIEW_TAG 100


#define THUMB_HEIGHT 150
#define THUMB_V_PADDING 10
#define THUMB_H_PADDING 10
#define CREDIT_LABEL_HEIGHT 20

#define AUTOSCROLL_THRESHOLD 30
typedef enum{forSavedMaps,forImages} usageType;

@interface ScreenshotBrowser (ViewHandlingMethods)
- (void)toggleThumbView;
- (void)pickMap:(Map *)map;
- (void)createThumbScrollViewIfNecessary;
- (void)createSlideUpViewIfNecessary;
-(void) removeMessageLableFromScreen;
-(void) addMessageLableToScreen;
@end


@implementation ScreenshotBrowser
@synthesize maps,currentMap;
-(void)viewDidLoad{
    UIBarButtonItem * deleteButton= [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Delete", @"Delete")  style:UIBarButtonItemStylePlain target:self action:@selector(deleteImage:)];
    
    deleteButton.enabled=YES;
    
    self.navigationItem.rightBarButtonItem = deleteButton;
}

-(void)viewWillDisappear:(BOOL)animated{
    NativeEarthAppDelegate_iPhone *appDelegate = (NativeEarthAppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    [appDelegate.landGetter SaveData];
}

- (void)loadView {
    [super loadView];
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
   
    [imageScrollView setBackgroundColor:[UIColor blackColor]];
    [imageScrollView setDelegate:self];
    [imageScrollView setBouncesZoom:YES];
    [[self view] addSubview:imageScrollView];
    
    [self pickMap:[self.maps objectAtIndex:0]];
    [self addMessageLableToScreen];
}

- (void)dealloc {
    [currentMap release];
    [maps release];
    [imageScrollView release];
    [slideUpView release];
    [messageView release];
    [thumbScrollView release];
    [super dealloc];
}


#pragma mark TapDetectingImageViewDelegate methods

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
    // Single tap shows or hides drawer of thumbnails.
    [self toggleThumbView];
}

#pragma mark ThumbImageViewDelegate methods

- (void)thumbImageViewWasTapped:(ThumbImageView *)tiv {
    [self pickMap:[tiv map]];
    [self toggleThumbView];
}

- (void)thumbImageViewStartedTracking:(ThumbImageView *)tiv {
    [thumbScrollView bringSubviewToFront:tiv];
}


- (void)thumbImageViewStoppedTracking:(ThumbImageView *)tiv {
    // if the user lets go of the thumb image view, stop autoscrolling
    [autoscrollTimer invalidate];
    autoscrollTimer = nil;
}

#pragma mark View handling methods

- (void)toggleThumbView {
    [self createSlideUpViewIfNecessary]; // no-op if slideUpView has already been created
    CGRect frame = [slideUpView frame];
    if (thumbViewShowing) {
        [self addMessageLableToScreen];
       
        frame.origin.y += (frame.size.height);
    } else {
         [self removeMessageLableFromScreen];
        frame.origin.y -= (frame.size.height);
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [slideUpView setFrame:frame];
    [UIView commitAnimations];
    
    thumbViewShowing = !thumbViewShowing;
}

- (void)pickMap:(Map*)map {
        
    // first remove previous image view, if any
    [[imageScrollView viewWithTag:ZOOM_VIEW_TAG] removeFromSuperview];
    UIImage *image = map.Image;
    TapDetectingImageView *zoomView = [[TapDetectingImageView alloc] initWithImage:image];
    [zoomView setDelegate:self];
    [zoomView setTag:ZOOM_VIEW_TAG];
    [imageScrollView addSubview:zoomView];
    [imageScrollView setContentSize:[zoomView frame].size];
    [zoomView release];
    [imageScrollView setContentOffset:CGPointZero];
    self.currentMap= map;
}


- (void)createSlideUpViewIfNecessary {
    
    if (!slideUpView) {
        
        [self createThumbScrollViewIfNecessary];

        CGRect bounds = [[self view] bounds];
        float thumbHeight = [thumbScrollView frame].size.height;
        float labelHeight = CREDIT_LABEL_HEIGHT;

        // create label giving credit for images
        UILabel *creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, thumbHeight, bounds.size.width, labelHeight)];
        [creditLabel setBackgroundColor:[UIColor clearColor]];
        [creditLabel setTextColor:[UIColor whiteColor]];
        [creditLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:14]];
        [creditLabel setText:NSLocalizedString(@"Map Screenshots", @"Map Screenshots")];
        [creditLabel setTextAlignment:UITextAlignmentCenter];        
        
        // create container view that will hold scroll view and label
        CGRect frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds), bounds.size.width, thumbHeight + labelHeight);
        slideUpView = [[UIView alloc] initWithFrame:frame];
        [slideUpView setBackgroundColor:[UIColor blackColor]];
        [slideUpView setOpaque:NO];
        [slideUpView setAlpha:0.75];
        [[self view] addSubview:slideUpView];
        
        // add subviews to container view
        [slideUpView addSubview:thumbScrollView];
        [slideUpView addSubview:creditLabel];
       // [slideUpView addSubview:messageLabel];
        [creditLabel release];        
    }    
}

- (void)createThumbScrollViewIfNecessary {
    
    if (!thumbScrollView) {        
        
        float scrollViewHeight = THUMB_HEIGHT + THUMB_V_PADDING;
        float scrollViewWidth  = [[self view] bounds].size.width;
        thumbScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, scrollViewWidth, scrollViewHeight)];
        [thumbScrollView setCanCancelContentTouches:NO];
        [thumbScrollView setClipsToBounds:NO];
        
        // now place all the thumb views as subviews of the scroll view 
        // and in the course of doing so calculate the content width
        float xPosition = THUMB_H_PADDING;
        for (Map *map in self.maps) {
            UIImage *thumbImage = map.Thumb;
            if (thumbImage) {
                ThumbImageView *thumbView = [[ThumbImageView alloc] initWithImage:thumbImage];
                [thumbView setDelegate:self];
                [thumbView setMap:map];
                CGRect frame = [thumbView frame];
                frame.origin.y = THUMB_V_PADDING;
                frame.origin.x = xPosition;
                [thumbView setFrame:frame];
                [thumbView setHome:frame];
                [thumbScrollView addSubview:thumbView];
                [thumbView release];
                xPosition += (frame.size.width + THUMB_H_PADDING);
            }
        }
        [thumbScrollView setContentSize:CGSizeMake(xPosition, scrollViewHeight)];
    }    
}

-(void)deleteImage:(id)sender{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Do you want to delete the map?",@"Do you want to delete the map?") message:NSLocalizedString(@"",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"No",@"No") otherButtonTitles: NSLocalizedString(@"Yes",@"Yes"),nil];
    [alert show];
    [alert release];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//YES
    {
        if (thumbViewShowing) {
            [self toggleThumbView];
        }
          Land * land = self.currentMap.Land;
        [land removeMapObject:self.currentMap];
        int index= [self.maps indexOfObject:currentMap];
        [self.maps removeObject:currentMap];
        
        //thumbview should be reloaded here
        thumbScrollView=nil;
        slideUpView = nil;
        //decide what image to bring to front:
        if ([self.maps count]>0) {
   
            if (index<[self.maps count]-1) {
             [self pickMap:[maps objectAtIndex:index]];
            }else if(index==[self.maps count]-1){
                     [self pickMap:[maps objectAtIndex:index]];
            }else{
                [self pickMap:[maps objectAtIndex:index-1]];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}
#pragma mark MessageView methods

-(void) addMessageLableToScreen{
    if (messageView==nil) {
        
    CGRect bounds= [self.view bounds];
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 20)];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setFont:[UIFont fontWithName:@"AmericanTypewriter" size:14]];
    [messageLabel setText:NSLocalizedString(@"Tap on screen to bring up the browser.", @"Tap on screen to bring up the browser.")];
    [messageLabel setTextAlignment:UITextAlignmentCenter];        
    
    // create container view that will hold scroll view and label
    CGRect frame = CGRectMake(0, 44, bounds.size.width, 20);
    messageView = [[UIView alloc] initWithFrame:frame];
    [messageView setBackgroundColor:[UIColor blackColor]];
    [messageView setOpaque:NO];
    [messageView setAlpha:0.55];
    [[self view] addSubview:messageView];
    
    // add subviews to container view
    
    [messageView addSubview:messageLabel];
    
    [messageLabel release];     
    } else
    {
        CGRect frame = [messageView frame];
        
        frame.origin.y += 20;
               
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [messageView setFrame:frame];
        [UIView commitAnimations];
        
    }

}

-(void) removeMessageLableFromScreen{
    if (messageView!=nil) {
        
        CGRect frame = [messageView frame];
        
        frame.origin.y -= 20;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [messageView setFrame:frame];
        [UIView commitAnimations];
        

    }
}

@end
