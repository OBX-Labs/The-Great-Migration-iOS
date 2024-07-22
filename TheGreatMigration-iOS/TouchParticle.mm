//
//  TouchParticle.m
//  TheGreatMigration-iOS
//
//  Created by c-a on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchParticle.h"
#import "glu.h"
#import "MainSettings.h"
#import "GlobalUtils.h"

@implementation TouchParticle

- (id)init
{
    self = [super init];
    if (self) {
        //default attributes
        fadeRate = 0;
        fScale = 1;
        
        //create particle quad
        fVertices = new float[8];
        fVertices[0] = -0.5f; fVertices[1] = -0.5f;
        fVertices[2] = 0.5f; fVertices[3] = -0.5f;
        fVertices[4] = -0.5f; fVertices[5] = 0.5f;
        fVertices[6] = 0.5f;  fVertices[7] = 0.5f;
        
        //add some randomness
        //TODO this shouldn't call random that manu times for
        //each particles, there should be a few sets of precalculated
        //particles to loop through
        for(int i = 0; i < 8; i++)
            fVertices[i] += randomf(-0.2, 0.2);
    }
    
    return self;
}
   
-(void)setColor:(const float*)color
{
    clr[0] = color[0];
    clr[1] = color[1];
    clr[2] = color[2];
    clr[3] = color[3];
}

-(void)setScale:(float)s { fScale = s; }
-(void) setFadeRate:(float)f { fadeRate = f; }

-(void) update:(float)dt
{
    [super update:dt];
    
    //fade color
    if (clr[3] > 0) {
        clr[3] -= fadeRate*dt;
        if (clr[3] < 0) clr[3] = 0;
    }
}

-(void)draw
{
    glPushMatrix();
        glTranslatef(pos.x,pos.y,pos.z);
        glScalef(fScale,fScale,1);
        glRotatef(ang,0,0,1);
        
        glEnable (GL_BLEND);
        glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        glColor4f(clr[0], clr[1], clr[2], clr[3]);
        glVertexPointer(2, GL_FLOAT, 0, fVertices);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
        glDisable(GL_BLEND);
    glPopMatrix();
}

@end