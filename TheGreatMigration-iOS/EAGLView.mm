/*
 
 File: EAGLView.m
 
 Abstract: The EAGLView class is a UIView subclass that renders OpenGL scene.
 If the current hardware supports OpenGL ES 2.0, it draws using OpenGL ES 2.0;
 otherwise it draws using OpenGL ES 1.1.
 
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */

#import "EAGLView.h"

#import "ES1Renderer.h"
#import <OBXKit/AppDelegate.h>

#import <CoreFoundation/CFDictionary.h>

#define MIN_SWIPE_LENGTH 100
#define MAX_SWIPE_LENGTH 800
#define SWIPE_MAX_TIME 0.5
#define TAP_MAX_TIME 0.2
#define EDGE_WIDTH 50

@implementation EAGLView

@synthesize animating;
@dynamic animationFrameInterval;

// You must implement this method
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id) initWithFrame:(CGRect)frame
{    
    if ((self = [super initWithFrame:frame]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
        
        [self setContentScaleFactor:[[UIScreen mainScreen] scale]]; // sets the scale based on the device
        [eaglLayer setContentsScale:[self contentScaleFactor]];
        NSLog(@"content scale: %f", [self contentScaleFactor]);
        
        
        windowFrame = CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        NSLog(@"Window Frame: %f %f frame:%f %f", windowFrame.size.width, windowFrame.size.height, frame.size.width, frame.size.height);
        touchPointers = [[NSMutableArray alloc] initWithCapacity:1];
        touchLocations = [[NSMutableArray alloc] initWithCapacity:1];
        for (int i=0; i<1; i++) {
            [touchPointers insertObject:[NSNull null] atIndex:i];
            [touchLocations insertObject:[NSNull null] atIndex:i];
        }
        
        
        /* SET SCALING FOR THE DISPLAY*/
        
        int w = 320;
        int h = 480;
        
        float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
        // You can't detect screen resolutions in pre 3.2 devices, but they are all 320x480
        if (ver >= 3.2f)
        {
            UIScreen* mainscr = [UIScreen mainScreen];
            w = mainscr.currentMode.size.width;
            h = mainscr.currentMode.size.height;
        }
        
        /*if ([[UIScreen mainScreen] scale] > 1.9) // Retina display detected
        {
            // Set contentScale Factor to 2
            //self.contentScaleFactor = 2.0;
            // Also set our glLayer contentScale Factor to 2
            CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
            eaglLayer.contentsScale=[[UIScreen mainScreen] scale]; //new line
        }*/
        
        
        
        //(windowFrame.size.width - 50)
        lbl_frameRate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)]; //CGRectMake(, (windowFrame.size.height - 20), 50, 20)
        [lbl_frameRate setTextColor:[UIColor orangeColor]];
        [lbl_frameRate setBackgroundColor:[UIColor clearColor]];
        [lbl_frameRate setFont:[UIFont boldSystemFontOfSize:15]];
        [lbl_frameRate setTextAlignment:UITextAlignmentCenter];
        [self addSubview:lbl_frameRate];
        [lbl_frameRate release];
        
        
		renderer = [[ES1Renderer alloc] initwithFrame:self.frame];
					
        if (!renderer)
        {
            [self release];
            return nil;
        }
		
        
        [renderer setFrame:self.frame];
        
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
			displayLinkSupported = TRUE;
        
        
        hidFirstInfo = NO;
        firstTouch = nil;
        
    }
	
    return self;
}


- (void) drawView:(id)sender
{
    NSDate *startDate = [NSDate date];
    [renderer render];
    if (_DEBUG) {
        [self getFrameRate:[[NSDate date] timeIntervalSinceDate:startDate]];
    }
}

- (UIImage*)screenCapture
{
    //grab screen for screen shot
    return [renderer glToUIImage];
}

- (void)getFrameRate:(float)withInterval
{	
	lbl_frameRate.text = [NSString stringWithFormat:@"%.1f", 60-(withInterval*1000)];	
}

- (void) layoutSubviews
{
	[renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}



- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
    
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void) startAnimation
{
    //NSLog(@"StartAnimation");
	if (!animating)
	{
		if (displayLinkSupported)
		{
			// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
			// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
			// not be called in system versions earlier than 3.1.
			
			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
			[displayLink setFrameInterval:animationFrameInterval];
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
		else
            if (RESUME_APP) {
                animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawViewResume:) userInfo:nil repeats:TRUE];
            } else
                animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:TRUE];
		
		animating = TRUE;
	}
}

- (void)stopAnimation
{
	if (animating)
	{
		if (displayLinkSupported)
		{
			[displayLink invalidate];
			displayLink = nil;
		}
		else
		{
			[animationTimer invalidate];
			animationTimer = nil;
		}
		
		animating = FALSE;
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //NSEnumerator *enumerator = [[event allTouches] objectEnumerator];
    NSEnumerator *enumerator = [touches objectEnumerator];
    UITouch *touch;
    while ((touch = [enumerator nextObject]))
        [self addTouchId:touch];
    
    [renderer touchesBegan:touchLocations];
    
    [super touchesBegan:touches withEvent:event];
    
    //TheGreatMigration_iOSAppDelegate *app = [[UIApplication sharedApplication] delegate];
        
    //if we aren't touching the infoview
    //if (!(CGRectContainsPoint(app.mainView.infoView.view.frame, touchLocation)))
    //{
    //then move words
    //        [currentText setFocusForCoordinates:CGPointMake(touchLocation.x, 768.0f-touchLocation.y)];
    //        [currentText setPositionWithCoordinates:CGPointMake(touchLocation.x, 768.0f-touchLocation.y)];
    //    touchLocation.x *= self.contentScaleFactor;
    //    touchLocation.y = [UIScreen mainScreen].currentMode.size.width-touchLocation.y*self.contentScaleFactor;
    //NSLog(@"%f,%f",touchLocation.x,touchLocation.y);
    
    //if this is the initial touch
    //hide the info view
    //        if(!initialTouch)
    //        {
    //            if(app.mainView.infoView.isVisible)
    //                [app.mainView.infoView toggleView];
    //            
    //            initialTouch = YES;
    //        }
    
    //swipe start location
    //        swipeStart = [[touches anyObject] locationInView:self];
    
    //save the touch start time to detect swipe
    //        touchBeganTime = touch.timestamp;
    //}

}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSEnumerator *enumerator = [[event allTouches] objectEnumerator];
    NSEnumerator *enumerator = [touches objectEnumerator];
    UITouch *touch;
    while ((touch = [enumerator nextObject]))
        [self updateTouch:touch];

    //pass to renderer
    [renderer touchesMoved:touchLocations];

    //TheGreatMigration_iOSAppDelegate *app = [[UIApplication sharedApplication] delegate];

    //if we aren't moving over the infoview
//    if (!(CGRectContainsPoint(app.mainView.infoView.view.frame, moveLocation)))
//    touchLocation.x *= self.contentScaleFactor;
//    touchLocation.y *= self.contentScaleFactor;

//    moveLocation.x *= self.contentScaleFactor;
//    moveLocation.y = [UIScreen mainScreen].currentMode.size.width-moveLocation.y*self.contentScaleFactor;
//    NSLog(@"%f,%f",touchLocation.x,touchLocation.y);

//        [currentText setPositionWithCoordinates:CGPointMake(moveLocation.x, 768.0f-moveLocation.y)];
//    else
//        [currentText stopTargetMove];

}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{ 
    
    NSEnumerator *enumerator = [touches objectEnumerator];
    UITouch *touch;
    while ((touch = [enumerator nextObject]))        
      [self removeTouchId:touch];
    
    //ONE TOUCH
    //[touchPointers replaceObjectAtIndex:0 withObject:[NSNull null]];
    //[touchLocations replaceObjectAtIndex:0 withObject:[NSNull null]];

    //pass to renderer
    [renderer touchesEnded:touchLocations];

    //[currentText stopTargetMove];
	//[self setAutoplayTimer];
	
    //check for swipe
    //if (touch.timestamp-touchBeganTime < SWIPE_MAX_TIME)
    //    [self endSwipe:[[touches anyObject] locationInView:self]];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [[event allTouches] anyObject];
    NSEnumerator *enumerator = [touches objectEnumerator];
    UITouch *touch;
    
    while ((touch = [enumerator nextObject]))        
        [self removeTouchId:touch];
    
    //pass to renderer
    [renderer touchesCancelled];
    
    //    [currentText stopTargetMove];
	//[self setAutoplayTimer];
	
    //check for swipe
    //if (touch.timestamp-touchBeganTime < SWIPE_MAX_TIME)
    //    [self endSwipe:[[touches anyObject] locationInView:self]];
}

-(void)resetTouches
{
    [renderer resetTouches];
}



// MULTI TOUCH TRACKING

-(void) updateTouch:(UITouch*)touch
{
    int i = [self getTouchId:touch];
    
    if(i>=0) {
        //convert the UITouch location to the OpenGL location
        //TODO view bounds should be stored in the init, not every touch
        CGPoint touchGL = [touch locationInView:self];
        touchGL.y = ([self bounds].size.height - touchGL.y)*self.layer.contentsScale;
        touchGL.x *= self.layer.contentsScale;
        
        [touchLocations replaceObjectAtIndex:i
                                  withObject:[NSValue valueWithCGPoint:touchGL]];
        
        [touchLocations replaceObjectAtIndex:i 
                                  withObject:[NSValue valueWithCGPoint:touchGL]];
    }
    
}

- (int) getTouchId:(UITouch*)touch
{
    for (int i=0; i<[touchPointers count]; i++)
        if([touchPointers objectAtIndex:i] == touch)
            return i;
    
    return -1;
}

- (int) addTouchId:(UITouch*)touch
{
    //NSLog(@"Add touch id");
    
    //convert the UITouch location to the OpenGL location
    //TODO view bounds should be stored in the init, not every touch
    CGPoint touchGL = [touch locationInView:self];
    touchGL.y = ([self bounds].size.height - touchGL.y)*self.layer.contentsScale;
    touchGL.x *= self.layer.contentsScale;
    
    //check if it's the first touch we add
    if (firstTouch == nil) {
        //save a pointer to the touch
        firstTouch = touch;
        
        //save the touch start time to detect swipe
        touchBeganTime = touch.timestamp;  
        
        //keep track of it to know if we need to toggle info on single click
        lastTap = touchGL;
    }
    
    /*
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"exhibition_preference"])
    {
        //check if we need to hide the info view the first time we interact
        if (!hidFirstInfo) {
            //get the app delegate to check info view status
            TheGreatMigration_iOSAppDelegate* delegate = (TheGreatMigration_iOSAppDelegate*)[UIApplication sharedApplication].delegate;
            
            //flag as hidden once
            hidFirstInfo = YES;
        }
        else {
            lastTap = touchGL;
        }
    }
     */
    
    //add to touch array
    for (int i=0; i<[touchPointers count]; i++)
    {
        id value = [touchPointers objectAtIndex:i];
        
        if(value == [NSNull null])
        {
            [touchPointers replaceObjectAtIndex:i withObject:touch];
            [touchLocations replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:touchGL]];

            return i;
        }
    }
    
    return -1;
}

-(void) removeTouchId:(UITouch*)touch
{
    //check if this is our first touch
    //to detect taps for the info view
    if (firstTouch == touch) {
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        //convert the UITouch location to the OpenGL location
        //TODO view bounds should be stored in the init, not every touch
        CGPoint touchGL = [touch locationInView:self];
        touchGL.y = ([self bounds].size.height - touchGL.y)*self.layer.contentsScale;
        touchGL.x *= self.layer.contentsScale;
        
        firstTouch = nil;
    }
    
    //remove touches
    for (int i=0; i<[touchPointers count]; i++)
        if([touchPointers objectAtIndex:i] == touch)
        {
            [touchPointers replaceObjectAtIndex:i withObject:[NSNull null]];
            [touchLocations replaceObjectAtIndex:i withObject:[NSNull null]];
            break;
        }
}

- (BOOL)ptNearEdges:(CGPoint) pt
{
    //return true if point is in the edge defined by EDGE_WIDTH
	CGSize size = [self bounds].size;
	return (pt.x < EDGE_WIDTH || size.width-pt.x < EDGE_WIDTH ||
			pt.y < EDGE_WIDTH || size.height-pt.y < EDGE_WIDTH);
}

// END MULTI TOUCH TRACKING

- (void) dealloc
{
    [renderer release];
	
    [super dealloc];
}

@end
