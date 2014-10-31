//
//  SXPrismaticJoint.h
//  SXPhysics
//
//  Created by Alessandro Maroso on 18/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "SXJoint.h"

@interface SXPrismaticJoint : SXJoint
{
    CGPoint localAxisA;
	float referenceAngle;
	BOOL enableLimit;
	float lowerTranslation;
	float upperTranslation; 
	BOOL enableMotor;    
	float motorSpeed;
	float maxMotorForce;
}

// The local translation unit axis in bodyA.
@property (nonatomic) CGPoint localAxisA;
// The constrained angle between the bodies: bodyB_angle - bodyA_angle.
@property (nonatomic) float referenceAngle;
// Enable/disable the joint limit.
@property (nonatomic) BOOL enableLimit;
// The lower translation limit, usually in meters.
@property (nonatomic) float lowerTranslation;
// The upper translation limit, usually in meters.
@property (nonatomic) float upperTranslation;
// Enable/disable the joint motor.
@property (nonatomic) BOOL enableMotor;
// The maximum motor torque, usually in N-m.
@property (nonatomic) float maxMotorForce;
// The desired motor speed in radians per second.
@property (nonatomic) float motorSpeed;

+(id) prismaticJoint;

-(void) setLimitsLower:(float)newLowerTranslation Upper:(float)newUpperTranslation;

@end
