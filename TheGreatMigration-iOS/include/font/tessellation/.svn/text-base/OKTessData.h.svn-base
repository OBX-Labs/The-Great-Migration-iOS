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
    GLint *endsAr;
    
    GLfloat *colors;
}

@property int ID;
@property(nonatomic, retain)NSMutableArray *shapes;
@property(nonatomic, retain)NSMutableArray *ends;
@property(nonatomic, retain)NSMutableArray *vertices;
@property(nonatomic) GLfloat *verticesAr;
@property(nonatomic) GLint *typesAr;
@property(nonatomic) GLint *endsAr;
@property(nonatomic) GLfloat *colors;

- (id) initWithID:(int)aID;
- (id) initWithCopy:(OKTessData*)aTessData;
//- (id)copy;

- (void) addShapes:(NSString*)aShape;
- (void) addVertices:(NSArray*)aVertex;
- (void) addEnds:(NSString*)aEnd;
- (void) fillVertices;
- (void) fillShapes;
- (void) fillEnds;


- (GLfloat*) getAllVertices;
- (GLfloat*) getVertices;
- (GLfloat*) getVertices:(int)aShape;
//- (int) getEnds:(int)aShape;
- (GLint*) getTypes;
- (GLint) getType:(int)aShape;
- (GLint) numVertices;
- (GLint) numVertices:(int)aShape;
- (GLint*) getEnds;
- (GLint) getEnds:(int)aShape;


- (GLfloat*) getColors;
- (GLfloat) getRed;
- (GLfloat) getGreen;
- (GLfloat) getBlue;
- (GLfloat) getAlpha;

- (void) setColors:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha;


@end
