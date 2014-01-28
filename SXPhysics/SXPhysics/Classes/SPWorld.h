//
//  SPWorld.h
//  SPPhysics
//
//  Created by Alessandro Maroso on 27/09/12.
//  This class is based on the work by Isaac Drachman (29/07/11).
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#include <set>

// pixels to meters ratio
#define PTM_RATIO 32

// grams to kilograms ratio
#define GTKG_RATIO 1000

// forward declaration needed
@class SPBody;

// interface defining the ability to listen for contact events (collision, separation, overlapping)
@protocol ContactListenizer

-(void) onOverlapBody:(SPBody*)sprite1 andBody:(SPBody*)sprite2;
-(void) onSeparateBody:(SPBody*)sprite1 andBody:(SPBody*)sprite2;
-(void) onCollideBody:(SPBody*)sprite1 andBody:(SPBody*)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce;

@end

// Contact Relay to notify the contact events to the world class, this is the class that actually listens for the contact events.
class ContactRelay : public b2ContactListener
{
public:
    ContactRelay(id<ContactListenizer> listenizer);
    
	virtual void BeginContact(b2Contact* contact);
	virtual void EndContact(b2Contact* contact);
	virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
	
	id<ContactListenizer> listener; // the relay will be connected to an object that manages the contact events (i.e. SPWorld)
};

@interface SPWorld : SPSprite <ContactListenizer>
{
    int positionIterations, velocityIterations;
	CGPoint gravity;
	b2World *world;
	
	ContactRelay *contactRelay;
    
    std::set<b2Body*> bodiesScheduledForRemoval;
    
    CFTimeInterval lastTime;
    NSTimer *updateTimer;
}

@property (nonatomic) int positionIterations;
@property (nonatomic) int velocityIterations;
@property (nonatomic) CGPoint gravity;
@property (nonatomic, readonly) b2World *world;

-(void) safelyDestroyb2Body:(b2Body*)body;

-(void) onOverlapBody:(SPBody *)sprite1 andBody:(SPBody *)sprite2;
-(void) onSeparateBody:(SPBody *)sprite1 andBody:(SPBody *)sprite2;
-(void) onCollideBody:(SPBody *)sprite1 andBody:(SPBody *)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce;


@end
