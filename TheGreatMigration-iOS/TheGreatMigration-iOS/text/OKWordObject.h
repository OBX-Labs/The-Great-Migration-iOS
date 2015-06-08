//
//  OKWordObject.h
//  Smooth
//
//  Created by Christian Gratton on 11-06-28.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OKBitmapFont.h"
#import "OKCharObject.h"

@interface OKWordObject : NSObject
{
    NSString *word;
    NSMutableArray *charObjects;
    
    float width;
    float height;
    float x;
    float y;
    
    OKBitmapFont *bitmapFont;
}

@property (nonatomic, retain) NSString *word;
@property (nonatomic, retain) NSMutableArray *charObjects;

- (id) initWithWord:(NSString*)aWord withFont:(OKBitmapFont*)aFont;

- (void) setWidth:(float)aWidth;
- (void) setHeight:(float)aHeight;
- (void) setX:(float)aX;
- (void) setY:(float)aY;

- (void) setPosition:(CGPoint)aPos;

- (float) getWitdh;
- (float) getHeight;
- (float) getX;
- (float) getY;

- (void) drawWord;
- (void) drawChars;

@end
