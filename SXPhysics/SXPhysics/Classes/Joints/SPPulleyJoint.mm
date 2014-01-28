//
//  SPPulleyJoint.mm
//  SPPhysics
//
//  Created by Alessandro Maroso on 23/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPPulleyJoint.h"
#import "SPWorld.h"
#import "SPBody.h"
#import "SPJoint.h"

@implementation SPPulleyJoint

@synthesize groundAnchorA;
@synthesize groundAnchorB;
@synthesize lengthA;
@synthesize lengthB;
@synthesize ratio;

#pragma mark -
#pragma mark Setters

#pragma mark -
#pragma mark Getters

-(float) lengthA
{
    if (joint) 
    {
        // cast to the right pointer type
        b2PulleyJoint* pulleyJoint = (b2PulleyJoint*)joint;
        // get the length
        lengthA = pulleyJoint->GetLengthA() * PTM_RATIO;
    }
    return lengthA;
}

-(float) lengthB
{
    if (joint) 
    {
        // cast to the right pointer type
        b2PulleyJoint* pulleyJoint = (b2PulleyJoint*)joint;
        // get the length
        lengthB = pulleyJoint->GetLengthB() * PTM_RATIO;
    }
    return lengthB;
}

#pragma mark -
#pragma mark Creation and Destruction

+(id) pulleyJoint
{
    return [[SPPulleyJoint alloc] init];
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
    jointData = new(b2PulleyJointDef); // be careful to manage this memory in the dealloc
    // get a mouse joint pointer to set the variables
    b2PulleyJointDef* pulleyJointData = (b2PulleyJointDef*)jointData;
    
    // set the anchor points
    b2Vec2 b2AnchorA = b2Vec2(localAnchorA.x / PTM_RATIO, localAnchorA.y / PTM_RATIO);
    b2Vec2 b2AnchorB = b2Vec2(localAnchorB.x / PTM_RATIO, localAnchorB.y / PTM_RATIO);
    pulleyJointData->localAnchorA = b2AnchorA;
    pulleyJointData->localAnchorB = b2AnchorB;
    b2Vec2 b2GroundA = b2Vec2(groundAnchorA.x / PTM_RATIO, groundAnchorA.y / PTM_RATIO);
    b2Vec2 b2GroundB = b2Vec2(groundAnchorB.x / PTM_RATIO, groundAnchorB.y / PTM_RATIO);
    pulleyJointData->groundAnchorA = b2GroundA;
    pulleyJointData->groundAnchorB = b2GroundB;
    
    // set the lengths
    b2Vec2 distanceA = bodyA.body->GetWorldPoint(b2AnchorA) - b2GroundA;
    pulleyJointData->lengthA = distanceA.Length();
    lengthA = distanceA.Length() * PTM_RATIO;
    b2Vec2 distanceB = bodyB.body->GetWorldPoint(b2AnchorB) - b2GroundB;
    pulleyJointData->lengthB = distanceB.Length();
    lengthB = distanceB.Length() * PTM_RATIO;
    
    // set the ratio
    pulleyJointData->ratio = ratio;
    
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
        localAnchorA = CGPointMake(-PTM_RATIO, 0.0);
        localAnchorB = CGPointMake(PTM_RATIO, 0.0);
        groundAnchorA = CGPointMake(PTM_RATIO, PTM_RATIO);
        groundAnchorB = CGPointMake(-PTM_RATIO, PTM_RATIO);
        lengthA = 0.0;
        lengthB = 0.0;
        ratio = 1.0;
	}
    return self;
}

-(void) dealloc
{
    // Free the memory previously allocated
    delete jointData;
    jointData = NULL;
    // Always call super dealloc
    [super dealloc];
}

@end
