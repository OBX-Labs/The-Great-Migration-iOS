#import "Beast.h"
#import "GlobalUtils.h"
//#import "vsinf.h"
//#import "vsinf.cpp"

Perlin noise = Perlin(4,0.4,1,1,0.5);
Vect3* current = new Vect3();
bool static_init = false;


@implementation Beast
@synthesize context, screenPos, pos, rot, forward, sentence, tokenLoop, tokenIndex;

-(id)initWithPos:(Vect3*)p Width:(int)Width Height:(int)Height;
{    
   
    self = [super init];
    if (self) {
        if(!static_init)
        {
            static_init = !static_init;
        }

        mouth = new Vect3();
        mouthDelta = new Vect3();
        tail = new Vect3(350, 0, 0);
        [self setMagnification:0.5 offset:0];
        [self setRadius:0];
        [self setTargetRadius:BEAST_RADIUS];
        
        fps = 0;
        age = 0;
        
        [self setSpeed:0.12f];
        _scatter = 0.1;
        scatterOffset = 1;
        camouflage = 0;
        
        screenPos = new Vect3();
        
        firstTokenIndex = 0;
        tokenIndex = 0;
        tokenLoop = 0;
        lastSpray = 0;//-SPRAY_INTERVAL;
        
        [self setPosition:p];
        [self setVelocity:new Vect3(0,0,0)];
        [self setAcceleration:new Vect3(0,0,0)];
        forward = PI;
        rot = PI;
        rotAcc = 1;
        rotVel = 0;
        
        height = Height;
        width = Width;
        
        dfrmText = [[NSMutableArray alloc] init];
        origText = [[NSMutableArray alloc] init];
        
        //apply scatter and calculate the offset angle to help the beast
        //move in the current's direction as much as possible
        [self applyScatter:1];
        offsetAngle = atan2(height/2 - pos->y, width/2 - pos->x) - atan2(acc->y, acc->x);
        [self setAcceleration:new Vect3(0,0,0)];
    }
    return self;
    
}




//set position
-(void) setPosition:(Vect3 *)p { pos = p; }

//set velocity
-(void) setVelocity:(Vect3 *)v { vel = v; }

//set acceleartion
-(void) setAcceleration:(Vect3 *)a { acc = a; }
-(Vect3*) acceleration 
{
    return acc;
}

//set forward angle
-(void) setForward:(float)f { forward = f; }

//decreases camouflage
-(void) decCamouflage {
    if (camouflage == 0) return;
    camouflage -= CAMOUFLAGE_RATE;
    if (camouflage < 0) camouflage = 0;
}

//increases camouflage
-(void) incCamouflage {
    if (camouflage == 1) return;
    camouflage += CAMOUFLAGE_RATE;
    if (camouflage > 1) camouflage = 1;
}

//apply random scatter behavior
-(void) scatter {
    [self setScatter:1];//random(0.8, 1.0);
    //scatterOffset = arc4random()%1000;//random(0, 1000) //change scatter offset to show effect every time
    scatterOffset = arc4random()%32;
}

//apply scatter behavior
-(void) setScatter:(float) s { _scatter = s; }

//set magnification factor and period offset
-(void) setMagnification:(float)mag offset:(float)offset {
    origMagnification = magnification = mag;
    magOffset = offset;
}

//get magnification factor
-(float) getMagnification { return magnification; }

//set speed
-(void) setSpeed:(float) s { speed = s; }

//set/get radius
-(void) setRadius:(float) r { radius = targetRadius = r; }
-(void) setTargetRadius:(float) r { targetRadius = r; }
-(float) getRadius { return radius; }

//get mouth
-(Vect3*) getMouth { return mouth; }

//set tail
-(void) setTail:(Vect3 *)v { tail = v; }

//Set sentence object
-(void) setText:(OKSentenceObject*) str {    sentence = str;    }

//set the original text from NextText and tesselate it
-(void) setOriginalText:(OKTessData*) root {
    NSLog(@"put something in setOriginalText");
//    origText = [self tesselate:root];
//    dfrmText = TessDatas(origText.size());
//    for(int i = 0; i < dfrmText.size(); i++)
//        dfrmText.at(i) = origText.at(i)->clone();
}

//get the beast's position on the screen
-(Vect3*) getScreenPos {
    return screenPos;
}
-(void) setScreenPosition:(CGPoint)sp {
    screenPos->x = sp.x;
    screenPos->y = sp.y;
    screenPos->z = 0;
}

//update the beast
-(void) update:(float)dt {
    
    // update fps and 
    // grow old
    fps = 1/dt;
    age += dt;
    
    //adjust magnification factor
    magnification = origMagnification + cos(age/BREATHING_SPEED + magOffset)*BREATHING_SCALE;
    
    //slowly decrease scatter factor
    if (_scatter > 0) {
        _scatter -= SCATTER_ATTENUATION / (dt*1000);
        if (_scatter < 0) _scatter = 0;
    }
    
    //adjust the radius if necessary
    if (radius != targetRadius) {
        float rd = targetRadius - radius;
        int dir = rd < 0 ? -1 : 1;
        if (rd*dir < RADIUS_RATE) radius = targetRadius;
        else radius += RADIUS_RATE * dir;
    }
    
    //apply acceleration
    [self applyAcceleration];    
    //apply velocity
    [self applyVelocity];
    
    //update the mouth position
    mouth->x = mouth->y = cos( rot ) * radius/20;
    //mouth->y = cos( rot ) * radius/20;
    
    //deform behaviour (lens + tail)
    [self deform];
}

//swim behavior
-(void) swim:(Vect3*)current {
    [self applyCurrent:current multiplier:1-_scatter];
    [self applyScatter:_scatter];
}

//deform behaviour (lens + tail)
-(void) deform {
    float a;
    float rtfX, rtfY;
    float cosa;
    float sina;
    
    //go through glyphs
    for(int j = 0; j < [origText count]; j++) {
        
        dfrmData = [dfrmText objectAtIndex:j];
        origData = [origText objectAtIndex:j];
        
        //go through all vertices
        dfrmVertices = [dfrmData getAllVertices];//new GLfloat[[origData.vertices count]*2+1];        
        origVertices = [origData getAllVertices];

        //NSLog(@"---------:%f",[origData getAllVertices][10]);
        
            for(int i = 0; i < [origData.vertices count]; i++)
            {                

                // Get the control point position.
                // mouth delta
                //float mouthX = mouth->x;
                //float mouthY = mouth->y;
                //float oVX = origVertices[(i*2)];
                //float oVY = origVertices[(i*2)+1];
                
                mouthDelta->x = mouth->x - origVertices[(i*2)];
                mouthDelta->y = mouth->y - origVertices[(i*2)+1];
                
                mouthDist = mouthDelta->mag();
                
                //lens
                scaleFactor = radius - (radius - 1) / (mouthDist + 1);

                //if (i==0) {
                    //NSLog(@"oVX:%f, oVY:%f, mX:%f, mY:%f, mDX:%f, mDY:%f, mDist:%f, scaleFac:%f", oVX, oVY, mouthX, mouthY, mouthDelta->x,mouthDelta->y,mouthDist,scaleFactor);                    
                //}

                
                //if ( mouthDist != 0.0 )
                //{
                    mouthDist += 0.001;
                    newdx = -mouthDelta->x + (magnification * -mouthDelta->x / mouthDist) * scaleFactor;
                    newdy = -mouthDelta->y + (magnification * -mouthDelta->y / mouthDist) * scaleFactor;
                //}
                //else
                //{
                    //newdx = -mouthDelta->x;
                    //newdy = -mouthDelta->y;
                //}

                //tail
                a = newdx / TAIL_BEND_FACTOR;
                a *= a;
                a *= -rotVel;

                cosa = cos(a);
                sina = sin(a);
                
                newdx -= mouth->x;
                newdy -= mouth->y;
                rtfX = newdx * cosa - newdy * sina;
                rtfY = newdx * sina + newdy * cosa;
                newdx = rtfX + mouth->x;
                newdy = rtfY + mouth->y;

                // APPLY
                //float interm = origVertices[i*2] + mouthDelta->x + newdx;
                //dfrmVertices[i*2] = interm;
                dfrmVertices[i*2] = origVertices[i*2] + mouthDelta->x + newdx;
                dfrmVertices[i*2+1] = origVertices[i*2+1] + mouthDelta->y + newdy;

            }
    }
}


//approach towards x,y point
-(void) approachWithX:(float)X Y:(float)Y {

    //get screen position
    Vect3 *spos = [self getScreenPos];
    
    //calculate distance to point                           
    float dx = X - spos->x;
    float dy = Y - spos->y;   
    float d = sqrt(dx*dx + dy*dy);
    
    if (d > APPROACH_THRESHOLD) {
        acc->x += dx/d * APPROACH_SPEED;
        acc->y += dy/d * APPROACH_SPEED;
    }
    
}

////sprays the next word from the string
-(KineticString*) spray 
{
    if (age-lastSpray > SPRAY_INTERVAL*2)
        firstTokenIndex = tokenIndex;
    else if (tokenIndex < firstTokenIndex)
        firstTokenIndex = tokenIndex;
    
    return [self spray:PI+(tokenIndex-firstTokenIndex)*PI/16 pushForce: 4.0+0.08*(tokenIndex-firstTokenIndex+1) override:NO]; //pushForce: +0.5*(tokenIndex-firstTokenIndex+1)
}

-(KineticString*) spray:(float)pushAngle pushForce:(float)pushForce override:(BOOL)override {

    
    //do nothing if the last spray was too recent
    if (!override && age-lastSpray < SPRAY_INTERVAL)
    {
        //lastSpray = age;
        return nil;
    }
    
    //add a new token
    NSString* kSString = [[[sentence wordObjects] objectAtIndex:tokenIndex++] word];
    //tokenIndex = (tokenIndex+1)%[[sentence wordObjects] count];
    KineticString* ks = [[KineticString alloc] initWithString:kSString];
    ks.parent = id;
    ks.group = tokenLoop;
    [ks setPos:pos->x y:pos->y z:pos->z-10];
    [ks setFriction:0.995f af:0.95f];
    [ks push:pushForce*cos(pushAngle) y:-pushForce*sin(pushAngle) z:-0.1];
    [ks spin:(rotVel*SPRAY_ANGULAR_FORCE)];
    
    //loop back to the first token if need
    //adjust time so that there is an pause before it loops back
    if (tokenIndex == [[sentence wordObjects] count] && [[sentence wordObjects] count] != 0) {
        tokenIndex = 0;
        tokenLoop++;
        lastSpray = age+SPRAY_LOOP_INTERVAL; //;
    }
    //keep track of time
    else {
        lastSpray = age;
    }
    
    //return the sprayed string
    return ks;
}

//apply acceleration
-(void) applyAcceleration {
    
    //add acceleration
    vel->x += acc->x*BASE_FPS/fps;
    vel->y += acc->y*BASE_FPS/fps;
    //vel->x += acc->x;
    //vel->y += acc->y;
    
    //reset acceleration
    acc->x = 0;
    acc->y = 0;
    
    //apply friction
    vel->x *= ATTENUATION;
    vel->y *= ATTENUATION;
    
    //calculate target rotation based on velocity
    targetRot = atan2(vel->y, vel->x) + forward;
    if (targetRot == rot) return;
    
    //rotate towards the target rotation
    if (targetRot < 0) targetRot += TWO_PI;
    else if (targetRot > TWO_PI) targetRot -= TWO_PI;
    
    //calculate angular distance
    float dRot = targetRot - rot;  //-2PI - 2PI
    float dir = dRot < 0 ? -1 : 1;
    if (dRot*dir > PI) { dRot += TWO_PI*-dir; dir *= -1; }
    
    rotVel += dir*PI/1024;

    // TAIL GLITCH FIX
    if (rotVel*(rotVel<0?-1:1)>0.03)
        rotVel *= ANGULAR_ATTENUATION;
    
    rot += rotVel;
    
    if(rot < 0) rot += TWO_PI;
    if(rot > TWO_PI) rot -= TWO_PI;
}

//apply velocity
-(void) applyVelocity { *pos+vel; }

//apply current force
-(void) applyCurrent:(Vect3*)current multiplier:(float)multiplier {
    //noiseDetail(4, 0.4f);
    //float angle = (noise.Get( pos->x/1000.0f, pos->y/1000.0f, pos->z )*2-1)*PI/8 + atan2(current->y, current->x);    
    float x = pos->x < 0 ? -pos->x : pos->x;
    float y = pos->y < 0 ? -pos->y : pos->y;
    float z = pos->z < 0 ? -pos->z : pos->z;
    float angle = (noise.Get( x/1000, y/1000, z/1000 )*2-1)*PI/8 + atan2(current->y, current->x);     
    
    // Update the agent's position / rotation
    acc->x += multiplier * cos( angle ) * CURRENT_STRENGTH * speed;
    acc->y += multiplier * sin( angle ) * CURRENT_STRENGTH * speed;  
    
    //NSLog(@"angle:%f",angle);
}

//apply scatter force
-(void) applyScatter:(float)multiplier {
    if (multiplier == 0) return;
    
    //noiseDetail(4, 0.4f);
    //float angle = noise.Get( pos->x/1000.0f, pos->y/1000.0f, pos->z - scatterOffset ) * TWO_PI + offsetAngle;
    float x = pos->x < 0 ? -pos->x : pos->x;
    float y = pos->y < 0 ? -pos->y : pos->y;
    float angle = noise.Get( x/1000, y/1000, scatterOffset ) * TWO_PI + offsetAngle;
    //NSLog(@"angle: %f noise: %f %f %f %f", angle, noise.Get( x/1000, y/1000, scatterOffset ), x, y, scatterOffset);
    
    // Update the agent's position / rotation
    acc->x += multiplier * cos( angle ) * SCATTER_STRENGTH * speed;
    acc->y += multiplier * sin( angle ) * SCATTER_STRENGTH * speed;
    
    //NSLog(@"acc after scatter: %f, %f (%f : %f : %f)", acc->x, acc->y, multiplier, speed, angle);
    //NSLog(@"Acc X: %f, Y:%f",acc->x,acc->y);
}

//check if beast is outside bounds
//bool isOutside(Rectangle2D.Float bounds) {
//    return !bounds.contains(pos->x, pos->y);
//}

//draw
-(void) draw {
    
    
    /*NSLog(@"Beast:(%f,%f,%f) Screen:(%f,%f)",pos->x,pos->y,pos->z,
                                                screenX(pos->x, pos->y, pos->z),
                                                screenY(pos->x, pos->y, pos->z));
    */
    
        
    
    // glTranslatef([beast pos]->x, [beast pos]->y, [beast pos]->z); 
    // glRotatef([beast rot] + (PI-[beast forward]),0,0,1);        
    glPushMatrix();

    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glScalef(0.73, 0.73, 1);
    
    
    
    
    //draw glypsh  
    for(int j = 0; j < [dfrmText count]; j++) {
        dfrmData = [dfrmText objectAtIndex:j];
        
        GLfloat colors[4];
        colors[0] = [dfrmData getRed];
        colors[1] = [dfrmData getGreen];    
        colors[2] = [dfrmData getBlue];
        colors[3] = [dfrmData getAlpha];
        
        if (camouflage != 0) {
            colors[0] += (CAMOUFLAGE_RED-colors[0])*camouflage;
            colors[1] += (CAMOUFLAGE_GREEN-colors[1])*camouflage;
            colors[2] += (CAMOUFLAGE_BLUE-colors[2])*camouflage;
            colors[3] += (CAMOUFLAGE_ALPHA-colors[3])*camouflage;
        }
        
        glColor4f(colors[0],colors[1],colors[2],colors[3]);
        
        if([dfrmData.ends count] > 0)
        {
            for(int i = 0; i < [dfrmData.shapes count]; i++)
            {   
                p = [dfrmData getVertices:i];
                glVertexPointer(2, GL_FLOAT, 0, p);
                GLint type = [dfrmData getType:i];
                GLint numVertices = [dfrmData numVertices:i];
                glDrawArrays(type, 0, numVertices);
            }
        }
    }

    glPopMatrix();    
    
    glDisable(GL_BLEND);

    
    //draw center cross
    if (_DEBUG) {
        //noFill();
        //stroke(0);
        //strokeWeight(2);
        glPushMatrix();
        glTranslatef(mouth->x, mouth->y, mouth->z);
            [self drawDebugSq:0 y:0 z:0 size:1.0f];
        glPopMatrix();
        
        float tailDist = tail->x-mouth->x;
        if (tailDist < 0) tailDist *= -1;
        
        float a;
        a = tailDist / TAIL_BEND_FACTOR;
        a *= a;
        a *= rotVel;
        
        float newdx = -tail->x;
        float newdy = -tail->y;
        float rtfX = newdx * cos(a) - newdy * sin(a);
        float rtfY = newdx * sin(a) + newdy * cos(a);
        newdx = rtfX + tail->x;
        newdy = rtfY + tail->y;      
        
        //stroke(255, 30, 45);
        glPushMatrix();
        glTranslatef(tail->x, tail->y, tail->z);
            [self drawDebugSq:0 y:0 z:0 size:1.0f];
        glPopMatrix();
    }    
    

    
}

-(void)drawDebugSq:(float)x y:(float)y z:(float)z size:(float)size
{
    
    GLfloat squareVertices[] = {
        x-size, y-size, z,
        x+size, y-size, z,
        x-size,  y+size, z,
        x+size,  y+size, z
    };
    
    glPushMatrix();
        
        glColor4f(1, 1, 1, 1);
        glVertexPointer(3, GL_FLOAT, 0, squareVertices);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glPopMatrix();
    
}

-(NSMutableArray*)getData{
    //draw glypsh
    return dfrmText;
}


//TEMPORARY!!!!!
-(void)addData:(OKTessData*) d
{
    [dfrmText addObject:[d copy]];
    [origText addObject:d];    
}

-(BOOL) isOutside:(CGRect)b
{
    return !CGRectContainsPoint(b,CGPointMake(pos->x, pos->y));
}

//draw shadow
-(void) drawShadow:(GLint)textureId {
    //if (shadow == NULL) return;
    
    glPushMatrix();

    glTranslatef(pos->x, pos->y, pos->z);
    glRotatef(rot + (PI-forward),0,0,1);
    glScalef(200.0, 200.0, 0);

    static const GLfloat shadowCoord[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f,  0.0f,
        1.0f,  1.0f,
    };
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };

    glEnable (GL_TEXTURE_2D);
    glEnable (GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);   
    
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);    
    glTexCoordPointer(2,GL_FLOAT,0, shadowCoord);
    
    glColor4f(0.0745, 0.2588, 0.3882, 0.8f);    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glBindTexture(GL_TEXTURE_2D, NULL);
    
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glPopMatrix();    
    
    glDisable(GL_TEXTURE_2D);
}

-(void) dealloc 
{
    delete pos;              //position
    delete screenPos;        //calculated 2d screen position
    delete vel;              //velocity
    delete acc;              //acceleration
    delete mouth;
    delete tail;
    [sentence release];
    [origText release];
    [dfrmText release];

    delete mouthDelta;
    delete pOrig;
    //delete p;

    [super dealloc];
}

//get number of glyphs in a NextText group
//-(int) getGlyphCount:(NTTextGroup*) root {
//    int count = 0;
////    NTGlyphIterator *it = new NTGlyphIterator(root);
////    while(it->hasNext()) {
////        it->next();
////        count++;
////    }
//    return count;
//}




@end