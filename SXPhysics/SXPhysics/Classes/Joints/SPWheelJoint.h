//
//  SPWheelJoint.h
//  SPPhysics
//
//  Created by Alessandro Maroso on 24/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "SPJoint.h"

@interface SPWheelJoint : SPJoint
{
    CGPoint localAxisA;
	BOOL enableMotor;    
	float motorSpeed;
	float maxMotorTorque;
    float frequency;
    float dampingRatio;
}

// The local translation axis in bodyA.
@property (nonatomic) CGPoint localAxisA;

// Enable/disable the joint motor.
@property (nonatomic) BOOL enableMotor;

// The maximum motor torque, usually in N-m.
@property (nonatomic) float maxMotorTorque;

// The desired motor speed in radians per second.
@property (nonatomic) float motorSpeed;

// Suspension frequency, zero indicates no suspension.
@property (nonatomic) float frequency;

// Suspension damping ratio, one indicates critical damping.
@property (nonatomic) float dampingRatio;

+(id) wheelJoint;

@end
