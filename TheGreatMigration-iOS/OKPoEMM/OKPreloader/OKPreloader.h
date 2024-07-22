//
//  OKPreloader.h
//  OKPoEMM
//
//  Created by Christian Gratton on 2013-03-11.
//  Copyright (c) 2013 Christian Gratton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TheGreatMigration_iOSAppDelegate;

@interface OKPreloader : UIViewController
{
    CGRect frame;
    TheGreatMigration_iOSAppDelegate *delegate;
    BOOL loadOnAppear;
}

- (id) initWithFrame:(CGRect)aFrame forApp:(TheGreatMigration_iOSAppDelegate*)aDelegate loadOnAppear:(BOOL)flag;

@end
