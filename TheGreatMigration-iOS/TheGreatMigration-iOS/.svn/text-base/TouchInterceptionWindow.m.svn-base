//
//  TouchInterceptionWindow.m
//  WTSWTSTM
//
//  Created by Bruno Nadeau on 10-10-21.
//  Copyright 2010 Obx Labs. All rights reserved.
//

#import "TouchInterceptionWindow.h"

@implementation TouchInterceptionWindow

- (void)dealloc {
    if ( views ) [views release];
    if ( frameViews ) [frameViews release];
    [super dealloc];
}

- (void)addViewForTouchPriority:(UIView*)view {
    //add the view using it's own frame
    [self addViewForTouchPriority:view withFrameOf:view];
}

- (void)addViewForTouchPriority:(UIView*)view withFrameOf:(UIView*)frameView {
    if ( !views ) views = [[NSMutableArray alloc] init];
    [views addObject:view];

    if ( !frameViews ) frameViews = [[NSMutableArray alloc] init];
    [frameViews addObject:frameView];

}

- (void)removeViewForTouchPriority:(UIView*)view {
    if ( !views ) return;
    
    int index = [views indexOfObject:view];
    [views removeObject:view];
    [frameViews removeObjectAtIndex:index];
}

- (void)sendEvent:(UIEvent *)event {
	//get a touch
    UITouch *touch = [[event allTouches] anyObject];
	
	//check which phase the touch is at, and process it
    if (touch.phase == UITouchPhaseBegan) {
        for ( UIView *frameView in frameViews ) {
            //if ( CGRectContainsPoint([frameView frame], [touch locationInView:[frameView superview]]) ) {
            if ( ![frameView isHidden] && [frameView pointInside:[touch locationInView:frameView] withEvent:event] ) {
                touchView = [views objectAtIndex:[frameViews indexOfObject:frameView]];
                [touchView touchesBegan:[event allTouches] withEvent:event];
                break;
            }
        }        
    }
	else if (touch.phase == UITouchPhaseMoved) {
        if ( touchView ) {
            [touchView touchesMoved:[event allTouches] withEvent:event];
            return;
        }
	}
	else if (touch.phase == UITouchPhaseCancelled) {
        if ( touchView ) {
            [touchView touchesCancelled:[event allTouches] withEvent:event];
            touchView = nil;
        }
	}
	else if (touch.phase == UITouchPhaseEnded) {
        if ( touchView ) {
            [touchView touchesEnded:[event allTouches] withEvent:event];
            touchView = nil;
        }
    }

    //we need to send the message to the super for the
	//text overlay to work (holding touch to show copy/paste)
    [super sendEvent:event];
}

@end