//
//  MainController.h
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-05-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beast.h"
#import "Vect3.h"
#import <Vector>
#import "PerlinTexture.h"
#import "OKTessData.h"
#import "PreCalcTables.h"

#import "MainSettings.h"
#import "OKTextObject.h"
#import "OKTessFont.h"
#import "OKCharDef.h"

#import "AgingLinkedList.h"

// PERLIN NOISE TEXTURE SIZE
#define PN_WIDTH 32
#define PN_HEIGHT 32


struct Vect3;
typedef struct Vect3 Vect3;

@interface MainController : NSObject {
    
@private
    
    
    //3d points in 2d space arrays
	GLfloat modelview[16];
	GLfloat projection[16];
    
    float cameraZ;         //field of view and camera's z position
    CGRect bounds;   //bounds of far plane (to calculate of objects are outside)
    
    
    
    double frameCount;
    double lastUpdate;        //last time the sketch was updated
    double now;               //current time
    float dt;                    //time difference between draw calls
    float animationRatio;   //BASE_FPS/FPS ratio for animations
    
    //passed to constructor
    float _fovy;

    
    int totalBeastCount;        //total number of created beast up to now
    int currentBeastCount;      //current number of beasts on screen
    
    // used to compute distance according to the depth (locate the edge of the screen, which increases with distance)
    float maxWidth;
    float maxHeight;
    
    Texture2D *shadow;              //the generic shadow image
    //Texture2D *particleTexture;     // texture for the touchParticles
    
    
    float beast_size;
    
    Vect3* current;            //current (flow) direction
    float scatter;              //scatter factor (0 = no scatter, 1 = all scatter)
    Beast* readBeast;         //the dragged beast
    NSMutableArray* sprayTokens;     //list of sprayed tokens
    
    NSMutableArray* beastData;
    
    ////text properties
    OKBitmapFont* font;
    OKTessFont* tessFont;
    OKTextObject* textObject;       //loaded text strings
    int sentenceIndex;            //index of the next string
    
    // background
    PerlinTexture *perlinTex;
    GLuint backgroundTexture;
    // TO REMOVE
    double counter;
    
    //TEMPORARY
    //void *keys;
    //CGPoint *tmpValues;

    AgingLinkedList *touchParticles;
    NSArray* touchPoints;
    
    float touch_particle_minimum_size;
    float touch_particle_maximum_size;
    //float bitmap_font_size;
    float min_beast_z;
    float max_beast_z;
}

@property(nonatomic) float width;
@property(nonatomic) float height;
@property(nonatomic) float beast_size;
@property(nonatomic) float touch_particle_minimum_size;
@property(nonatomic) float touch_particle_maximum_size;
@property(nonatomic) float min_beast_z;
@property(nonatomic) float max_beast_z;
@property(nonatomic) float bitmap_font_size;
@property(nonatomic) NSArray* touchPoints; // keep track of touch position internally for readBeast() and update()
@property(nonatomic, retain) NSMutableDictionary *glyphs;
@property(nonatomic, retain) NSMutableArray *beasts;

-(id)initWithWidth:(float)Width Height:(float)Height fovy:(float)fovy;

//-(void)printError:(int)error;
-(void)setupBitmapFont:(NSString*)fontName;
-(void)setup;
//-(void)loadGlyphs;

//-(void)initOpenGl;
-(void)draw;
////draw the framerate
//-(void) drawFrameRate;


-(void)updateTouchParticles:(float)dt;

////update the beasts
-(void) updateBeasts;
//
////maximum number of beasts at a given time
-(int) maxBeasts;
//
////update sprayed words
-(void) updateSpray;

////scatter the beasts
-(void) scatterBeasts;

////try to 'read' the beast under the given x,y position
-(void) readBeast:(CGPoint)point;


////draw the beasts' shadows
-(void) drawShadows;

////draw the beasts
-(void) drawBeasts;

-(void) drawBackground;

-(void) drawTouchParticles;

////draw sprayed tokens
-(void) drawSpray;

//
////load text
-(void) loadText:(NSString*)textFile;
//
-(void) removeBeastAtIndex:(int) i;
//
-(void) removeBeast:(Beast*) b;
//
////create a beast
-(Beast*) createBeast;

////get a random start position for a beast
-(Vect3*) getBeastStartPosition;
-(Vect3*) getBeastStartPosition:(float) z;


-(void)drawDebugSq:(float)x y:(float)y z:(float)z size:(float)size;

//mouse pressed

-(void) mousePressed:(NSMutableArray*)points;

-(void) mouseDragged:(NSMutableArray*)points;

-(void) mouseReleased:(NSMutableArray*)points;


- (CGPoint) screenXYWithX:(float)x Y:(float)y andZ:(float)z;


//check if a beast is being read for a certain touch id
-(bool) isReadingBeastForId:(int)index;

//check if a beast is being read/dragged
-(bool) isReadingBeast:(Beast*)b;

//convert color to Color
//-(Color) colorToColor:(color) c;

//convert Color to color
//-(color) ColorTocolor(Color) c;

@end








