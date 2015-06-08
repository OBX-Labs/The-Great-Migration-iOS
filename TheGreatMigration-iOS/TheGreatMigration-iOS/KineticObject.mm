//
//  KineticObject.m
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KineticObject.h"
#import "MainSettings.h"


@implementation KineticObject
@synthesize age, ang;

-(id)init
{
    
    self = [super init];
    if (self) {
        age = 0;
        dead = NO;
        
        pos = Vect3();
        acc = Vect3();
        vel = Vect3();
        
        ang = 0;
        angAcc = 0;
        angVel = 0;
        
        //default to no friction
        friction = 1;
        angFriction = 1;
    }
    
    return self;
}

-(id)initWithPos:(Vect3)Pos Acc:(Vect3)Acc Vel:(Vect3)Vel IsDead:(BOOL)IsDead Age:(float)Age Ang:(float)Ang AngAcc:(float)AngAcc AngVel:(float)AngVel AngFriction:(float)AngFriction Friction:(float)Friction fps:(float)fps
{

    self = [super init];
    if (self) {
        age = Age;
        dead = IsDead;
        
        pos = Pos;
        acc = Acc;
        vel = Vel;
        
        ang = Ang;
        angAcc = AngAcc;
        angVel = AngVel;
        
        //default to no friction
        friction = Friction;
        angFriction = AngFriction;
    }
    
    return self;
}

-(void)update:(float)dt
{
    //grow old
    fps = 1/0.015f;
    age += dt;
    
    //apply motion
    [self move:BASE_FPS/(float)fps];
}

-(void)move:(float)animRatio
{
    //apply acceleration
    vel.x += acc.x*animRatio;
    vel.y += acc.y*animRatio;
    vel.z += acc.z*animRatio;
    acc.x = acc.y = acc.z = 0;
    
    //apply friction
    vel = Vect3::vect_mul(vel,friction);   
    
    //apply velocity
    pos = pos+vel;
    
    //apply angular acceleration
    angVel += angAcc;
    angAcc = 0;
    
    //apply friction
    angVel = angVel * angFriction; 
    
    //apply angular velocity
    ang += angVel;
}

-(void)push:(Vect3*)v
{
    acc.x += v->x;
    acc.y += v->y;
    acc.z += v->z;
}

-(void)push:(float)x y:(float)y z:(float)z;
{
    acc.x += x;
    acc.y += y;
    acc.z += z;
}


-(void)spin:(float)f
{
    angAcc += f;
}

-(Vect3*)getPos
{
    return &pos;
}

-(void)setPos:(Vect3*)v
{
    pos.x = v->x; pos.y = v->y; pos.z = v->z;
}

-(void)setPos:(float)x y:(float)y z:(float)z
{
    pos.x = x; pos.y = y; pos.z = z;
}

-(void)setFriction:(float)f af:(float)af
{
    friction = f;
    angFriction = af;
}

-(void)kill
{
    dead = YES;
    age = angAcc = angVel = 0;
    acc.x = acc.y = acc.z = 0;
    vel.x = vel.y = vel.z = 0;
}

-(Boolean)isDead
{
    return dead;
}

-(KineticObject*)copy
{
    KineticObject* newKo = [[KineticObject alloc] initWithPos:pos
                                                          Acc:acc
                                                          Vel:vel
                                                       IsDead:dead 
                                                          Age:age
                                                          Ang:ang
                                                       AngAcc:angAcc 
                                                       AngVel:angVel 
                                                  AngFriction:angFriction 
                                                     Friction:friction 
                                                          fps:fps];
    return newKo;
}

-(void)dealloc
{
    [super dealloc];
}

@end
