//
//  SXDistanceJoint.h
//  SXPhysics
//
//  Created by Alessandro Maroso on 19/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "SXJoint.h"

@interface SXDistanceJoint : SXJoint
{
	float length;
    float frequency;
    float dampingRatio;
}

// The natural length between the anchor points. Manipulating the length can lead to non-physical behavior when the frequency is zero.
@property (nonatomic) float length;
// The 2 following variables define the "softness" of the joint.
// The mass-spring-damper frequency in Hertz. A value of 0 disables softness. Typically the frequency should be less than a half the frequency of the time step
@property (nonatomic) float frequency;
// The damping ratio (non-dimensional). 0 = no damping, 1 = critical damping.
@property (nonatomic) float dampingRatio;

+(id) distanceJoint;

@end
