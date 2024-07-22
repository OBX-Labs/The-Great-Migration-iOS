//
//  OKTextObject.h
//  Smooth
//
//  Created by Christian Gratton on 11-06-28.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OKBitmapFont.h"
#import "OKSentenceObject.h"

@interface OKTextObject : NSObject
{
    NSString *text;
    NSMutableArray *sentenceObjects;
    
    float width;
    float height;
    float x;
    float y;
    
    CGSize canvas;
    
    OKBitmapFont *bitmapFont;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSMutableArray *sentenceObjects;

- (id) initWithText:(NSString*)aText withFont:(OKBitmapFont*)aFont andCanvasSize:(CGSize)aSize;

- (void) setWidth:(float)aWidth;
- (void) setHeight:(float)aHeight;
- (void) setX:(float)aX;
- (void) setY:(float)aY;

- (void) setPosition:(CGPoint)aPos;

- (float) getWitdh;
- (float) getHeight;
- (float) getX;
- (float) getY;

- (int) countSentences;

- (void) drawText;
- (void) drawSentences;

@end
