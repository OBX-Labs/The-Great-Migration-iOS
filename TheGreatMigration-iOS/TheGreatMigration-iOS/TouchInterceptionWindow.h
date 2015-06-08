//
//  TouchInterceptionWindow.h
//  WTSWTSTM
//
//  Created by Bruno Nadeau on 10-10-21.
//  Copyright 2010 Obx Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// A TouchInterceptionWindow that catches touches over views that
// would allow it normally.
//
// This was created specifically to catch the touches over a UIWebView
// to be able to swipe the webview's parent view in some direction.
//
// The UIWebView swallows the touches without this.
//
// XXX: This could be improved with a protocol that the views we add
//      to this windows must implement. The protocol could have methods
//		that return YES or NO if a view is ready for touches or not.
//
@interface TouchInterceptionWindow : UIWindow {
    NSMutableArray *views;          //the controlled interception view
    NSMutableArray *frameViews;     //the target interception view
	
@private
    UIView *touchView;  //the view being touched
}

//add an interception view
- (void)addViewForTouchPriority:(UIView*)view;

//add an interception view to control with the frame of another view
- (void)addViewForTouchPriority:(UIView*)view withFrameOf:(UIView*)frameView;

//remove an interception view
- (void)removeViewForTouchPriority:(UIView*)view;

@end
