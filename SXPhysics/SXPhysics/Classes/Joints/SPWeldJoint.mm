//
//  SPWeldJoint.mm
//  SPPhysics
//
//  Created by Alessandro Maroso on 24/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPWeldJoint.h"
#import "SPWorld.h"
#import "SPBody.h"
#import "SPJoint.h"

@implementation SPWeldJoint

@synthesize referenceAngle;
@synthesize frequency;
@synthesize dampingRatio;

#pragma mark -
#pragma mark Setters

// Set the frequency in hertz.
-(void) setFrequency:(float)newFrequency
{
    frequency = newFrequency;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WeldJoint* weldJoint = (b2WeldJoint*)joint;
        // set the new frequency of the weld joint
        weldJoint->SetFrequency(newFrequency);        
    }
}

// Set the damping ratio.
-(void) setDampingRatio:(float)newDampingRatio
{
    dampingRatio = newDampingRatio;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WeldJoint* weldJoint = (b2WeldJoint*)joint;
        // set the new damping ratio of the weld joint
        weldJoint->SetDampingRatio(newDampingRatio);     
    }
}

#pragma mark -
#pragma mark Getters

// Get the current reference angle between the two bodies.
-(float) referenceAngle
{
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WeldJoint* weldJoint = (b2WeldJoint*)joint;
        // get the actual reference angle
        return weldJoint->GetReferenceAngle(); 
    }
    else return 0.0;
}

#pragma mark -
#pragma mark Creation and Destruction

// Default constructor.
+(id) weldJoint
{
    return [[SPWeldJoint alloc] init];
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
    jointData = new(b2WeldJointDef); // be careful to manage this memory in the dealloc
    
    // get a weld joint pointer to set the variables
    b2WeldJointDef* weldJointData = (b2WeldJointDef*)jointData;
    
    // set the weld joint definition from the properties
    weldJointData->localAnchorA = b2Vec2(localAnchorA.x / PTM_RATIO, localAnchorA.y / PTM_RATIO);
    weldJointData->localAnchorB = b2Vec2(localAnchorB.x / PTM_RATIO, localAnchorB.y / PTM_RATIO);
    weldJointData->referenceAngle = bodyB.body->GetAngle() - bodyA.body->GetAngle();
    weldJointData->frequencyHz = frequency;
    weldJointData->dampingRatio = dampingRatio;
    
    // call the superclass method to set the common variables and to create the joint
    [super createJoint];
}

// Init the particular variables of the weld joint 
-(id) init
{
    if ((self = [super init]))
	{
        // Init the instance variables
        jointType = weld;
        localAnchorA = CGPointZero;
        localAnchorB = CGPointZero;
        referenceAngle = 0.0;
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
    [super dealloc];
}
@end
