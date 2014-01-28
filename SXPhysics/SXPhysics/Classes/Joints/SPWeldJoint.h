//
//  SPWeldJoint.h
//  SPPhysics
//
//  Created by Alessandro Maroso on 24/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "SPJoint.h"

// A weld joint essentially glues two bodies together with a "soft" bound on the angle between teh two bodies.
@interface SPWeldJoint : SPJoint
{
	float referenceAngle;
    float frequency;
    float dampingRatio;
}

// The bodyB angle minus bodyA angle in the reference state (radians). It is automatically set by box2d, you can just query its value.
@property (nonatomic, readonly) float referenceAngle;

// The mass-spring-damper frequency in Hertz. Rotation only. Disable softness with a value of 0.
@property (nonatomic) float frequency;

// The damping ratio. 0 = no damping, 1 = critical damping.
@property (nonatomic) float dampingRatio;

+(id) weldJoint;

@end
