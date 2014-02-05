//
//  SXGearJoint.mm
//  SXPhysics
//
//  Created by Alessandro Maroso on 24/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SXGearJoint.h"
#import "SXWorld.h"
#import "SXBody.h"
#import "SXJoint.h"

@implementation SXGearJoint

@synthesize joint1;
@synthesize joint2;
@synthesize ratio;

#pragma mark -
#pragma mark Setters

// Set the ratio.
-(void) setRatio:(float)newRatio
{
    ratio = newRatio;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2GearJoint* gearJoint = (b2GearJoint*)joint;
        // set the new ratio of the gear joint
        gearJoint->SetRatio(newRatio);     
    }
}

#pragma mark -
#pragma mark Getters

#pragma mark -
#pragma mark Creation and Destruction

// Default constructor.
+(id) gearJoint
{
    return [[SXGearJoint alloc] init];
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
    jointData = new(b2GearJointDef); // be careful to manage this memory in the dealloc
    
    // get a gear joint pointer to set the variables
    b2GearJointDef* gearJointData = (b2GearJointDef*)jointData;
    
    // set the gear joint definition from the properties
    gearJointData->joint1 = joint1.joint;
    gearJointData->joint2 = joint2.joint;
    gearJointData->ratio = ratio;
    
    // call the superclass method to set the common variables and to create the joint
    [super createJoint];
}

// Init the particular variables of the gear joint 
-(id) init
{
    if ((self = [super init]))
	{
        // Init the instance variables
        jointType = gear;
        joint1 = nil;
        joint2 = nil;
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
//    [super dealloc];
}

@end
