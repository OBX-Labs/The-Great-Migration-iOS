//
//  OKCharObject.h
//  Smooth
//
//  Created by Christian Gratton on 11-06-28.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OKBitmapFont.h"

@interface OKCharObject : NSObject
{
    NSString *charObj;
    
    float width;
    float height;
    float kerning;
    float x;
    float y;
    
    OKBitmapFont *bitmapFont;
}

@property (nonatomic, retain) NSString *charObj;

- (id) initWithChar:(NSString*)aChar withFont:(OKBitmapFont*)aFont;

- (void) setWidth:(float)aWidth;
- (void) setHeight:(float)aHeight;
- (void) setKerning:(float)aKerning;
- (void) setX:(float)aX;
- (void) setY:(float)aY;

- (void) setPosition:(CGPoint)aPos;

- (float) getWitdh;
- (float) getHeight;
- (float) getKerning;
- (float) getX;
- (float) getY;

- (void) drawChar;

@end
