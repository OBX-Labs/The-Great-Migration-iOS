#import "Vect3.h"
#import "OKTessData.h"
#import <string.h>
#import <vector>
#import "KineticString.h"
#import "MainSettings.h"

#import "Rectangle.h"

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "perlin.h"
#import "OKTextObject.h"
#import "GlobalUtils.h"




/**
 * Squid-like beast.
 */


@interface Beast : NSObject {
@private
    
    EAGLContext *context;

    
    GLubyte letterColor[1000];
    
    float fps;
    double age;                 //age
    int id;                   //unique integer id
    
    float speed;              //speed multiplier
    float offsetAngle;        //angle offset for scatter behavior to work with current
    
    Texture2D* shadow;            //shadow image
    NSMutableArray* origText;      //tesselated data of the original text
    NSMutableArray* dfrmText;      //tesselated data of the deformed text
    
    Vect3 *pos;              //position
    Vect3 *screenPos;        //calculated 2d screen position
    Vect3 *vel;              //velocity
    Vect3 *acc;              //acceleration
    float rotAcc;             //angular acceleration
    float rotVel;             //angular velocity
    float targetRot;          //target rotation
    
    Vect3 *mouth;              //center of lens effect
    float origMagnification;  //original magnification
    float magnification;      //current magnification
    float magOffset;          //magnification animation period offset
    float radius;             //lens radius
    float targetRadius;       //target lens radius (to animate on touch)
    
    Vect3 *tail;             //control point for the tailing text (used for DEBUG)
    
    float _scatter;            //scatter factor
    float camouflage;         //opacity offset to highlight the beast
    float scatterOffset;      //offset z value to calculate perlin noise effect of scatter
    
    
    OKSentenceObject* sentence;
    int firstTokenIndex;
    int tokenIndex;           //current index of token to spray
    int tokenLoop;            //number of times the beast sprayed its whole string
    double lastSpray;           //last time we sprayed
    
    //deformation utils
    OKTessData *origData;
    OKTessData *dfrmData;//tesselation data
    
    // avoid real-time allocations
    GLfloat* origVertices;
    GLfloat* dfrmVertices;
    
    Vect3 *mouthDelta;   //delta betwnee vertex and to mouth
    
    GLfloat *pOrig, *p;                     //vertices
    
    float mouthDist;                      //distance to mouth
    float scaleFactor;                    //scale factor
    float newdx, newdy;                   //new vertices delta values
    
    int width;
    int height;
}    

@property(nonatomic, retain) EAGLContext *context;
@property(nonatomic) Vect3* pos;
@property(nonatomic) float rot;
@property(nonatomic) float forward;
@property(nonatomic, retain) OKSentenceObject* sentence;
@property(nonatomic) int tokenIndex;
@property(nonatomic) int tokenLoop;
@property(nonatomic, assign) Vect3* screenPos;


-(id)initWithPos:(Vect3*)pos Width:(int)Width Height:(int)Height;

//set position
-(void) setPosition:(Vect3*) p;

//set velocity
-(void) setVelocity:(Vect3*) v;

//set acceleartion
-(void) setAcceleration:(Vect3*) a;

//set forward angle
-(void) setForward:(float) f;

//decreases camouflage
-(void) decCamouflage;

//increases camouflage
-(void) incCamouflage;

//apply random scatter behavior
-(void) scatter;

//apply scatter behavior
-(void) setScatter:(float)s;

//set magnification factor and period offset
-(void) setMagnification:(float)mag offset:(float)offset;

//get magnification factor
-(float) getMagnification;

//set speed
-(void) setSpeed:(float) s;

//set/get radius
-(void) setRadius:(float) r;
-(void) setTargetRadius:(float) r;
-(float) getRadius;

//get mouth
-(Vect3*) getMouth;

//set tail
-(void) setTail:(Vect3*) v;

//set text string
-(void) setText:(OKSentenceObject*) t;


//get the beast's position on the screen
-(Vect3*) getScreenPos;

-(void) setScreenPosition:(CGPoint)p;

//update the beast
-(void) update:(float)dt;

//swim behavior
-(void) swim:(Vect3*)current;

//deform behaviour (lens + tail)
-(void) deform;

//approach towards x,y point
-(void) approachWithX:(float)X Y:(float)Y;

//sprays the next word from the string
-(KineticString*) spray;
-(KineticString*) spray:(float)pushAngle pushForce:(float)pushForce override:(BOOL)override;

//apply acceleration
-(void) applyAcceleration;
-(Vect3*) acceleration;

//apply velocity
-(void) applyVelocity;

//apply current force
-(void) applyCurrent:(Vect3*)current multiplier:(float)multiplier;

//apply scatter force
-(void) applyScatter:(float) multiplier;

//draw
-(void) draw;

-(BOOL)isOutside:(CGRect)b;

//draw shadow
-(void) drawShadow:(GLint)textureId;

//get number of glyphs in a NextText group
//-(int) getGlyphCount:(NTTextGroup*) root;


-(void)drawDebugSq:(float)x y:(float)y z:(float)z size:(float)size;

////tesselate group
//-(TessDatas) tesselate:(NTTextGroup*) root;
//
////tesselate a glyph
//-(TessData*) tesselate:(NTFTGlyph*)glyph tessDetail:(float)tessDetail;
    
//set the original text from NextText and tesselate it
-(void) setOriginalText:(OKTessData*) root;

-(NSMutableArray*)getData;
 -(void)addData:(OKTessData*)d;

typedef std::vector< Beast* > Beasts;

@end