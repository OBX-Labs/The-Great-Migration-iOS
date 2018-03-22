/*
 *  NTGlyph.mm
 *  WTSWTSTM
 *
 *  Created by Bruno Nadeau on 10-09-15.
 *
 *  Modified by Charles-Antoine Dupont on 05-2011
 *
 *  Copyright 2010 Obx Labs. All rights reserved.
 *
 */

#include "NTGlyph.h"


NTGlyph::NTGlyph() {
	init('\0'); //default null character
}

NTGlyph::NTGlyph(const char& c) {
	init(c);
}

NTGlyph::~NTGlyph() {
	//[m_pSprite release];
	
	//[m_pFadeToBg release];
	//[m_pTintToBg release];
	//[m_pSwim release];
	
	//[m_pFadeToFg release];
	//[m_pTintToFg release];
	//[m_pFollow release];
}

void NTGlyph::init(unsigned short c) {
	m_usChar = c;		//set the character
	//m_pSprite = NULL;	//no sprite yet
	//m_SpriteOffset = CGPointZero;	//default offset
	m_iState = UNKNOWN;	//unknown state
	m_fKerning = 0;		//no kerning
	
	//init actions
    position = Vect3();
    direction = Vect3();
    //velocity = Vect3(0,0,0);
	//m_pFadeToBg = nil;
	//m_pTintToBg = nil;
	//m_pSwim = nil;
	//m_pFadeToFg = nil;
	//m_pTintToFg = nil;
	//m_pFollow = nil;
	
	m_fTargetRotation = 0;		//degree
	m_fRotationVelocity = 90;	//degree per second
	
	//m_fTargetPositionX = 0;
	//m_fTargetPositionY = 0;
	//m_fTargetPositionVelocity = 0;
	//m_bTargetPositionLock = false;
	
//	m_iTargetAlpha = 0; //transparent
//	m_iFadeSpeed = 0;
//	
//	m_bLed = false;
}



Rectangle NTGlyph::getBounds()
{
    
    Rectangle rect = Rectangle();
    return rect;
}


/*void NTGlyph::setBgColor(int r, int g, int b, int a) {
	[m_pFadeToBg release];
	m_pFadeToBg = [[CCFadeTo actionWithDuration:2 opacity:a] retain];
	[m_pTintToBg release];
	m_pTintToBg = [[CCTintTo actionWithDuration:2 red:r green:g blue:b] retain];
}

void NTGlyph::setFgColor(int r, int g, int b, int a) {
	[m_pFadeToFg release];
	m_pFadeToFg = [[CCFadeTo actionWithDuration:1 opacity:a] retain];
	[m_pTintToFg release];
	m_pTintToFg = [[CCTintTo actionWithDuration:1 red:r green:g blue:b] retain];
}*/

//void NTGlyph::fadeTo(int a, const int& speed) {
//	m_iTargetAlpha = a;
//	m_iFadeSpeed = speed;
//}

/*void NTGlyph::updateSwimAction(const CGFloat& velocity, const CGFloat& cloudSize, const CGFloat& targetX, const CGFloat& targetY) {
	//if swim isn't done then wait
	if ((m_pSwim != nil) && ![m_pSwim isDone]) return;
	
	//get a new swim action
	[m_pSwim release];
	m_pSwim = swimAction(velocity, cloudSize, targetX, targetY);
	[m_pSwim retain];
	
	//run it
	[m_pSprite runAction:m_pSwim];
}*/

//void NTGlyph::swimTo(const CGFloat& targetX, const CGFloat& targetY, const CGFloat& velocity, const CGFloat& cloudSize) {
//
//	
//	//absolute position of the node
//	//Vect3 absPosition = [m_pSprite.parent convertToWorldSpace:m_pSprite.position];
//	
//	//difference between target and position
//	Vect3 targetDiff = Vect3(0,0,0);//ccp(targetX - absPosition.x, targetY - absPosition.y);
//	
//	//generate multiplier for some randomness
//	float multiplier = 1;//CCRANDOM_0_1();
//	
//	// new targets are always in the direction of the parent's center
//	Vect3 destDiff = Vect3(0,0,0);//CGPointZero;
//	if ((-cloudSize <= targetDiff.x) && (targetDiff.x <= cloudSize))
//		destDiff.x = multiplier*2*cloudSize-cloudSize;
//	else if (-cloudSize > targetDiff.x)
//		destDiff.x = multiplier*-cloudSize;
//	else
//		destDiff.x = multiplier*cloudSize;
//	
//	multiplier = 1;//CCRANDOM_0_1();
//	if ((-cloudSize <= targetDiff.y) && (targetDiff.y <= cloudSize))
//		destDiff.y = multiplier*2*cloudSize-cloudSize;
//	else if (-cloudSize > targetDiff.y)
//		destDiff.y = multiplier*-cloudSize;
//	else
//		destDiff.y = multiplier*cloudSize;
//	
//	// make sure the next target is inside the window
////	CGRect box = [m_pSprite boundingBox];
////	CGPoint absDest = ccp(absPosition.x + destDiff.x, absPosition.y + destDiff.y);
////	if (absDest.x-box.size.width/2 <= 0)
////		destDiff.x += cloudSize;
////	else if (absDest.x+box.size.width/2 >= size.width)
////		destDiff.x -= cloudSize;
////	
////	if (absDest.y-box.size.height/2 <= 0)
////		destDiff.y += cloudSize;
////	else if (absDest.y+box.size.height/2 >= size.height)
////		destDiff.y -= cloudSize;
//
//	//set the next hard target
//	moveBy(destDiff.x, destDiff.y, velocity, true);
//}

//void NTGlyph::moveBy(const CGFloat& targetX, const CGFloat& targetY, const CGFloat& velocity, bool mustReachTarget) {
//	//if motion isn't done then wait
//	if (m_bTargetPositionLock) return;
//	
//	//set target
//	CGPoint absPosition = [m_pSprite.parent convertToWorldSpace:m_pSprite.position];
//	m_fTargetPositionX = absPosition.x + targetX;
//	m_fTargetPositionY = absPosition.y + targetY;
//	m_fTargetPositionVelocity = velocity;
//	
//	//set the target lock
//	m_bTargetPositionLock = mustReachTarget;
//}

void NTGlyph::moveTo(Vect3 goTo, Vect3 velocity, bool mustReachTarget) {

	//set target
//	m_fTargetPositionX = targetX;
//	m_fTargetPositionY = targetY;
	//m_fTargetPositionVelocity = velocity;
	
	//set the target lock
	//m_bTargetPositionLock = mustReachTarget;
}

//void NTGlyph::updatePosition(float dt) {
//	//check if we need to move
//	//XXX?
//	
//	//difference to target
//	CGPoint absPosition = [m_pSprite.parent convertToWorldSpace:m_pSprite.position];
//	float diffX = m_fTargetPositionX-absPosition.x;
//	float diffY = m_fTargetPositionY-absPosition.y;
//	float diff = sqrtf(diffX*diffX + diffY*diffY);
//	
//	//motion for the amount of time spent since last frame
//	float delta = m_fTargetPositionVelocity * dt;
//	
//	//if we reached position, then unlock target if needed
//	if (diff < delta) {
//		//m_pSprite.position.x += m_fTargetPositionX - absPosition.x;
//		//m_pSprite.position.y += m_fTargetPositionY - absPosition.y;
//		m_pSprite.position = ccp(m_pSprite.position.x + m_fTargetPositionX - absPosition.x,
//								 m_pSprite.position.y + m_fTargetPositionY - absPosition.y);
//		m_bTargetPositionLock = false;
//	}
//	//else rotate towards target
//	else {
//		//m_pSprite.position.x += (diffX/diff) * delta;
//		//m_pSprite.position.y += (diffY/diff) * delta;
//		m_pSprite.position = ccp(m_pSprite.position.x + (diffX/diff)*delta,
//								 m_pSprite.position.y + (diffY/diff)*delta);
//	}
//}

/*CCAction* NTGlyph::swimAction(const CGFloat& velocity, const CGFloat& cloudSize, const CGFloat& targetX, const CGFloat& targetY) {
	//get the parent
	NTTextGroup* pParent = parent();
	if (pParent == NULL) return nil;
	
	//get the window size to limit motion
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	//absolute position of the node
	CGPoint absPosition = [m_pSprite.parent convertToWorldSpace:m_pSprite.position];

	//difference between target and position
	CGPoint targetDiff = ccp(targetX - absPosition.x, targetY - absPosition.y);

	//generate multiplier for some randomness
	CGFloat multiplier = CCRANDOM_0_1();
	
	// new targets are always in the direction of the parent's center
	CGPoint destDiff = CGPointZero;
	if ((-cloudSize <= targetDiff.x) && (targetDiff.x <= cloudSize))
		destDiff.x = multiplier*2*cloudSize-cloudSize;
	else if (-cloudSize > targetDiff.x)
		destDiff.x = multiplier*-cloudSize;
	else
		destDiff.x = multiplier*cloudSize;

	multiplier = CCRANDOM_0_1();
	if ((-cloudSize <= targetDiff.y) && (targetDiff.y <= cloudSize))
		destDiff.y = multiplier*2*cloudSize-cloudSize;
	else if (-cloudSize > targetDiff.y)
		destDiff.y = multiplier*-cloudSize;
	else
		destDiff.y = multiplier*cloudSize;

	// make sure the next target is inside the window
	CGRect box = [m_pSprite boundingBox];
	CGPoint absDest = ccp(absPosition.x + destDiff.x, absPosition.y + destDiff.y);
	if (absDest.x-box.size.width/2 <= 0)
		destDiff.x += cloudSize;
	else if (absDest.x+box.size.width/2 >= size.width)
		destDiff.x -= cloudSize;

	if (absDest.y-box.size.height/2 <= 0)
		destDiff.y += cloudSize;
	else if (absDest.y+box.size.height/2 >= size.height)
		destDiff.y -= cloudSize;
	
	//calculate the duration based on distance and velocity
	CGFloat distance = sqrtf(destDiff.x*destDiff.x + destDiff.y*destDiff.y);
	CGFloat duration = distance / velocity;
	
	//return the action
	return [CCMoveBy actionWithDuration:duration position:destDiff];
}*/

/*void NTGlyph::updateFollowAction(const CGPoint& target, const float& velocity)
{
	//if action isn't done then wait
	if ((m_pFollow != nil) && ![m_pFollow isDone]) return;

	//get a new follow action
	[m_pFollow release];	
	m_pFollow = followAction(target, velocity);
	[m_pFollow retain];
	
	//run it
	[m_pSprite runAction:m_pFollow];
}*/

/*CCAction* NTGlyph::followAction(const CGPoint& target, const float& velocity)
{
	//absolution position of the node
	CGPoint absPosition = [m_pSprite.parent convertToWorldSpace:m_pSprite.position];
	
	//difference between target and position
	CGPoint destDiff = ccp(target.x - absPosition.x, target.y - absPosition.y);
	float parentDistance = sqrtf(destDiff.x*destDiff.x + destDiff.y*destDiff.y);
	
	//only go a max of pixel at a time
	if (parentDistance > 25) {
		destDiff.x = destDiff.x/parentDistance*25;
		destDiff.y = destDiff.y/parentDistance*25;
	}
	
	//calculate duration based on distance and velocity
	float distance = sqrtf(destDiff.x*destDiff.x + destDiff.y*destDiff.y);
	float duration = distance / velocity;
	
	//return the action
	return [CCMoveBy actionWithDuration:duration position:destDiff];
}*/

//void NTGlyph::followTo(const Vect3& target, const float& velocity)
//{
//	//follow has priority so it can override the target lock
//	if (m_bTargetPositionLock) m_bTargetPositionLock = false;
//	
//	//set the next hard target
//	moveTo(target.x, target.y, velocity, false);
//}

void NTGlyph::rotateTo(const float& angle, const float& velocity) {
//  limit angle to -180 to 180
//	float newAngle = angle;
//	while(newAngle > 180) newAngle -= 360;
//	while(newAngle < -180) newAngle += 360;
//	
//	//if we hit rotation target then we can process this one
//	if (m_pSprite.rotation == m_fTargetRotation) {
//		m_fTargetRotation = newAngle;
//		m_fRotationVelocity = velocity;
//		m_fNextTargetRotation = angle;
//		m_fNextRotationVelocity = velocity;
//	}
//	//if we are rotating, then save for after we reach target
//	else {
//		m_fNextTargetRotation = newAngle;
//		m_fNextRotationVelocity = velocity;
//	}
}

//void NTGlyph::updateRotation(float dt) {
//	//check if we need to rotate
//	if (m_pSprite.rotation == m_fTargetRotation) return;
//	
//	//difference to target
//	float diff = m_fTargetRotation-m_pSprite.rotation;
//	
//	//limit angle to -180 to 180
//	while(diff > 180) diff -= 360;
//	while(diff < -180) diff += 360;
//	
//	//find the direction we are going in
//	int direction = diff > 0 ? 1 : -1;
//	
//	//rotation for the amount of time spent since last frame
//	float delta = m_fRotationVelocity * dt;
//	
//	//if we reached rotation, then check if we have
//	//a request to another angle to process
//	if (diff*direction < delta) {
//		m_pSprite.rotation = m_fTargetRotation;
//		
//		//queue next rotation
//		rotateTo(m_fNextTargetRotation, m_fNextRotationVelocity);
//	}
//	//else rotate towards target
//	else {
//		m_pSprite.rotation += delta*direction;
//	}
//}

//void NTGlyph::update(float dt) {
//	//update position
//	updatePosition(dt);
//	
//	//update rotation
//	updateRotation(dt);
//	
//	//update color/alpha
//	updateColor(dt);
//}

//void NTGlyph::updateColor(float dt) {
//	//difference to target
//	int diff = m_iTargetAlpha - m_pSprite.opacity;
//	if (diff == 0) return;	
//	
//	//motion for the amount of time spent since last frame
//	float delta = m_iFadeSpeed * dt;
//	
//	//get the direction
//	int direction = diff < 0 ? -1 : 1;
//	
//	//if we reached target, then set it
//	if (diff*direction < delta) {
//		m_pSprite.opacity = m_iTargetAlpha;
//	}
//	//else approach target
//	else {
//		m_pSprite.opacity += delta*direction;
//	}
//}

//void NTGlyph::setSprite(CCSprite* sprite) {
//	//same one, nothing to do
//	if (m_pSprite == sprite) return;
//	
//	//set sprite
//	[m_pSprite release];
//	m_pSprite = sprite;
//	[m_pSprite retain];
//	
//	//keep track of the original sprite offset
//	m_SpriteOffset.y = [sprite position].y;
//}

//void NTGlyph::runBackground() {
//	//if already in background then do nothing
//	if (m_iState == BACKGROUND) return;
//	
//	//reorder glyph
//	[m_pSprite.parent reorderChild:m_pSprite z:0];
//	
//	//stop actions
//	//[m_pSprite stopAllActions];
//	//[m_pSwim release];
//	//m_pSwim = nil;
//	//[m_pFollow release];
//	//m_pFollow = nil;
//	
//	//run fade and tint if they exists
//	//if (m_pFadeToBg != NULL) [m_pSprite runAction:m_pFadeToBg];
//	//if (m_pTintToBg != NULL) [m_pSprite runAction:m_pTintToBg];
//	
//	//set state
//	m_iState = BACKGROUND;
//}

//void NTGlyph::runForeground() {
//	//if already in foreground then do nothing
//	if (m_iState == FOREGROUND) return;
//	
//	//reorder glyph
//	[m_pSprite.parent reorderChild:m_pSprite z:10];
//	
//	//stop actions
//	//[m_pSprite stopAllActions];
//	//[m_pSwim release];
//	//m_pSwim = nil;
//	//[m_pFollow release];
//	//m_pFollow = nil;
//	
//	//run fade and tint if they exists
//	//if (m_pFadeToFg != NULL) [m_pSprite runAction:m_pFadeToFg];
//	//if (m_pTintToFg != NULL) [m_pSprite runAction:m_pTintToFg];	
//	
//	//set state
//	m_iState = FOREGROUND;
//}
