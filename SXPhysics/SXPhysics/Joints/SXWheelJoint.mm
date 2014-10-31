//
//  SXWheelJoint.mm
//  SXPhysics
//
//  Created by Alessandro Maroso on 24/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SXWheelJoint.h"
#import "SXWorld.h"
#import "SXBody.h"
#import "SXJoint.h"

@implementation SXWheelJoint

@synthesize localAxisA;
@synthesize enableMotor;    
@synthesize motorSpeed;
@synthesize maxMotorTorque;
@synthesize frequency;
@synthesize dampingRatio;

#pragma mark -
#pragma mark Setters


// Enable/Disable the joint motor.
-(void) setEnableMotor:(BOOL)newEnableMotor
{
    enableMotor = newEnableMotor;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WheelJoint* wheelJoint = (b2WheelJoint*)joint;
        // enable/disable the b2WheelJoint motor
        wheelJoint->EnableMotor(newEnableMotor);
    }
}

// Set the maximum motor torque.
-(void) setMaxMotorTorque:(float)newMaxMotorTorque
{
    maxMotorTorque = newMaxMotorTorque;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WheelJoint* wheelJoint = (b2WheelJoint*)joint;
        // set the b2WheelJoint maximum torque
        wheelJoint->SetMaxMotorTorque(newMaxMotorTorque);
    }
}

// Set the target motor speed.
-(void) setMotorSpeed:(float)newMotorSpeed
{
    motorSpeed = newMotorSpeed;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WheelJoint* wheelJoint = (b2WheelJoint*)joint;
        // set the b2WheelJoint target speed
        wheelJoint->SetMotorSpeed(newMotorSpeed);
    }
}

// Set the spring frequency in hertz. Setting the frequency to zero disables the spring.
-(void) setFrequency:(float)newFrequency
{
    frequency = newFrequency;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WheelJoint* wheelJoint = (b2WheelJoint*)joint;
        // set the new frequency of the wheel joint
        wheelJoint->SetSpringFrequencyHz(newFrequency);        
    }
}

// Set the spring damping ratio.
-(void) setDampingRatio:(float)newDampingRatio
{
    dampingRatio = newDampingRatio;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WheelJoint* wheelJoint = (b2WheelJoint*)joint;
        // set the new damping ratio of the wheel joint
        wheelJoint->SetSpringDampingRatio(newDampingRatio);     
    }
}

#pragma mark -
#pragma mark Getters

// Get the current joint translation, usually in meters.
-(float) getJointTranslation
{
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WheelJoint* wheelJoint = (b2WheelJoint*)joint;
        // get the joint translation and put it in points/s
        return wheelJoint->GetJointTranslation() * PTM_RATIO; 
    }
    else return 0.0;
}

// Get the current joint translation speed, usually in meters per secon-(d.
-(float) getJointSpeed
{
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2WheelJoint* wheelJoint = (b2WheelJoint*)joint;
        // get the joint speed and put it in points/s
        return wheelJoint->GetJointSpeed() * PTM_RATIO; 
    }
    else return 0.0;
}

#pragma mark -
#pragma mark Creation and Destruction

// Default constructor.
+(id) wheelJoint
{
    return [[SXWheelJoint alloc] init];
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
    jointData = new(b2WheelJointDef); // be careful to manage this memory in the dealloc
    
    // get a wheel joint pointer to set the variables
    b2WheelJointDef* wheelJointData = (b2WheelJointDef*)jointData;
    
    // set the wheel joint definition from the properties
    wheelJointData->localAnchorA = b2Vec2(localAnchorA.x / PTM_RATIO, localAnchorA.y / PTM_RATIO);
    wheelJointData->localAnchorB = b2Vec2(localAnchorB.x / PTM_RATIO, localAnchorB.y / PTM_RATIO);
    // there is no need to scale the local axis by the PTM_RATIO since it represents just a direction.
    wheelJointData->localAxisA = b2Vec2(localAxisA.x, localAxisA.y);
    wheelJointData->enableMotor = enableMotor;
    wheelJointData->motorSpeed = motorSpeed;
    wheelJointData->maxMotorTorque = maxMotorTorque;  
    
    // call the superclass method to set the common variables and to create the joint
    [super createJoint];
}

// Init the particular variables of the wheel joint 
-(id) init
{
    if ((self = [super init]))
	{
        // Init the instance variables
        jointType = wheel;
        localAnchorA = CGPointZero;
        localAnchorB = CGPointZero;
        localAxisA = CGPointMake(1.0, 0.0);
        enableMotor = NO;
        motorSpeed = 0.0;
        maxMotorTorque = 0.0;
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
