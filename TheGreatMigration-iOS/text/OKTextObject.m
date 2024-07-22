//
//  OKTextObject.m
//  Smooth
//
//  Created by Christian Gratton on 11-06-28.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import "OKTextObject.h"

@implementation OKTextObject
@synthesize text, sentenceObjects;

- (id) initWithText:(NSString*)aText withFont:(OKBitmapFont*)aFont andCanvasSize:(CGSize)aSize
{
    self = [self init];
	if (self != nil)
	{
        text = [[NSString alloc] initWithString:aText];
        bitmapFont = aFont;
        canvas = aSize;
        
        width = 0.0f;
        height = 0.0f;
        x = 0.0f;
        y = 0.0f;
        
        sentenceObjects = [[NSMutableArray alloc] init];
        
        //Split text into sentences
        NSArray *temp = [aText componentsSeparatedByString:@"\n"];
        
        for(int i = 0; i < [temp count]; i++)
        {
            OKSentenceObject *sentence = [[OKSentenceObject alloc] initWithSentence:[temp objectAtIndex:i] withFont:aFont];
            
            [sentence setWidth:[aFont getWidthForString:sentence.sentence]];
            [sentence setHeight:[aFont getHeightForString:sentence.sentence]];
            
            [sentenceObjects addObject:sentence];
            [sentence release];
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
    for(OKSentenceObject *sentence in sentenceObjects)
    {
        [sentence setX:aPos.x];
        [sentence setY:aPos.y];
        
        for(OKWordObject *word in sentence.wordObjects)
        {
            [word setX:aPos.x];
            [word setY:aPos.y];
            
            for(OKCharObject *charObj in word.charObjects)
            {
                [charObj setX:aPos.x];
                [charObj setY:aPos.y];
            }
        }
    }
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

- (int) countSentences
{
    return [sentenceObjects count];
}

- (void) drawText
{
    [bitmapFont drawStringAt:OKPointMake(x, y, 0) withString:text];
}

- (void) drawSentences
{
    for(OKSentenceObject *sentence in sentenceObjects)
    {
        [sentence drawWords];
    }
}

#pragma mark dealloc
- (void)dealloc
{
    [text release];
	[sentenceObjects release];
	[super dealloc];
}

@end
