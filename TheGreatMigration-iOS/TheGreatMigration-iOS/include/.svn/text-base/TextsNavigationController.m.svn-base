//
//  TextsNavigationController.m
//  WTSWTSTM
//
//  Created by Bruno Nadeau on 11-01-14.
//  Copyright 2011 Wyld Collective Ltd. All rights reserved.
//

#import "TextsNavigationController.h"


@implementation TextsNavigationController

-(id) initWithRootViewController:(UIViewController*)ctrl {

	if ((self = [super initWithRootViewController:ctrl])) {
		[self setModalPresentationStyle:UIModalPresentationFormSheet];
		[[self navigationBar] setTintColor:[UIColor blackColor]];
	}

	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return
	((interfaceOrientation == UIInterfaceOrientationPortrait) ||
	 (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ||
	 (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
	 (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

@end
