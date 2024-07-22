/*
 *  NTGlyph.h
 *  WTSWTSTM
 *
 *  Created by Bruno Nadeau on 10-09-15.
 
    Modified by Charles-Antoine Dupont on 05-2011
 
 *  Copyright 2010 Obx Labs. All rights reserved.
 *
 */

#ifndef NTGLYPH_H
#define NTGLYPH_H

#import "NTTextObject.h"
#import "Vect3.h"
#import "NTTextGroup.h"
#import "Rectangle.h"


#define UNKNOWN	   0
#define FOREGROUND 1
#define BACKGROUND 2

//
// Glyph class representing a character.
//
// XXX: This one is a bit of a mess mostly because it's a C++
//      class but it needs to reference Obj-C entities like the
//      CCSprite class from Cocos2D. Because we can have an Obj-C
//      class that extends from a C++ class, the next best thing
//      would be to have the NTGlyph will only C++ code, and a
//      C++ class for each type of visual representation. In this
//      case we would have a base NTGlyph, and a NTCCGlyph that uses
//      elements from Cocos2D (CC).
//
class NTGlyph : public NTTextObject {

protected:

	
	//CCSprite* m_pSprite;	 //pointer to the cocos sprite tied to this glyph
	//CGPoint m_SpriteOffset;	 //original offset of the sprite (use for alignment)
    
    Vect3 position;
    Vect3 direction;
    
	float m_fKerning;		 //kerning value (this should not be here, it has a use specific to WTSWTSTM)
	
	//CCAction* m_pFadeToBg; //cocos action to fade to the background opacity
	//CCAction* m_pTintToBg; //cocos action to tint to the background color
	//CCAction* m_pSwim;	 //cocos action to swim around
	
	//CCAction* m_pFadeToFg; //cocos action to fade to the foreground opacity
	//CCAction* m_pTintToFg; //cocos action to tint to the foreground color
	//CCAction* m_pFollow;	 //cocos action to follow the leader (move to a target)
	
	int m_iState; //BACKGROUND is default, FOREGROUND when dragged
	
//	//position properties
//	float m_fTargetPositionX;
//	float m_fTargetPositionY;
//	float m_fTargetPositionVelocity;
//	bool m_bTargetPositionLock;
//	
//	//rotation properties
	float m_fTargetRotation;
	float m_fRotationVelocity;
	
	//color properties
//	int m_iTargetAlpha;
//	int m_iFadeSpeed;
	
	//true if the glyph is on the leader's line
//	bool m_bLed;
	
private:
	//init the glyph with a given character
	void init(unsigned short c);
	
	//get a new swim action
	//CCAction* swimAction(const CGFloat& velocity, const CGFloat& cloudSize, const CGFloat& targetX, const CGFloat& targetY);
	
	//get a new follow action
	//CCAction* followAction(const CGPoint& target, const float& velocity);
	
	//update the position
	//void updatePosition(float dt);
	
	//update the rotation
	//void updateRotation(float dt);
	
	//update the color
//	void updateColor(float dt);
	
public:
	//default constructor
	NTGlyph();
	
	//constructor
	NTGlyph(const char& c);
	
	//destructor
	virtual ~NTGlyph();
	
    virtual Rectangle getBounds();
    
	//get a pointer to the sprite tied to this glyph
	//CCSprite* sprite() { return m_pSprite; }
	
	//set the pointer to the sprite
	//void setSprite(CCSprite* sprite);
	
	//get kerning
	float kerning() { return m_fKerning; }
	
	//set kerning
	void setKerning(float k) { m_fKerning = k; }
	
    
   	unsigned short m_usChar; //unicode char
    
    
	//get the sprite offset
	//const CGPoint& spriteOffset() { return m_SpriteOffset; }
	
	//update the swim action
	//void updateSwimAction(const CGFloat& velocity, const CGFloat& cloudSize, const CGFloat& targetX, const CGFloat& targetY);
	//void swimTo(const float& targetX, const float& targetY, const float& velocity, const float& cloudSize);	
	
	//set the next target for the glyph to move to
	void moveBy(Vect3 goTo, Vect3 velocity, bool mustReachTarget);
	
	//set the next target for the glyph to move to
	void moveTo(Vect3 goTo, Vect3 velocity, bool mustReachTarget);
	
	//set the glyph to run in background mode
	//void runBackground();
	
	//update the follow action
	//void updateFollowAction(const CGPoint& target, const float& velocity);
	//void followTo(const Vect3& target, const float& velocity);
	
	//set the glyph to run in foreground mode
	//void runForeground();

	//rotate to a given angle at a given velocity
	void rotateTo(const float& angle, const float& velocity);
	
	//update the glyph
	//void update(float dt);

	//set background color
	//void setBgColor(int r, int g, int b, int a);
	
	//set foreground color
	//void setFgColor(int r, int g, int b, int a);
	
	//set the alpha to fade to
	//void fadeTo(int a, const int& speed);
	
	//set as on leader line or not
	//void setLed(bool l) { m_bLed = l; }
	
	//check if on leader line
	//bool isLed() { return m_bLed; }
						
};

#endif //NTGLYPH_H