//
//  SXWorld.mm
//  SXPhysics
//
//  Created by Alessandro Maroso on 27/09/12.
//  This class is based on the work by Isaac Drachman (29/07/11).
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SXWorld.h"
#import "SXBody.h"

#pragma mark ContactRelay Class

ContactRelay::ContactRelay(id<ContactListenizer> listenizer)
{
	// save the physics listener
	listener = listenizer;
}

void ContactRelay::BeginContact(b2Contact* contact)
{
	// extract the physics sprites from the contact
	SXBody *sprite1 = (__bridge SXBody *)contact->GetFixtureA()->GetBody()->GetUserData();
	SXBody *sprite2 = (__bridge SXBody *)contact->GetFixtureB()->GetBody()->GetUserData();
	
	// notify the physics sprites
	[sprite1 onOverlapBody:sprite2];
	[sprite2 onOverlapBody:sprite1];
	
	// notify the physics listener
	[listener onOverlapBody:sprite1 andBody:sprite2];
}

void ContactRelay::EndContact(b2Contact* contact)
{
	// extract the physics sprites from the contact
	SXBody *sprite1 = (__bridge SXBody *)contact->GetFixtureA()->GetBody()->GetUserData();
	SXBody *sprite2 = (__bridge SXBody *)contact->GetFixtureB()->GetBody()->GetUserData();
	
	// notify the physics sprites
	[sprite1 onSeparateBody:sprite2];
	[sprite2 onSeparateBody:sprite1];
	
	// notify the physics listener;
	[listener onSeparateBody:sprite1 andBody:sprite2];
}

void ContactRelay::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
	// extract the physics sprites from the contact
	SXBody *sprite1 = (__bridge SXBody *)contact->GetFixtureA()->GetBody()->GetUserData();
	SXBody *sprite2 = (__bridge SXBody *)contact->GetFixtureB()->GetBody()->GetUserData();
	
	// get the forces involved
	float force = 0.0f;
	float frictionForce = 0.0f;
	
	// for each contact point
	for (int i = 0; i < b2_maxManifoldPoints; i++)
	{
		// add the impulse to the total force
		force += impulse->normalImpulses[i];
		frictionForce += impulse->tangentImpulses[i];
	}
	
	// adjust the force units
	force *= PTM_RATIO / GTKG_RATIO;
	frictionForce *= PTM_RATIO / GTKG_RATIO;
	
	// notify the physics sprites
	[sprite1 onCollideBody:sprite2 withForce:force withFrictionForce:frictionForce];
	[sprite2 onCollideBody:sprite1 withForce:force withFrictionForce:frictionForce];
	
	// notify the physics listener
	[listener onCollideBody:sprite1 andBody:sprite2 withForce:force withFrictionForce:frictionForce];
}

#pragma mark -

@implementation SXWorld
@synthesize positionIterations;
@synthesize velocityIterations;
@synthesize gravity;
@synthesize world;

#pragma mark Setters
-(void) setGravity:(CGPoint)newGravity
{
	gravity = newGravity;
	
	// if world exists
	if (world)
	{
		// set the world gravity given a point/s value
		world->SetGravity(b2Vec2(gravity.x / PTM_RATIO, gravity.y / PTM_RATIO));
		
		// for each body in the world
		for (b2Body *body = world->GetBodyList(); body; body = body->GetNext())
		{
			// wake up the body
			body->SetAwake(true);
		}
	}
}

#pragma mark Creation and Destruction

-(id) init
{
	if ((self = [super init]))
	{
		// set up Box2D stuff for collisions
        world = new b2World(b2Vec2()); // flag doSleep has been removed in the current box2D version (v2.2.1)
		contactRelay = new ContactRelay(self); // setup the contact relay to connect with this SXWorld
		world->SetContactListener(contactRelay); // setup the contact listener for the box2d world object
		[self setGravity:CGPointZero];
		
		// set the number of physics iterations per Sparrow cycle
		velocityIterations = 1;
		positionIterations = 1;
		
		// update the timers
        
		// update the timers, call update every frame
        lastTime = CFAbsoluteTimeGetCurrent();
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
	}
	return self;
}

-(void) safelyDestroyb2Body:(b2Body*) body
{
    bodiesScheduledForRemoval.insert(body);
}

-(void) update
{
    CFTimeInterval time = CFAbsoluteTimeGetCurrent();
    float delta = time - lastTime;
	// if world exists
	if (world)
	{
		// update physics simulation
		world->Step(delta, velocityIterations, positionIterations);
        
        // destroy the bodies scheduled for deletion
        std::set<b2Body*>::iterator iter = bodiesScheduledForRemoval.begin();
        std::set<b2Body*>::iterator end = bodiesScheduledForRemoval.end();
        for (; iter != end; ++iter)
        {
            world->DestroyBody(*iter);
        }
        // clean the list of bodies scheduled for deletion
        bodiesScheduledForRemoval.clear();
	}
    lastTime = CFAbsoluteTimeGetCurrent();
}

- (void) dealloc
{
    NSLog(@"SXWorld dealloc called");
	// delete Box2D stuff
	delete contactRelay;
	delete world;
    [super dealloc];
}

#pragma mark Collision Management

-(void) onOverlapBody:(SXBody *)sprite1 andBody:(SXBody *)sprite2
{
}

-(void) onSeparateBody:(SXBody *)sprite1 andBody:(SXBody *)sprite2
{
}

-(void) onCollideBody:(SXBody *)sprite1 andBody:(SXBody *)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce;
{
}


@end
