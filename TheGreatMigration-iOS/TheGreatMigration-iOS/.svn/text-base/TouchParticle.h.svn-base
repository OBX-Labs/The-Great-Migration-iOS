//
//  TouchParticle.h
//  TheGreatMigration-iOS
//
//  Created by c-a on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KineticObject.h"
#import "GlobalUtils.h"

@interface TouchParticle : KineticObject {
    float *fVertices;  //vertices for the texture
    float fScale;      //scale of texture
    float clr[4];      //color
    float fadeRate;    //fading rate
}

-(id)init;
-(void)setColor:(const float*)color;
-(void)setScale:(float)s;
-(void)setFadeRate:(float)f;
-(void)update:(float)dt;
-(void)draw;

@end