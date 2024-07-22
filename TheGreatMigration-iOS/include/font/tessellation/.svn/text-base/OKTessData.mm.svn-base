//
//  OKTessData.m
//  OKBitmapFontSample
//
//  Created by Christian Gratton on 11-07-11.
//  Copyright 2011 Christian Gratton. All rights reserved.
//

#import "OKTessData.h"


@implementation OKTessData
@synthesize ID, shapes, ends, vertices, verticesAr, typesAr, endsAr, colors;

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
        NSArray *vertX = [NSArray arrayWithArray:[vertices objectAtIndex:i]];
        NSArray *vertY = [NSArray arrayWithArray:[vertices objectAtIndex:i]];
        
        verticesAr[iterator] = ([[vertX objectAtIndex:0] doubleValue]);
        verticesAr[(iterator + 1)] = ([[vertY objectAtIndex:1] doubleValue]);
        
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

- (void) fillEnds
{
    //NSLog(@"Fill ends for %d: %d", ID, [ends count]);
    endsAr = new GLint[[ends count]];
    
    for(int i = 0; i < [ends count]; i++)
    {
        int tmp = [[ends objectAtIndex:i] intValue];
        endsAr[i] = tmp;
        //NSLog(@" %d: %d", i, endsAr[i]);
    }
}

//copy
- (id) initWithCopy:(OKTessData*)aTessData
{
    self = [self init];
	if (self != nil)
    {
		ID = aTessData.ID;
        shapes = aTessData.shapes;
        ends = aTessData.ends;
        vertices = aTessData.vertices;
        
        int numVertices = [vertices count];
        verticesAr = new GLfloat[(numVertices*2)];
        memcpy(verticesAr, [aTessData getVertices], numVertices*2);
        
        int numTypes = [shapes count];
        typesAr = new GLint[numTypes];
        memcpy(typesAr, [aTessData getTypes], numTypes);
        
        int numEnds = [ends count];
        endsAr = new GLint[numEnds];
        memcpy(endsAr, [aTessData getEnds], numEnds);
        
        colors = new GLfloat[4];
        colors[0] = [aTessData getRed];
        colors[1] = [aTessData getGreen];
        colors[2] = [aTessData getBlue];
        colors[3] = [aTessData getAlpha];
        

	}
	return self;
}



- (id)copyWithZone:(NSZone *)zone
{
	OKTessData *copy = [[[self class] allocWithZone: zone] init];
    
    copy.ID = [self ID];
    copy.shapes = [self shapes];
    copy.ends = [self ends];
    copy.vertices = [self vertices];
   
    int numVertices = [[self vertices] count];
    copy.verticesAr = new GLfloat[(numVertices*2)];
    memcpy(copy.verticesAr, verticesAr, numVertices*2*sizeof(GLfloat));
    
    int numTypes = [[self shapes] count];
    copy.typesAr = new GLint[numTypes];
    memcpy(copy.typesAr, typesAr, numTypes*sizeof(GLint));
    
    int numEnds = [[self ends] count];
    copy.endsAr = new GLint[numEnds];
    memcpy(copy.endsAr, endsAr, numEnds*sizeof(GLint));
    
    copy.colors = new GLfloat[4];
    memcpy(copy.colors, colors, 4*sizeof(GLfloat));
    
    return copy;
}

/*- (id)copy
{
	OKTessData *copy = [[[self class] alloc] initWithCopy:self];
	
    return copy;
}*/

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

- (GLfloat*) getVertices { return verticesAr; }

- (GLfloat*) getVertices:(int)aShape
{
    //return &verticesAr[(aShape == 0 ? 0 : ([[ends objectAtIndex:(aShape - 1)] intValue] * 2))];
    return &verticesAr[(aShape == 0 ? 0 : (endsAr[(aShape - 1)] * 2))];
}

/*- (int) getEnds:(int)aShape
{
    return (aShape == 0 ? [[ends objectAtIndex:0] intValue] : ([[ends objectAtIndex:aShape] intValue] - [[ends objectAtIndex:(aShape - 1)] intValue]));
}*/

- (GLint*) getTypes { return typesAr; }
- (GLint) getType:(int)aShape { return typesAr[aShape]; }
- (GLint) numVertices { return [vertices count]; }
- (GLint) numVertices:(int)aShape
{    
    int shapeEnd = endsAr[aShape];//[[ends objectAtIndex:aShape] intValue];
    int shapeStart = aShape == 0 ? 0 : endsAr[(aShape - 1)];//[[ends objectAtIndex:aShape-1] intValue];
    
    //NSLog(@"Num vertices for %d: %d - %d = %d", ID, shapeEnd, shapeStart, (shapeEnd-shapeStart));
    
    return shapeEnd - shapeStart;
}

- (GLint*) getEnds { return endsAr; }
- (GLint) getEnds:(int)aShape { return endsAr[aShape]; }

- (void) dealloc
{
    [shapes release];
    [ends release];
    [vertices release];
    delete [] verticesAr;
    delete [] typesAr;
    delete [] endsAr;
    [super dealloc];
}

@end
