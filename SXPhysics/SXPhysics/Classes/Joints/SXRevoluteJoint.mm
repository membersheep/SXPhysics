//
//  SXRevoluteJoint.mm
//  SXPhysics
//
//  Created by Alessandro Maroso on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SXRevoluteJoint.h"
#import "SXWorld.h"
#import "SXJoint.h"

@implementation SXRevoluteJoint

@synthesize referenceAngle;
@synthesize enableLimit;
@synthesize lowerAngle;
@synthesize upperAngle; 
@synthesize enableMotor;    
@synthesize motorSpeed;
@synthesize maxMotorTorque;

#pragma mark Setters

// Enable/Disable the rotation limit
-(void) setEnableLimit:(BOOL)newEnableLimit
{
    enableLimit = newEnableLimit;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2RevoluteJoint* revoluteJoint = (b2RevoluteJoint*)joint;
        // enable the limiter in the b2Body
        revoluteJoint->EnableLimit(newEnableLimit);        
    }
}

// Set the lower angle limit
-(void) setLowerAngle:(float)newLowerAngle
{
    lowerAngle = newLowerAngle;
    // if the joint exists
    if (joint)
    {
        // cast to the right pointer type
        // set the lower angle limit in the b2Body
        b2RevoluteJoint* revoluteJoint = (b2RevoluteJoint*)joint;
        revoluteJoint->SetLimits(newLowerAngle, upperAngle);
    }
}

// Set the upepr angle limit
-(void) setUpperAngle:(float)newUpperAngle
{
    upperAngle = newUpperAngle;
    // if the joint exists
    if (joint)
    {
        // cast to the right pointer type
        b2RevoluteJoint* revoluteJoint = (b2RevoluteJoint*)joint;
        // set the upper angle limit in the b2Body
        revoluteJoint->SetLimits(lowerAngle, newUpperAngle);
    }
}

// Set lower and upper limits
-(void) setLimitsLower:(float)lower Upper:(float)upper
{
    [self setLowerAngle:lower];
    [self setUpperAngle:upper];
}

// Enable/Disable the joint motor
-(void) setEnableMotor:(BOOL)newEnableMotor
{
    enableMotor = newEnableMotor;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2RevoluteJoint* revoluteJoint = (b2RevoluteJoint*)joint;
        // enable/disable the b2RevoluteJoint motor
        revoluteJoint->EnableMotor(newEnableMotor);
    }
}

// Set the maximum motor torque
-(void) setMaxMotorTorque:(float)newMaxMotorTorque
{
    maxMotorTorque = newMaxMotorTorque;
    // if the joint exists
    if (joint) 
    {
        // cast to the right pointer type
        b2RevoluteJoint* revoluteJoint = (b2RevoluteJoint*)joint;
        // set the b2RevoluteJoint maximum torque
        revoluteJoint->SetMaxMotorTorque(newMaxMotorTorque);
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
        b2RevoluteJoint* revoluteJoint = (b2RevoluteJoint*)joint;
        // set the b2RevoluteJoint target speed
        revoluteJoint->SetMotorSpeed(newMotorSpeed);
    }
}

#pragma mark -
#pragma mark Creation and Destruction

// Default constructor.
+(id) revoluteJoint
{
//    NSLog(@"ALLOC REVOLUTE JOINT");
    return [[SXRevoluteJoint alloc] init];
}

// Destroys the joint
-(void) destroyJoint
{
//    NSLog(@"DESTROY REVOLUTE JOINT");
    [super destroyJoint];
}

// Sets up the joint definition and creates the joint
-(void) createJoint
{
//    NSLog(@"CREATE REVOLUTE JOINT");
    // create the joint definition and save a generic joint definition pointer
    jointData = new(b2RevoluteJointDef); // be careful to manage this memory in the dealloc
    
    // get a revolute joint pointer to set the variables
    b2RevoluteJointDef* revoluteJointData = (b2RevoluteJointDef*)jointData;
    
    // set the revolute joint definition from the properties
    revoluteJointData->localAnchorA = b2Vec2(localAnchorA.x / PTM_RATIO, localAnchorA.y / PTM_RATIO);
    revoluteJointData->localAnchorB = b2Vec2(localAnchorB.x / PTM_RATIO, localAnchorB.y / PTM_RATIO);
    revoluteJointData->referenceAngle = referenceAngle;
    revoluteJointData->enableLimit = enableLimit;
    revoluteJointData->lowerAngle = lowerAngle;
    revoluteJointData->upperAngle = upperAngle;
    revoluteJointData->enableMotor = enableMotor;
    revoluteJointData->motorSpeed = motorSpeed;
    revoluteJointData->maxMotorTorque = maxMotorTorque;  
    
    // call the superclass method to set the common variables and to create the joint
    [super createJoint];
}

// Init the particular variables of the revolute joint 
-(id) init
{
//    NSLog(@"INIT REVOLUTE JOINT");
    if ((self = [super init]))
	{
        // Init the instance variables
        jointType = revolute;
        localAnchorA = CGPointZero;
        localAnchorB = CGPointZero;
        referenceAngle = 0.0;
        enableLimit = NO;
        lowerAngle = 0.0;
        upperAngle = 0.0;
        enableMotor = NO;
        motorSpeed = 0.0;
        maxMotorTorque = 0.0;
	}
        return self;
}

-(void) dealloc
{
//    NSLog(@"DEALLOC REVOLUTE JOINT");
    // Free the memory previously allocated
    delete jointData;
    jointData = NULL;
    // Always call super dealloc
//    [super dealloc];
}

@end
