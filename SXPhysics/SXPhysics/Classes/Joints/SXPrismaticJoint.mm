//
//  SXPrismaticJoint.m
//  SXPhysics
//
//  Created by Alessandro Maroso on 18/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SXPrismaticJoint.h"
#import "SXWorld.h"
#import "SXJoint.h"

@implementation SXPrismaticJoint

@synthesize localAxisA;
@synthesize referenceAngle;
@synthesize enableLimit;
@synthesize lowerTranslation;
@synthesize upperTranslation;
@synthesize enableMotor;
@synthesize maxMotorForce;
@synthesize motorSpeed;

#pragma mark Setters

// Enable/Disable the shift limit
-(void) setEnableLimit:(BOOL)newEnableLimit
{
    enableLimit = newEnableLimit;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2PrismaticJoint* prismaticJoint = (b2PrismaticJoint*)joint;
        // enable the limiter in the b2PrismaticJoint
        prismaticJoint->EnableLimit(newEnableLimit);        
    }
}

// Set the lower translation limit
-(void) setLowerTranslation:(float)newLowerTranslation
{
    lowerTranslation = newLowerTranslation;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2PrismaticJoint* prismaticJoint = (b2PrismaticJoint*)joint;
        // set the lower limit in the b2PrismaticJoint
        prismaticJoint->SetLimits(newLowerTranslation / PTM_RATIO, upperTranslation / PTM_RATIO);
    }
}

// Set the upepr translation limit
-(void) setUpperTranslation:(float)newUpperTranslation
{
    upperTranslation = newUpperTranslation;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2PrismaticJoint* prismaticJoint = (b2PrismaticJoint*)joint;
        // set the upper limit in the b2PrismaticJoint
        prismaticJoint->SetLimits(lowerTranslation / PTM_RATIO, newUpperTranslation / PTM_RATIO);
    }
}

// Set lower and upper limits
-(void) setLimitsLower:(float)newLowerTranslation Upper:(float)newUpperTranslation
{
    [self setLowerTranslation:newLowerTranslation];
    [self setUpperTranslation:newUpperTranslation];
}

// Enable/Disable the joint motor
-(void) setEnableMotor:(BOOL)newEnableMotor
{
    enableMotor = newEnableMotor;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2PrismaticJoint* prismaticJoint = (b2PrismaticJoint*)joint;
        // enable the motor in the b2PrismaticJoint
        prismaticJoint->EnableMotor(newEnableMotor);
    }
}

// Set the maximum motor torque
-(void) setMaxMotorForce:(float)newMaxMotorForce
{
    maxMotorForce = newMaxMotorForce;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2PrismaticJoint* prismaticJoint = (b2PrismaticJoint*)joint;
        // set the maxMotorForce in the b2PrismaticJoint
        prismaticJoint->SetMaxMotorForce(newMaxMotorForce / PTM_RATIO * GTKG_RATIO);
    }
}

// Set the target motor speed
-(void) setMotorSpeed:(float)newMotorSpeed
{
    motorSpeed = newMotorSpeed;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2PrismaticJoint* prismaticJoint = (b2PrismaticJoint*)joint;
        // set the b2RevoluteJoint target speed
        prismaticJoint->SetMotorSpeed(newMotorSpeed / PTM_RATIO);
    }
}

#pragma mark -
#pragma mark Creation and Destruction

+(id) prismaticJoint
{
    return [[SXPrismaticJoint alloc] init];
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
    jointData = new(b2PrismaticJointDef); // be careful to manage this memory in the dealloc
    
    // get a prismatic joint pointer to set the variables
    b2PrismaticJointDef* prismaticJointData = (b2PrismaticJointDef*)jointData;
    
    // set the prismatic joint definition from the properties
    prismaticJointData->localAnchorA = b2Vec2(localAnchorA.x / PTM_RATIO, localAnchorA.y / PTM_RATIO);
    prismaticJointData->localAnchorB = b2Vec2(localAnchorB.x / PTM_RATIO, localAnchorB.y / PTM_RATIO);
    // there is no need to scale the local axis by the PTM_RATIO since it represents just a direction.
    prismaticJointData->localAxisA = b2Vec2(localAxisA.x, localAxisA.y);
    prismaticJointData->referenceAngle = referenceAngle;
    prismaticJointData->enableLimit = enableLimit;
    prismaticJointData->lowerTranslation = lowerTranslation / PTM_RATIO;
    prismaticJointData->upperTranslation = upperTranslation / PTM_RATIO;
    prismaticJointData->enableMotor = enableMotor;
    prismaticJointData->motorSpeed = motorSpeed / PTM_RATIO;
    prismaticJointData->maxMotorForce = maxMotorForce / PTM_RATIO * GTKG_RATIO;  
    
    // call the superclass method to set the common variables and to create the joint
    [super createJoint];
}

// Init the particular variables of the prismatic joint
-(id) init
{
    if ((self = [super init]))
	{
        // Init the instance variables
        jointType = prismatic;
        localAnchorA = CGPointZero;
        localAnchorB = CGPointZero;
        localAxisA = CGPointMake(1.0, 0.0);
        referenceAngle = 0.0;
        enableLimit = NO;
        lowerTranslation = 0.0;
        upperTranslation = 0.0;
        enableMotor = NO;
        motorSpeed = 0.0;
        maxMotorForce = 0.0;
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
