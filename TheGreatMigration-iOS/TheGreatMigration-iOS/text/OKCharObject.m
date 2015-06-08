//
//  OKCharObject.m
//  Smooth
//
//  Created by Christian Gratton on 11-06-28.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import "OKCharObject.h"


@implementation OKCharObject
@synthesize charObj;

- (id) initWithChar:(NSString*)aChar withFont:(OKBitmapFont*)aFont
{
    self = [self init];
    if (self != nil)
    {
        charObj = [[NSString alloc] initWithString:aChar];
        bitmapFont = aFont;
        
        width = 0.0f;
        height = 0.0f;
        kerning = 0.0f;
        x = 0.0f;
        y = 0.0f;
    }
    return self;
}

#pragma mark setters

- (void) setWidth:(float)aWidth
{
    width = aWidth;
}

- (void) setHeight:(float)aHeight
{
    height = aHeight;
}

- (void) setKerning:(float)aKerning
{
    kerning = aKerning;
}

- (void) setX:(float)aX
{
    x = aX;
}

- (void) setY:(float)aY
{
    y = aY;
}

- (void) setPosition:(CGPoint)aPos
{
    [self setX:aPos.x];
    [self setY:aPos.y];
}

#pragma mark getters

- (float) getWitdh
{
    return width;
}

- (float) getHeight
{
    return height;
}

- (float) getKerning
{
    return kerning;
}

- (float) getX
{
    return x;
}

- (float) getY
{
    return y;
}


- (void) drawChar
{
    [bitmapFont drawStringAt:OKPointMake(x, y, 0) withString:charObj];
}

#pragma mark dealloc
- (void)dealloc
{
    [charObj release];
	[super dealloc];
}

@end
