//
//  SPPulleyJoint.h
//  SPPhysics
//
//  Created by Alessandro Maroso on 23/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "SPJoint.h"

// Defines a basic pulley. They often work better when combined with prismatic joints. You should also cover the the anchor points with static shapes to prevent one side from going to zero length.
@interface SPPulleyJoint : SPJoint
{
    CGPoint groundAnchorA;    
    CGPoint groundAnchorB;
	float lengthA;
    float lengthB;
    float ratio;
}
// The first ground anchor in world coordinates. This point never moves. Changing it after the joint creation won't affect the joint behaviour.
@property (nonatomic) CGPoint groundAnchorA;

// The second ground anchor in world coordinates. This point never moves. Changing it after the joint creation won't affect the joint behaviour.
@property (nonatomic) CGPoint groundAnchorB;

// The reference length for the segment attached to bodyA. This is controlled automatically by the simulation.
@property (nonatomic, readonly) float lengthA;

// The reference length for the segment attached to bodyB. This is controlled automatically by the simulation.
@property (nonatomic, readonly) float lengthB;

// The pulley ratio, used to simulate a block-and-tackle.
@property (nonatomic) float ratio;

+(id) pulleyJoint;

@end