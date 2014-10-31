//
//  SXJoint.m
//  SXPhysics
//
//  Created by Alessandro Maroso on 11/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SXJoint.h"
#import "SXWorld.h"
#import "SXBody.h"

@implementation SXJoint

@synthesize jointType; 
@synthesize joint;
@synthesize world; 
@synthesize bodyA; 
@synthesize bodyB; 
@synthesize collideConnected; 
@synthesize localAnchorA;
@synthesize localAnchorB;

-(BOOL) isActive
{
    if(joint)
        return joint->IsActive();
    else return false;
}

#pragma mark -
#pragma mark Creation and Destruction

-(void) destroyJoint
{
	// if joint exists
	if (joint)
        //if SXWorld exists
        if(world)
            //if b2World exists
            if(world.world)
            {   
                // destroy the joint (not the bodies)
                world.world->DestroyJoint(joint);
                // annihilate the joint pointer
                joint = NULL;
            }
}

// Override this method to fill the particular joint definition and call [super createJoint] to execute the join creation part common to all the joint types.
-(void) createJoint
{
    // if SXWorld exists
	if (world)
	{
		// if the b2World exists
		if (world.world)
		{
			// if body exists
			if (joint)
			{
				// destroy it first
				[self destroyJoint];
			}
            // if the joint data has been created by a subclass
			if(jointData)
            {
                // set up the data structure for the joint creation (with the default values initialized)
                jointData->bodyA = bodyA.body;
                jointData->bodyB = bodyB.body;
                jointData->collideConnected = collideConnected;
                jointData->type = (jointType == revolute ? e_revoluteJoint :
                                   jointType == distance ? e_distanceJoint :
                                   jointType == prismatic ? e_prismaticJoint :
                                   jointType == wheel ? e_wheelJoint :
                                   jointType == weld ? e_weldJoint :
                                   jointType == pulley ? e_pulleyJoint :
                                   jointType == friction ? e_frictionJoint :
                                   jointType == gear ? e_gearJoint :
                                   jointType == touch ? e_mouseJoint :
                                   jointData->type);
                
                // create the joint
                joint = world.world->CreateJoint(jointData);			
                // give it a reference to this SXBody object
                joint->SetUserData(self);
                // TO DO: ADD THIS JOINT TO THE JOINTS LIST IN EACH BODY
                [bodyA addJoint:self];
                [bodyB addJoint:self];
            }
		}
	}
}

// Override this method to initialize the variables of the particular joint
-(id) init
{
	if ((self = [super init]))
	{
		jointType = unknown;
        jointData = NULL;
        joint = NULL;
        world = nil;
        bodyA = nil;
        bodyB = nil;
        collideConnected = NO;
        
        // Add the event listeners to trigger the creation/destruction of the joints
        [self addEventListener:@selector(onEnter:) atObject:self forType:SP_EVENT_TYPE_ADDED]; // execute onEnter when self is added to a sprite
        [self addEventListener:@selector(onExit:) atObject:self forType:SP_EVENT_TYPE_REMOVED]; // execute onExit when self is removed from a sprite
	}
	return self;
}

// When the SXJoint is added to a sprite we can create the joint
-(void) onEnter :(SPEvent*)event
{
	// skip if the joint already exists
	if (joint)
		return;
	// if physics manager is not defined
	if (!world)
	{
		// if parent is a physics manager
		if ([self.parent isKindOfClass:[SXWorld class]])
		{
			// use the parent as the physics manager
			world = (SXWorld*)self.parent;
		}
	}
	// if physics manager is defined now
	if (world)
	{
		// create the joint (this is usually overridden)
		[self createJoint];
	}
}

// When the SXJoint is removed from a sprite we can destroy the joint
-(void) onExit :(SPEvent*)event
{
	// destroy the joint
	[self destroyJoint];
    // annihilate world pointer (do not deallocate it)
    world = nil;
    // remove this joint from the bodies' joints lists
    [bodyA removeJoint:self];
    [bodyB removeJoint:self];
    // annihilate the bodies pointers
    bodyA = nil;
    bodyB = nil;
}

- (void) dealloc
{
	// remove joint from the world
	[self destroyJoint];
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
