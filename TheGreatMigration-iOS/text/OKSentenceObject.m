//
//  OKSentenceObject.m
//  Smooth
//
//  Created by Christian Gratton on 11-06-28.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import "OKSentenceObject.h"


@implementation OKSentenceObject
@synthesize sentence, wordObjects;

- (id) initWithSentence:(NSString *)aSentence withFont:(OKBitmapFont *)aFont
{
    self = [self init];
	if (self != nil)
	{
        sentence = [[NSString alloc] initWithString:aSentence];
        bitmapFont = aFont;
        
        wordObjects = [[NSMutableArray alloc] init];
        
        width = 0.0f;
        height = 0.0f;
        x = 0.0f;
        y = 0.0f;
        
        //Split sentence into words
        NSArray *temp = [aSentence componentsSeparatedByString:@" "];
        
        for(int i = 0; i < [temp count]; i++)
        {
            OKWordObject *word = [[OKWordObject alloc] initWithWord:[temp objectAtIndex:i] withFont:aFont];
            
            [word setWidth:[aFont getWidthForString:word.word]];
            [word setHeight:[aFont getHeightForString:word.word]];
            
            [wordObjects addObject:word];
            [word release];
        }
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

- (void) drawSentence
{
    [bitmapFont drawStringAt:OKPointMake(x, y , 0) withString:sentence];
}

- (void) drawWords
{
    for(OKWordObject *word in wordObjects)
    {
        [word drawWord];
    }
}

#pragma mark dealloc
- (void)dealloc
{
    [sentence release];
	[wordObjects release];
	[super dealloc];
}

@end
