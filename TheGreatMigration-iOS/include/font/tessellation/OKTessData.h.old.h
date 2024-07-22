//
//  OKTessData.h
//  OKBitmapFontSample
//
//  Created by Christian Gratton on 11-07-11.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface OKTessData : NSObject
{
    int ID;
    NSMutableArray *shapes;
    NSMutableArray *ends;
    NSMutableArray *vertices;
    GLfloat *verticesAr;
    GLint *typesAr;
    
    GLfloat *colors;
}

@property int ID;
@property(nonatomic, retain)NSMutableArray *shapes;
@property(nonatomic, retain)NSMutableArray *ends;
@property(nonatomic, retain)NSMutableArray *vertices;

- (id) initWithID:(int)aID;
- (void) addShapes:(NSString*)aShape;
- (void) addVertices:(NSArray*)aVertex;
- (void) addEnds:(NSString*)aEnd;
- (void) fillVertices;
- (void) fillShapes;

- (GLfloat*) getAllVertices;
- (void) setAllVertices:(GLfloat*)_verticesAr;
- (GLfloat*) getVertices:(int)aShape;

- (GLfloat*) getColors;
- (GLfloat) getRed;
- (GLfloat) getGreen;
- (GLfloat) getBlue;
- (GLfloat) getAlpha;

- (void) setColors:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha;

- (int) getEnds:(int)aShape;

- (GLint) getType:(int)aShape;
- (GLint*) getAllTypes;
- (void) setAllTypes:(GLint*)_typesAr;

@end
