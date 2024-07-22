//
//  KineticObject.h
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-08-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vect3.h"

@interface KineticObject : NSObject {
    float fps;
    float age;
    Boolean dead;
    
    Vect3 pos;
    Vect3 vel;
    Vect3 acc;
    float friction;
    
    float angAcc;
    float angVel;
    float ang;
    float angFriction;
}

@property(nonatomic) float age;
@property(nonatomic) float ang;

-(id)init;
-(id)initWithPos:(Vect3)Pos Acc:(Vect3)Acc Vel:(Vect3)Vel IsDead:(BOOL)IsDead Age:(float)Age Ang:(float)Ang AngAcc:(float)AngAcc AngVel:(float)AngVel AngFriction:(float)AngFriction Friction:(float)Friction fps:(float)fps;

-(void)update:(float)dt;
-(void)move:(float)animRatio;

-(void)push:(Vect3*)v;
-(void)push:(float)x y:(float)y z:(float)z;

-(void)spin:(float)f;

-(Vect3*)getPos;

-(void)setPos:(Vect3*)v;
-(void)setPos:(float)x y:(float)y z:(float)z;

-(KineticObject*)copy;

-(void)setFriction:(float)f af:(float)ag;
-(void)kill;
-(Boolean)isDead;

@end
