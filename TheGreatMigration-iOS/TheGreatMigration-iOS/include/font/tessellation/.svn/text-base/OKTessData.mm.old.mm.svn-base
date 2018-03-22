//
//  OKTessData.m
//  OKBitmapFontSample
//
//  Created by Christian Gratton on 11-07-11.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import "OKTessData.h"


@implementation OKTessData
@synthesize ID, shapes, ends, vertices;

- (id) initWithID:(int)aID
{
    self = [self init];
	if (self != nil)
    {
		ID = aID;
        shapes = [[NSMutableArray alloc] init];
        ends = [[NSMutableArray alloc] init];
        vertices = [[NSMutableArray alloc] init];
        colors = new GLfloat[4];
        colors[0] = 0;
        colors[1] = 0;
        colors[2] = 0;
        colors[3] = 0;
	}
	return self;
}

- (id) initWithOKTessData:(OKTessData*)tD
{
    self = [self init];
	if (self != nil)
    {
		ID = -1;
        shapes = tD.shapes;
        ends = tD.ends;
        vertices = tD.vertices;
        colors = new GLfloat[4];
        colors[0] = [tD getRed];
        colors[1] = [tD getGreen];
        colors[2] = [tD getBlue];
        colors[3] = [tD getAlpha];
        
        [self fillShapes];
        [self fillVertices];        
        
	}
	return self;
}

- (void) addShapes:(NSString*)aShape
{
    [shapes addObject:aShape];
}

- (void) addVertices:(NSArray*)aVertices
{
    [vertices addObject:aVertices];
}

- (void) addEnds:(NSString*)aEnd
{
    [ends addObject:aEnd];
}

- (void) fillVertices
{
    verticesAr = new GLfloat[([vertices count]*2)];
    int iterator = 0;
    
    for(int i = 0; i < [vertices count]; i++)
    {
        verticesAr[iterator] = ([[[vertices objectAtIndex:i] objectAtIndex:0] doubleValue]);
        verticesAr[(iterator + 1)] = ([[[vertices objectAtIndex:i] objectAtIndex:1] doubleValue]);
        
        iterator += 2;
    }
}

- (void) fillShapes
{
    typesAr = new GLint[[shapes count]];
    
    for(int i = 0; i < [shapes count]; i++)
    {
        if([[shapes objectAtIndex:i] isEqualToString:@"t"])
            typesAr[i] = GL_TRIANGLES;
        else if([[shapes objectAtIndex:i] isEqualToString:@"f"])
            typesAr[i] = GL_TRIANGLE_FAN;
        else if([[shapes objectAtIndex:i] isEqualToString:@"s"])
            typesAr[i] = GL_TRIANGLE_STRIP;
    }
}

- (GLfloat*) getColors 
{
    return colors;
}
- (GLfloat) getRed 
{
    return colors[0];
}
- (GLfloat) getGreen
{
    return colors[1];    
}
- (GLfloat) getBlue
{
    return colors[2];
}
- (GLfloat) getAlpha
{
    return colors[3];
}

- (void) setColors:(GLfloat)red green:(GLfloat)green blue:(GLfloat)blue alpha:(GLfloat)alpha
{
    colors[0] = red;
    colors[1] = green;
    colors[2] = blue;
    colors[3] = alpha;
}

- (GLfloat*) getAllVertices
{
    return verticesAr;
}
- (void) setAllVertices:(GLfloat*)_verticesAr
{
    verticesAr = _verticesAr;
};

- (GLfloat*) getVertices:(int)aShape
{
    return &verticesAr[(aShape == 0 ? 0 : ([[ends objectAtIndex:(aShape - 1)] intValue] * 2))];
}

- (int) getEnds:(int)aShape
{
    return (aShape == 0 ? [[ends objectAtIndex:0] intValue] : ([[ends objectAtIndex:aShape] intValue] - [[ends objectAtIndex:(aShape - 1)] intValue]));
}

- (GLint) getType:(int)aShape
{
    return typesAr[aShape];
}
- (GLint*) getAllTypes
{
    return typesAr;
}

- (void) setAllTypes:(GLint*)_typesAr
{
    typesAr = _typesAr;
}

- (id)copy
{
	OKTessData *copy = [[[[self class] alloc] initWithOKTessData:self] autorelease];
	
    return copy;
}

- (void) dealloc
{
    //[shapes release];
    //[ends release];
    //[vertices release];
    
    delete [] typesAr;
    delete [] verticesAr;
    
    [super dealloc];
}

@end
