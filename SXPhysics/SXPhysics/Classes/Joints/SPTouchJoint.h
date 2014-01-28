//
//  SPTouchJoint.h
//  SPPhysics
//
//  Created by Alessandro Maroso on 22/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "SPJoint.h"

@interface SPTouchJoint : SPJoint
{
    CGPoint target;
	float maxForce;
    float frequency;
    float dampingRatio;
}

// There is no need to set any anchor point for this type of joint. They will be automatically generated internally.
// The initial world target point. This is assumed to coincide with the body anchor initially.
@property (nonatomic) CGPoint target;
// The maximum constraint force that can be exerted to move the candidate body. Usually you will express as some multiple of the weight (multiplier * mass * gravity).
@property (nonatomic) float maxForce;
// The response speed.
@property (nonatomic) float frequency;
// The damping ratio (non-dimensional). 0 = no damping, 1 = critical damping.
@property (nonatomic) float dampingRatio;

+(id) touchJoint;

@end
