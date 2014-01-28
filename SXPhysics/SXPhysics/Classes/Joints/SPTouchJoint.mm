//
//  SPTouchJoint.mm
//  SPPhysics
//
//  Created by Alessandro Maroso on 22/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPTouchJoint.h"
#import "SPWorld.h"
#import "SPBody.h"
#import "SPJoint.h"

@implementation SPTouchJoint

@synthesize target;
@synthesize maxForce;
@synthesize frequency;
@synthesize dampingRatio;

#pragma mark -
#pragma mark Setters

-(void) setTarget:(CGPoint)newTarget
{
    target = newTarget;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2MouseJoint* mouseJoint = (b2MouseJoint*)joint;
        // set the new max force of the mouse joint
        b2Vec2 b2Target = b2Vec2(newTarget.x / PTM_RATIO, newTarget.y / PTM_RATIO);
        mouseJoint->SetTarget(b2Target);        
    }
}

-(void) setMaxForce:(float)newMaxForce
{
    maxForce = newMaxForce;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2MouseJoint* mouseJoint = (b2MouseJoint*)joint;
        // set the new max force of the mouse joint
        mouseJoint->SetMaxForce(newMaxForce);        
    }
}

-(void) setFrequency:(float)newFrequency
{
    frequency = newFrequency;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2MouseJoint* mouseJoint = (b2MouseJoint*)joint;
        // set the new frequency of the mouse joint
        mouseJoint->SetFrequency(newFrequency);        
    }
}

-(void) setDampingRatio:(float)newDampingRatio
{
    dampingRatio = newDampingRatio;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2MouseJoint* mouseJoint = (b2MouseJoint*)joint;
        // set the new damping ratio of the mouse joint
        mouseJoint->SetDampingRatio(newDampingRatio);     
    }
}

#pragma mark -
#pragma mark Getters

-(CGPoint) localAnchorA
{
    if (joint) 
    {
        // cast to the right pointer type
        b2MouseJoint* mouseJoint = (b2MouseJoint*)joint;
        // get the bodyA
        b2Body* b2BodyA = mouseJoint->GetBodyA();
        // get the A anchor point as global box2d point, and transform it to Sparrow local coordinates
        localAnchorA = CGPointMake( b2BodyA->GetLocalPoint( mouseJoint->GetAnchorA() ).x * PTM_RATIO, b2BodyA->GetLocalPoint( mouseJoint->GetAnchorA() ).y * PTM_RATIO );   
    }
    return localAnchorA;
}

-(CGPoint) localAnchorB
{
    if (joint) 
    {
        // cast to the right pointer type
        b2MouseJoint* mouseJoint = (b2MouseJoint*)joint;
        // get the bodyB
        b2Body* b2BodyB = mouseJoint->GetBodyB();
        // get the B anchor point as global box2d point, and transform it to Sparrow local coordinates
        localAnchorB = CGPointMake( b2BodyB->GetLocalPoint( mouseJoint->GetAnchorB() ).x * PTM_RATIO, b2BodyB->GetLocalPoint( mouseJoint->GetAnchorB() ).y * PTM_RATIO );      
    }
    return localAnchorB;
}

#pragma mark -
#pragma mark Creation and Destruction

+(id) touchJoint
{
    return [[SPTouchJoint alloc] init];
}

// Destroys the joint
-(void) destroyJoint
{
    [super destroyJoint];
}

// Sets up the joint definition and creates the joint
-(void) createJoint
{
    // create the joint definition and save a generic joint definition pointer
    jointData = new(b2MouseJointDef); // be careful to manage this memory in the dealloc
    // get a mouse joint pointer to set the variables
    b2MouseJointDef* mouseJointData = (b2MouseJointDef*)jointData;
    
    // set the mouse joint max force
    mouseJointData->maxForce = maxForce / PTM_RATIO * GTKG_RATIO;
    
    // set the mouse joint target scaling it from points to meters.
    mouseJointData->target = b2Vec2(target.x / PTM_RATIO, target.y / PTM_RATIO);
    // the local anchor points will be set internally by the b2MouseJoint, we just have to adjust the getters

    // setup the damping parameters
    mouseJointData->frequencyHz = frequency;
    mouseJointData->dampingRatio = dampingRatio;
    
    // call the superclass method to set the common variables and to create the joint
    [super createJoint];
}

// Init the particular variables of the mouse joint
-(id) init
{
    if ((self = [super init]))
	{
        // Init the instance variables
        jointType = touch;
        localAnchorA = CGPointZero;
        localAnchorB = CGPointZero;
        target = CGPointZero;
        maxForce = 0.0;
        frequency = 5.0;
        dampingRatio = 0.7;
	}
    return self;
}

-(void) dealloc
{
    NSLog(@"DEALLOC MOUSE JOINT");
    // Free the memory previously allocated
    delete jointData;
    jointData = NULL;
    // Always call super dealloc
    [super dealloc];
}

@end
