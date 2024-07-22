//
//  MainController.m
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-05-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "GlobalUtils.h"
#import "TouchXML.h"
#import "glu.h"
#import "OKTessData.h"
#import "iostream"
#import "Vect3.h"
#import "TouchParticle.h"
#import "MainSettings.h"

//#import "CHDataStructures.h"
//#import "CHDataStructures/CHDataStructures.h"


@implementation MainController

@synthesize height, width, beasts, glyphs, touchPoints, beast_size,touch_particle_minimum_size,touch_particle_maximum_size,  min_beast_z, max_beast_z;


-(id)initWithWidth:(float)Width Height:(float)Height fovy:(float)fovy {
    
    // Assign self to value returned by super's designated initializer
    // Designated initializer for NSObject is init
    self = [super init];
    if (self) {
        
        tessFont = [[OKTessFont alloc] initWithControlFile:@"olvr93w-64" scale:1.7f filter:GL_LINEAR];
        
        [self loadText:@TEXT_FILE];
        beastData = [[NSMutableArray alloc] initWithCapacity:20];
        
        
        sprayTokens = [[NSMutableArray alloc] init];
        
        frameCount = 0;
        lastUpdate = 0;
        now = 0;
        dt = 0;
        animationRatio = 0;
        
        height = Height;
        width = Width;
        maxHeight = height*max_beast_z/min_beast_z;
        maxWidth = width*max_beast_z/min_beast_z;
        
        readBeast = nil;
        
        beast_size = 0.45f;
        
        beasts = [[NSMutableArray alloc] init];
        glyphs = [[NSMutableDictionary alloc] init];

        _fovy = fovy;
        
        current = new Vect3(cos(CURRENT_DIRECTION),sin(CURRENT_DIRECTION),0);
        shadow = LoadImage("shadow","png");

//      calculate bounds (to check if beasts are outside)        
        float minY = -int(tan((_fovy*DEG_TO_RAD)/2) * -min_beast_z) - (SPAWNING_BORDER+490);
        float minX = minY * width/height; 
        float w = -2*minX + width;
        float h = -2*minY + height; 
        
        NSLog(@"Size: w:%f; h:%f", Width, Height);
        NSLog(@"Bounds: x:%f,%f; y:%f,%f",minX,w,minY,h);
        bounds = CGRectMake(minX, minY, w, h);
        
        now = [NSDate timeIntervalSinceReferenceDate];
        lastUpdate = now;
        
        // TO BE REPLACED BY PURE dt in perlin noise?
        counter = DBL_MIN;
        
        if (!initCalcTables_flag)
            initCalcTables();
        
        if (!perlinTex)
            perlinTex = [[PerlinTexture alloc] initWithWidth:PN_WIDTH AndHeight:PN_HEIGHT];
 
        //make space for the touch particles
        touchParticles =  [[AgingLinkedList alloc] initWithDuration:TOUCH_PARTICLE_LIFE];
        touchPoints = [[NSArray alloc] init];
    }
    return self;
    
}
-(void)setupBitmapFont:(NSString*)fileName
{       
    font = [[OKBitmapFont alloc] initWithFontImageNamed:[NSString stringWithFormat:@"%@.png", fileName] controlFile:fileName scale:1 filter:GL_LINEAR];
}

- (void)dealloc
{
    //delete tess;
    [beasts release];
    [glyphs release];
    [super dealloc];
}

-(void)initOpenGL
{
    
    
}


-(void) setup
{
 
    
    Beast *beast = [self createBeast];
    [beasts addObject:beast];
    NSLog(@"Maincontroller - Beasts count:%d",[beasts count]);
    
}

////load text
- (void) loadText:(NSString*)textFile
{
    //load text file
    NSBundle *b = [NSBundle mainBundle];
    NSString *dir = [b resourcePath];
    NSArray *parts = [NSArray arrayWithObjects:dir, textFile, (void *)nil];
    NSString *path = [NSString pathWithComponents:parts];
    
    
    if (path) {
        NSString *myText = [NSString stringWithContentsOfFile:path];
        textObject = [[OKTextObject alloc] initWithText:myText withFont:font andCanvasSize:CGSizeMake(width, height)];
    }
    
    //start at first string
    sentenceIndex = 0;    
}


-(Beast*) createBeast
{    
    Vect3 *startPos = [self getBeastStartPosition];
    
    static int aDetail = 3;     //tess font detail level

    static float yOffset = BEAST_Y_OFFSET;
    
    GLfloat* tessVertices;
    
    
    //set default properties
    Beast *beast = [[[Beast alloc] initWithPos:startPos Width:width Height:height] autorelease];//new Beast(startPos,tess);
    //beastid = totalBeastCount;
    [beast setMagnification:0.85 offset:fmod(arc4random(), TWO_PI)];
    [beast setRadius:BEAST_RADIUS];
    [beast setSpeed:0.5f+fmod(arc4random(), 3.5f)];
    [beast setScatter:scatter];
    [beast setForward:current->x > 0 ? PI : 0];
    
    beast.sentence = [[textObject sentenceObjects] objectAtIndex:sentenceIndex];
    NSMutableArray* words = [[[textObject sentenceObjects] objectAtIndex:sentenceIndex] wordObjects];
    NSMutableArray* lines = [[NSMutableArray alloc] init];
    
    // Build lines of strings
    for (int i=0; i<[words count]; i++)
    {
        
        NSMutableString* line;
        int lineNumber = floorf((i)/(BEAST_LENGTH)); //split every 4 words

        if ([lines count]>lineNumber && [lines count]>0){//[lines objectAtIndex:lineNumber]) {
            line = [lines objectAtIndex:lineNumber];
            [line appendString:@" "];
            [line appendString:[[words objectAtIndex:i] word]];
        } else {
            line = [[NSMutableString alloc] initWithString:[[words objectAtIndex:i] word]];
            [lines insertObject:line atIndex:lineNumber];
        }        
        
    }
    
    
    float currentXPos = BEAST_X_OFFSET; // theoretical pure position (used to calculate the rotated position)
    float currentYPos = yOffset;
    float xPos =0;
    float yPos =0;
    int charID;
    NSArray* cD;
    GLfloat* colors = new GLfloat[4];
    
    colors[0] = 0;
    colors[1] = 0;
    colors[2] = 0;
    colors[3] = 0;
    
    //NSLog(@"Create beast:");
    
    // Build (replace with) lines of chardef
    for (int i =0; i<[lines count]; i++) {
        cD = [NSArray arrayWithArray:[tessFont getCharDefForString:[lines objectAtIndex:i]]];

        // Loop through all the characters in the line
        for(int j=0; j<[[lines objectAtIndex:i] length]; j++)
        {
            
            // Grab the unicode value of the current character
            charID = [[lines objectAtIndex:i] characterAtIndex:j];
            
            //NSLog(@" char: %d", charID);
            
            if (j>2)
                aDetail = 1;
            else
                aDetail = 3;
            
            NSString* detail = [NSString stringWithFormat:@"%i", aDetail];
            OKTessData *tess = [[[[tessFont getCharDefForCharInt:charID] tessData] objectForKey:detail] copy];

            
            // Move the x location along by the amount defined for this character in the control file so the characters are spaced
            // correctly
            if ([[lines objectAtIndex:i] characterAtIndex:j] == 32 ||
                (i == 0 && j == 0) ) { //i==j==0 is for init

                //generate new color for next sequence of OKTessData part of the next word (range = 0.5 - 1.0)
                float rand = (arc4random()%10)*0.025f;
                colors[0] = 1.0f;
                colors[1] = 1.0f;
                colors[2] = 1.0f;
                colors[3] = BEAST_ALPHA+rand;
                

                xPos = WORD_SPACING;
            } else {
                xPos = ([tessFont getWidthForChar:[[lines objectAtIndex:i] characterAtIndex:j]]);
            }

            //set the color of the tessdata to be used for rendering later
            [tess setColors:colors[0] 
                      green:colors[1] 
                       blue:colors[2] 
                      alpha:colors[3]];
            

            for(int k = 0; k < [tess.vertices count]*2; k+=2)
            {                
                tessVertices = [tess getAllVertices];
                tessVertices[k] += currentXPos;
                tessVertices[k+1] -= (tanf(-BEAST_ANGLE_SPREAD/2+i*BEAST_ANGLE_SPREAD/[lines count])*tessVertices[k])+currentYPos;
                //NSLog(@"%d-  x:%f , y:%f",k,tessVertices[k],tessVertices[k+1]);
            }

            [beast addData:tess];

            currentXPos += xPos;
        }
        
        //Vertical spacing between lines
        yPos = ([tessFont getHeightForString:[lines objectAtIndex:i]])/4;
        currentYPos += yPos;
        currentXPos = BEAST_X_OFFSET;
        
    }
    
    //track which sentence we are at from the text
    sentenceIndex++;
    if (sentenceIndex >= [[textObject sentenceObjects] count])
        sentenceIndex = 0;
    
    //[lines release];
    //[words release];
    delete colors;
    
    //keep count
    totalBeastCount++;
    currentBeastCount++;
 
    //NSLog(@"ploop! a new beast was created at: %f, %f, %f", beast.pos->x, beast.pos->y, beast.pos->z);

    //return the beasty
    return beast;
}

-(void)updateSpray
{
    
        //update sprayed tokens
        KineticString* ks;
        
        int deleteCount = 0;
        int originalCount = [sprayTokens count];
        
        for (int i=0; i<originalCount; i++) {
            //get it
            ks = [sprayTokens objectAtIndex:i-deleteCount];
            
            //update it
            //NSLog(@"now:%f, last:%f, update:%f",now,lastUpdate,dt);
            [ks update:dt];
            
            //if the sprayed word is too old, remove it
            if ([ks age] > SPRAY_LIFETIME){
                [sprayTokens removeObjectAtIndex:i-deleteCount++];
            }
        }
      
}

-(void)updateBeasts
{
    //go through beasts
    if ([beasts count]==0) {
        [beasts addObject:[self createBeast]];
    }
    
    //beasts to remove
    NSMutableArray *doneBeasts = [[NSMutableArray alloc] init];
    
    //loop through beasts
    Beast *beast = nil;
    Vect3 *p = nil;
    for(int i = 0; i < [beasts count]; i++) {          
        //update the beast    
        beast = [beasts objectAtIndex:i];
        [beast update:dt];
        
        //update its position on the screen    
        p = [beast pos];
        [beast setScreenPosition:[self screenXYWithX:p->x Y:p->y andZ:p->z]];
        
        //if we are parsing the dragged beast
        if (readBeast == beast) {
           
            //increase beast camouflage (aka the highlight)
            [beast incCamouflage];
            
            //approach it towards the touch
            [beast approachWithX:[[touchPoints objectAtIndex:0] CGPointValue].x Y:[[touchPoints objectAtIndex:0] CGPointValue].y];
            
            //spray words from it
            KineticString *ks = [beast spray];
            if (ks != nil) {
                [sprayTokens addObject:ks];  
            }
        }
        //if any other beast
        else {
            
            //decrease beast camouflage
            [beast decCamouflage];
            
            //make it swim around
            [beast swim:current];
            
            //create a new beast if we are missing one
            if ([beasts count] < MAX_BEASTS) {
                //if the current beast count is less than the
                //dynamic maximum beast amount, the create one
                //if (currentBeastCount < MAX_BEASTS)
                BOOL canSpawn = YES;
                for (int i =0; i<[beasts count]; i++) {
                    
                    if ([beast pos]->x > width/2 &&
                        [beasts count]>MAX_PRE_SPAWN_BEASTS) {
                        canSpawn = NO;
                    }
                    
                }
                
                if (canSpawn)
                    [beasts addObject:[self createBeast]];                    

            } else {                 
                //if the beast is outside the view then remove it
                if ([beast isOutside:bounds]) [doneBeasts addObject:beast];
            }
        }    
        
    }
 
    //remove beasts
    for(Beast *b in doneBeasts)
        [self removeBeast:b];
    [doneBeasts release];
    
    //attenuate scatter for new beasts
    if (scatter > 0) {
        scatter -= 0.25f / (dt*1000);
        if (scatter < 0) scatter = 0;
        //NSLog(@"scatter: %f", scatter);
    }
}

//try to 'read' the beast under the given x,y position
-(void) readBeast:(CGPoint)point {
    
    float x = point.x;
    float y = point.y;
    
    Vect3* screenPos;
    float dx, dy, d;
    
    //find the closest beast under the point
    Beast* closestBeast = nil;
    float closestDist = READ_DISTANCE;
    for(int i = 0; i < [beasts count]; i++) {

        
        //get the distance to the beasty
        screenPos = [[beasts objectAtIndex:i] getScreenPos];
        dx = screenPos->x - x;
        dy = screenPos->y - y;
        d = sqrt(dx*dx + dy*dy);
        
        //check if we are close enough and closer than last
        if (d < closestDist) {
            closestBeast = [beasts objectAtIndex:i];
            closestDist = d;
        }
        else {
            [[beasts objectAtIndex:i] acceleration]->x += dx/d * TOUCH_PUSH_RADIUS/d * TOUCH_PUSH_FORCE;
            [[beasts objectAtIndex:i] acceleration]->y += dy/d * TOUCH_PUSH_RADIUS/d * TOUCH_PUSH_FORCE;
        }
        
    }
    
    //set the dragged beast
    readBeast = closestBeast;
    
    //increase the lens effect
//    if (readBeast != nil)
//        [readBeast setTargetRadius:BEAST_TARGET_RADIUS];
    

}
//calculate XYZ in 2D from 3D
- (CGPoint) screenXYWithX:(float)x Y:(float)y andZ:(float)z
{
	float ax = ((modelview[0] * x) + (modelview[4] * y) + (modelview[8] * z) + modelview[12]);
	float ay = ((modelview[1] * x) + (modelview[5] * y) + (modelview[9] * z) + modelview[13]);
	float az = ((modelview[2] * x) + (modelview[6] * y) + (modelview[10] * z) + modelview[14]);
	float aw = ((modelview[3] * x) + (modelview[7] * y) + (modelview[11] * z) + modelview[15]);
	
	float ox = ((projection[0] * ax) + (projection[4] * ay) + (projection[8] * az) + (projection[12] * aw));
	float oy = ((projection[1] * ax) + (projection[5] * ay) + (projection[9] * az) + (projection[13] * aw));
	float ow = ((projection[3] * ax) + (projection[7] * ay) + (projection[11] * az) + (projection[15] * aw));
	
	if(ow != 0)
    {
		ox /= ow;
        oy /= ow;
    }
	
		
	
	return CGPointMake((width * (1 + ox) / 2.0f), (height * (1 + oy) / 2.0f));
}

-(void) removeBeastAtIndex:(int) i
{
    [beasts removeObjectAtIndex:i];
}

-(void) removeBeast:(Beast*)b
{
    [beasts removeObject:b];
}

-(int) maxBeasts
{
    return 1;
}

-(void) printFTError:(int)error
{
    if(error!=0)
        std::cout << "ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" << std::endl;
}


-(void)drawBeasts
{
    for (int a =0; a<[beasts count]; a++)
    {
        
        Vect3 *p = [[beasts objectAtIndex:a] pos];
        
        glPushMatrix();

            glTranslatef(p->x, p->y, p->z);
            glScalef(beast_size, beast_size, 1);
            glGetFloatv(GL_PROJECTION_MATRIX, projection);
            glRotatef([[beasts objectAtIndex:a] rot]*RAD_TO_DEG + (PI-[[beasts objectAtIndex:a] forward])*RAD_TO_DEG,0,0,1);
            [[beasts objectAtIndex:a] draw];

        glPopMatrix();

    }
}

-(void)drawBackground
{

    static const GLfloat perlinTexCoord[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f,  0.0f,
        1.0f,  1.0f,
    };
    /*static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };*/
    static const GLfloat squareVertices[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f,  0.0f,
        1.0f,  1.0f,
    };
    
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glOrthof(0, 1, 0, 1, 0, 1);
    
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    glLoadIdentity();

        //glTranslatef(0,0,10);
        //glTranslatef(512,384,0);
        //glRotatef(90, 0, 0, 1);
        //glScalef(580, 775, 1);
        
        glEnable (GL_TEXTURE_2D);
    
    
        // IS THERE A REASON THIS IS HERE?? IT WAS CAUSING A BIG MEMORY LEAK	
        //glGenTextures(1, &backgroundTexture);
        //Generate texture
        glBindTexture(GL_TEXTURE_2D, backgroundTexture);
        // END
    
    
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        
        //avoid weird edges
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);        
        
        glColor4f(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2], BG_COLOR[3]);
    
        glTexImage2D (
                      GL_TEXTURE_2D,
                      0,
                      GL_RGB,
                      PN_WIDTH,
                      PN_HEIGHT,
                      0,
                      GL_RGB,
                      GL_UNSIGNED_BYTE,
                      //[perlinTex getPixels:counter Flow:-5.0f] //counter
                      [perlinTex getPixels:dt]
                      );
    
        //if (counter > DBL_MAX)
        //    counter = DBL_MIN;
        //else
            //counter += dt+0.1;
        counter += dt;
    
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
        glVertexPointer(2, GL_FLOAT, 0, squareVertices);
        glTexCoordPointer(2,GL_FLOAT, 0, perlinTexCoord);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
        glDisable(GL_TEXTURE_2D);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glPopMatrix();
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
}

-(void)drawSpray
{

        KineticString* ks;
        KineticString* lastks = nil;
        //float lastWidth = 0;
        float colors[4];
        
        
        //int deleteCount = 0;
        int originalCount = [sprayTokens count];
    
        for (int i=0; i<originalCount; i++) {
            
            ks = [sprayTokens objectAtIndex:i];
            
            //calculate ease in/out factor of OPACITY
            if ([ks age] < SPRAY_FADE_PERIOD)
                colors[3] = [ks age] / SPRAY_FADE_PERIOD;
            else if ([ks age] > SPRAY_LIFETIME - SPRAY_FADE_PERIOD)
                colors[3] = ([ks age] - SPRAY_LIFETIME) / SPRAY_FADE_PERIOD * -1;
            else
                colors[3] = 1;
            
            colors[0] = SPRAY_COLOR[0];
            colors[1] = SPRAY_COLOR[1];
            colors[2] = SPRAY_COLOR[2];
            colors[3] *= SPRAY_COLOR[3];
            
            
            //text
            glPushMatrix();
            
            [font setRotation:ks.ang*RAD_TO_DEG];
            [font setColourFilterRed:colors[0] green:colors[1] blue:colors[2] alpha:colors[3]];
            [font drawStringAt:OKPointMake([ks getPos]->x, [ks getPos]->y,-[ks getPos]->z) withString:[ks string]];
            glPopMatrix();
            
            lastks = ks;
            
        }

}

-(void)drawShadows
{
    for (int a =0; a<[beasts count]; a++)
    {   
        [[beasts objectAtIndex:a] drawShadow:shadow->getTextureId()];           
    }  
}


-(void)updateTouchParticles:(float)Dt
{
    
    //update particles
    [touchParticles update:Dt];
    
    //add new ones for each touch
    NSEnumerator *it = nil;
    it = [touchPoints objectEnumerator];
    
    //loop through touches
    //Beast *b;
    //int iid;
    Vect3 *v;
    id object;   
    
    for (int i=0; i<[touchPoints count]; i++) {

        object = [it nextObject];
        
        if(object == [NSNull null])
            continue;
        
        v = new Vect3([object CGPointValue].x, [object CGPointValue].y, 0);
        
        //get the matching beast, if any
        //b = (Beast)readBeasts.get(iid);

        //if we have a beast, and the touch is close to it, then don't make particles
        if (readBeast != nil &&  
            ABS(readBeast.pos->x - v->x) + ABS(readBeast.pos->y - v->y)  < TOUCH_PARTICLE_DIST_THRESHOLD)  //replacement for square root
            continue;
        
        //create a new particle
        //TouchParticle tp = getTouchParticle();
        TouchParticle *tp = [(TouchParticle*)[touchParticles recycle] retain];
        if (tp == nil)
            tp = [[TouchParticle alloc] init];
        
        [tp setPos:v];
        [tp setFriction:1 af:0.98f];
        [tp setFadeRate:TOUCH_FADE_RATE];
        [tp push:TOUCH_PARTICLE_PUSH*cos(randomf(0,TWO_PI))
                   y:TOUCH_PARTICLE_PUSH*sin(randomf(0,TWO_PI)) 
                   z:-1.0f];
        [tp spin:TOUCH_PARTICLE_SPIN];
        [tp setColor:TOUCH_PARTICLE_COLOR];
        [tp setScale:(randomf(touch_particle_minimum_size, touch_particle_maximum_size)*TOUCH_PARTICLE_SCALE)];
        [touchParticles add:tp];
        
        [tp release];
    }
    
}

//draw touch particles
-(void) drawTouchParticles
{
    NSEnumerator *it = nil;
    it = [touchParticles objectEnumerator];
    
    TouchParticle *tp;
    while((tp = [it nextObject]))
        [tp draw];
}

-(void)draw
{
    //clear background
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //enable vertex array to draw beasties
    glEnableClientState(GL_VERTEX_ARRAY);

    // keep track of modelview matrix, required for touch interaction
    glPushMatrix();
        glGetFloatv(GL_MODELVIEW_MATRIX, modelview);
    glPopMatrix();

    //increate frame count
    frameCount++;
    
    //millis since last draw
    now = [NSDate timeIntervalSinceReferenceDate];
    
    //if we are on the first frame after pausing the app, skip it
   // if (RESUME_APP) {
        //lastUpdate = now;
        //dt = 0.00001;
       // RESUME_APP = NO;
    //}
    
    dt = now-lastUpdate;
    
    animationRatio = BASE_FPS/(1/dt);
    if (!RESUME_APP) {
        
        
    //update the touch particles
    [self updateTouchParticles:dt];
        
    //update the sprayed words  
    [self updateSpray];    

    //update the beasts
    [self updateBeasts];
    
    
    
        glDisable(GL_DEPTH_TEST);
        glDepthMask(GL_FALSE);
        
        //draw the background
        [self drawBackground];
        
        //draw the shadows
        [self drawShadows];
        
        //draw particles
        [self drawTouchParticles];
        
        //draw sprayed words
        [self drawSpray];
        
        glEnable(GL_DEPTH_TEST);
        glDepthMask(GL_TRUE);
        
        //draw beasts
        [self drawBeasts];
    } else
        RESUME_APP = NO;
    
    

    //keep track of time
    lastUpdate = now;
    glDisableClientState(GL_VERTEX_ARRAY);
  
}

-(void) scatterBeasts 
{
    for (int i=0; i<[beasts count]; i++)
        [[beasts objectAtIndex:i] scatter];
};


-(void)drawDebugSq:(float)x y:(float)y z:(float)z size:(float)size
{
    
    GLfloat squareVertices[] = {
        x-size, y-size, z,
        x+size, y-size, z,
        x-size,  y+size, z,
        x+size,  y+size, z
    };
    
    static const GLubyte squareColors[] = {255};
    
    glPushMatrix();
        glVertexPointer(3, GL_FLOAT, 0, squareVertices);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
        glEnableClientState(GL_COLOR_ARRAY);

        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        glDisableClientState(GL_COLOR_ARRAY);
    glPopMatrix();
    

    
}


//get a random start position for a beast
- (Vect3*) getBeastStartPosition
{
    //double d = (MIN_BEAST_Z+arc4random()%(MAX_BEAST_Z-MIN_BEAST_Z));
    //NSLog(@"Z:%f",d);
    //return [self getBeastStartPosition:MIN_BEAST_Z+fmod(MIN_BEAST_Z+arc4random(),(MAX_BEAST_Z-MIN_BEAST_Z))];
    return [self getBeastStartPosition:randomf(min_beast_z, max_beast_z)];
}

- (Vect3*) getBeastStartPosition:(float)z
{
    int maxY = int(tan(_fovy/2*DEG_TO_RAD) * -z);
    int maxX = maxY * width/height;
    int w = 2*maxX + width;
    //int h = 2*maxY + height;
    
    
//    float rand = (arc4random()%500)/1000.0f;
//    
    // find a point based on the current direction
    float angle = atan2(current->y, current->x) + PI + randomf(-PI/4, PI/8);//randomf(-PI/8, PI/8);
//  float extraX = cos(angle) * (w/2);
    float x = width/2 + cos(angle) * (w/2 + SPAWNING_BORDER);
    //float y = height/4 + sin(angle) * (height/2);
    float y = height/2 + sin(angle) * (w/2 + SPAWNING_BORDER);
    
//    float x = width*(z/-MAX_BEAST_Z)+tan(_fovy*DEG_TO_RAD/2)*z+SPAWNING_BORDER+300;
//    float y = rand * maxHeight * (z/-MAX_BEAST_Z);
    //NSLog(@"%f",rand * maxHeight);
    //NSLog(@"Beast will be created at %f,%f,%f",x,y,z);
    
    NSLog(@"new beast at: %f, %f, %f : %f %f", x, y, z, angle, sin(angle));
    return new Vect3(x, y, z);
}

//mouse pressed
-(void) mousePressed:(NSMutableArray*)points {
    if (readBeast != nil) return;
    
    touchPoints = points;
    
    CGPoint test;

    for (int i=0; i<[points count]; i++)
        if ([points objectAtIndex:i] != [NSNull null])
            test = [[points objectAtIndex:i] CGPointValue];

    
    [self scatterBeasts];           //scatter beasts
    scatter = 1.0f;             //up the scatter factor for newly created beasts
    [self readBeast:test]; //check if we are close enough to a beast to drag
}

-(void) mouseDragged:(NSMutableArray*)points {
    
    if (readBeast != nil) return;
    [self mousePressed:points];
}

-(void) mouseReleased:(NSMutableArray*)points {
    if (readBeast == nil) return;
    
    // NSLog(@"Released at: %f,%f",point.x,point.y);
    

    // ONE TOUCH ONLY
    //touchPoints = [[NSArray alloc] init];
    touchPoints = points;


    
    //if we were dragging a beasty, then scare it away
    //and release it
    [readBeast scatter];
    [readBeast setTargetRadius:BEAST_RADIUS];
    
    for(int i = [readBeast tokenLoop]*[[[readBeast sentence] wordObjects] count] + [readBeast tokenIndex];
        i < SPRAY_WORDS_ON_TOUCH;
        i++) {
        //spray words from it
        KineticString* ks = [readBeast spray:(TWO_PI + TWO_PI/SPRAY_WORDS_ON_TOUCH*i) pushForce:SPRAY_WORDS_ON_TOUCH_FORCE override:true]; //TWO_PI/FPS*frameCount
        if (ks != nil) {
            //need to rewind age to control the highlight (this should be done better)
            ks.age -= i*SPRAY_INTERVAL;
            [sprayTokens addObject:ks];
        }
    }
    
    readBeast = nil;
}
    
    //check if a beast is being read for a certain touch id
    -(bool) isReadingBeastForId:(int)index
    { 
        return false;//(readBeasts.get(id) != null);
    }
    //check if a beast is being read/dragged
    -(bool) isReadingBeast:(Beast*)b
    {
        return readBeast==b;//readBeasts.containsValue(b); for multitouch... sorry
    }
    


@end
