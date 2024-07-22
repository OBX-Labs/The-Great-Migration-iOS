//
//  OKSentenceObject.h
//  Smooth
//
//  Created by Christian Gratton on 11-06-28.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OKBitmapFont.h"
#import "OKWordObject.h"

@interface OKSentenceObject : NSObject
{
    NSString *sentence;
    NSMutableArray *wordObjects;
    
    float width;
    float height;
    float x;
    float y;
    
    OKBitmapFont *bitmapFont;
}

@property (nonatomic, retain) NSString *sentence;
@property (nonatomic, retain) NSMutableArray *wordObjects;

- (id) initWithSentence:(NSString*)aSentence withFont:(OKBitmapFont*)aFont;

- (void) setWidth:(float)aWidth;
- (void) setHeight:(float)aHeight;
- (void) setX:(float)aX;
- (void) setY:(float)aY;

- (void) setPosition:(CGPoint)aPos;

- (float) getWitdh;
- (float) getHeight;
- (float) getX;
- (float) getY;

- (void) drawSentence;
- (void) drawWords;

@end
