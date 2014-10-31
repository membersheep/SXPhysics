//
//  SXDistanceJoint.m
//  SXPhysics
//
//  Created by Alessandro Maroso on 19/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SXDistanceJoint.h"
#import "SXWorld.h"
#import "SXBody.h"
#import "SXJoint.h"

@implementation SXDistanceJoint

@synthesize length;
@synthesize frequency;
@synthesize dampingRatio;

#pragma mark -
#pragma mark Setters

-(void) setLength:(float)newLength
{
    length = newLength;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2DistanceJoint* distanceJoint = (b2DistanceJoint*)joint;
        // set the new length of the distance joint
        distanceJoint->SetLength(newLength);        
    }
}

-(void) setFrequency:(float)newFrequency
{
    frequency = newFrequency;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2DistanceJoint* distanceJoint = (b2DistanceJoint*)joint;
        // set the new frequency of the distance joint
        distanceJoint->SetFrequency(newFrequency);        
    }
}

-(void) setDampingRatio:(float)newDampingRatio
{
    dampingRatio = newDampingRatio;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2DistanceJoint* distanceJoint = (b2DistanceJoint*)joint;
        // set the new damping ratio of the distance joint
        distanceJoint->SetDampingRatio(newDampingRatio);     
    }
}

#pragma mark -
#pragma mark Creation adn Destruction

+(id) distanceJoint
{
    return [[SXDistanceJoint alloc] init];
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
    jointData = new(b2DistanceJointDef); // be careful to manage this memory in the dealloc
    // get a distance joint pointer to set the variables
    b2DistanceJointDef* distanceJointData = (b2DistanceJointDef*)jointData;
    
    // set the distance joint definition from the properties
    b2Vec2 b2AnchorA = b2Vec2(localAnchorA.x / PTM_RATIO, localAnchorA.y / PTM_RATIO);
    b2Vec2 b2AnchorB = b2Vec2(localAnchorB.x / PTM_RATIO, localAnchorB.y / PTM_RATIO);
    distanceJointData->localAnchorA = b2AnchorA;
    distanceJointData->localAnchorB = b2AnchorB;
    
    // setup the length basing on the anchor points
    b2Vec2 distance = bodyA.body->GetWorldPoint(b2AnchorA) - bodyB.body->GetWorldPoint(b2AnchorB);
    distanceJointData->length = distance.Length();
    length = distance.Length() * PTM_RATIO;
    
    // setup the softness parameters
    distanceJointData->frequencyHz = frequency;
    distanceJointData->dampingRatio = dampingRatio;
    
    // call the superclass method to set the common variables and to create the joint
    [super createJoint];
}

// Init the particular variables of the distance joint
-(id) init
{
    if ((self = [super init]))
	{
        // Init the instance variables
        jointType = distance;
        localAnchorA = CGPointZero;
        localAnchorB = CGPointZero;
        length = PTM_RATIO;
        frequency = 0.0;
        dampingRatio = 0.0;
	}
    return self;
}

-(void) dealloc
{
    // Free the memory previously allocated
    delete jointData;
    jointData = NULL;
    // Always call super dealloc
//    [super dealloc];
}


@end
