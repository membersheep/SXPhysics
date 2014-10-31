//
//  SXRevoluteJoint.h
//  SXPhysics
//
//  Created by Alessandro Maroso on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "SXJoint.h"

@interface SXRevoluteJoint : SXJoint
{
	float referenceAngle;
	BOOL enableLimit;
	float lowerAngle;
	float upperAngle; 
	BOOL enableMotor;    
	float motorSpeed;
	float maxMotorTorque;
}

// The bodyB angle minus bodyA angle in the reference state (radians).
@property (nonatomic) float referenceAngle;
// A flag to enable joint limits.
@property (nonatomic) BOOL enableLimit;
// The lower angle for the joint limit (radians).
@property (nonatomic) float lowerAngle;
// The upper angle for the joint limit (radians).
@property (nonatomic) float upperAngle; 
// A flag to enable the joint motor.
@property (nonatomic) BOOL enableMotor;    
// The desired motor speed. Usually in radians per second. Not the actual speed but the target speed.
@property (nonatomic) float motorSpeed;
// The maximum motor torque used to achieve the desired motor speed. Usually in N-m.
@property (nonatomic) float maxMotorTorque;

+(id) revoluteJoint;

-(void) setLimitsLower:(float)lower Upper:(float)upper;

@end
