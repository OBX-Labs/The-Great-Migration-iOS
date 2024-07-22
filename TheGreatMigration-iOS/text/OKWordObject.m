//
//  OKWordObject.m
//  Smooth
//
//  Created by Christian Gratton on 11-06-28.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import "OKWordObject.h"


@implementation OKWordObject
@synthesize word, charObjects;

- (id) initWithWord:(NSString*)aWord withFont:(OKBitmapFont*)aFont
{
    self = [self init];
	if (self != nil)
	{
        word = [[NSString alloc] initWithString:aWord];
        bitmapFont = aFont;
        
        charObjects = [[NSMutableArray alloc] init];
        
        //Split word into characters
        for(int i = 0; i < [aWord length]; i++)
        {
            OKCharObject *charObj = [[OKCharObject alloc] initWithChar:[NSString stringWithFormat:@"%c", [aWord characterAtIndex:i]] withFont:aFont];
            
            [charObj setWidth:[aFont getWidthForString:charObj.charObj]];
            [charObj setHeight:[aFont getHeightForString:charObj.charObj]];
            
            [charObjects addObject:charObj];
            [charObj release];
        }
        
        width = 0.0f;
        height = 0.0f;
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

- (float) getX
{
    return x;
}

- (float) getY
{
    return y;
}

- (void) drawWord
{
    [bitmapFont drawStringAt:OKPointMake(x, y, 0) withString:word];
}

- (void) drawChars
{
    for(OKCharObject *charObj in charObjects)
    {
        [charObj drawChar];
    }
}

#pragma mark dealloc
- (void)dealloc
{
    [word release];
	[charObjects release];
	[super dealloc];
}

@end
