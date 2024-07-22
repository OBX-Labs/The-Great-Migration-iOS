//
//  OKCharDef.m
//  ObxKit
//
//  Created by Christian Gratton based on AngelFont provided by 71Squared.com
//

#import "OKCharDef.h"

#import "OKTessData.h"

@implementation OKCharDef
@synthesize image, charID, x, y, width, height, xOffset, yOffset, xAdvance, scale, kerning, tessData;

- (id)initCharDefWithFontImage:(OKImage*)fontImage scale:(float)fontScale
{
	self = [super init];
	if (self != nil) {
		// Reference the image file which contains the spritemap for the characters
		[self setImage:fontImage];
        
		// Set the scale for this character
		[self setScale:fontScale];
                
        //Create kerning dictionary
        NSMutableDictionary* kDict = [[NSMutableDictionary alloc] init];
        [self setKerning:kDict]; 
        [kDict release];
	}
	return self;
}

- (id) initCharDefWithFontScale:(float)fontScale
{
    self = [super init];
	if (self != nil) {
		// Set the scale for this character
		[self setScale:fontScale];
        
        //Create kerning dictionary
        NSMutableDictionary* kDict = [[NSMutableDictionary alloc] init];
        [self setKerning:kDict]; 
        [kDict release];
        
        //Create kerning dictionary
        NSMutableDictionary* tDict = [[NSMutableDictionary alloc] init];
        [self setTessData:tDict]; 
        [tDict release];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	OKCharDef *copy = [[[self class] allocWithZone: zone] init];
    
	copy.charID = [self charID];
    copy.x = [self x];
    copy.y = [self y];
    copy.width = [self width];
    copy.height = [self height];
    copy.xOffset = [self xOffset];
    copy.yOffset = [self yOffset];
    copy.xAdvance = [self xAdvance];
    copy.image = [self image];
    copy.scale = [self scale];
    copy.kerning = [self kerning];
    copy.tessData = [self tessData];
	
    return copy;
}

- (void) loadGlyph:(CXMLDocument*)aDoc
{
    NSArray *tessDetail = [aDoc nodesForXPath:@"//tesselation" error:nil];

    for(CXMLElement *tesselation in tessDetail)
    {
        NSArray *glyphs = [tesselation nodesForXPath:@"glyph" error:nil];
        
        for(CXMLElement *glyph in glyphs)
        {
            if([[[glyph attributeForName:@"id"] stringValue] isEqualToString:[NSString stringWithFormat:@"%i", charID]])
            {
                OKTessData *tess = [[OKTessData alloc] initWithID:[[[tesselation attributeForName:@"detail"] stringValue] intValue]];
                
                NSArray *shapes = [glyph nodesForXPath:@"polygon/shapes/shape" error:nil];
                NSArray *vertices = [glyph nodesForXPath:@"polygon/vertices/vertex" error:nil];
                NSArray *ends = [glyph nodesForXPath:@"polygon/ends/end" error:nil];
                
                for(CXMLElement *shape in shapes)
                {
                    [tess addShapes:[[shape attributeForName:@"type"] stringValue]];
                }
                
                for(CXMLElement *vertex in vertices)
                {
                    [tess addVertices:[NSArray arrayWithObjects:[[vertex attributeForName:@"x"] stringValue],[[vertex attributeForName:@"y"] stringValue], [[vertex attributeForName:@"z"] stringValue], nil]];
                }
                
                for(CXMLElement *end in ends)
                {
                    
                    [tess addEnds:[[end attributeForName:@"index"] stringValue]];
                }
                
                [tess fillVertices];
                [tess fillShapes];
               
                [tessData setObject:tess forKey:[[tesselation attributeForName:@"detail"] stringValue]];
                [tess release];

            }
        }
    }
}

- (NSString *)description {
	// Log what we have created
	return [NSString stringWithFormat:@"CharDef = id:%d x:%d y:%d width:%d height:%d xoffset:%d yoffset:%d xadvance:%d tessdata:%i", 
			charID, 
			x, 
			y, 
			width, 
			height, 
			xOffset, 
			yOffset, 
			xAdvance,
            [tessData count]];
}


- (void)dealloc {
    [image release];
    [tessData release];  
    [kerning release];
	[super dealloc];
}

@end
