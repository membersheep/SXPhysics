//
//  SXGearJoint.h
//  SXPhysics
//
//  Created by Alessandro Maroso on 24/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "SXJoint.h"

// Gear joints are created by using a mixture of either revolute or prismatic joints connected to a static body. The static body must be the first parameter of the joints.
@interface SXGearJoint : SXJoint
{
    SXJoint* joint1;
    SXJoint* joint2;
    float ratio;
}

// The first revolute/prismatic joint attached to the gear joint.
@property (nonatomic, assign) SXJoint* joint1; // TO DO: maybe retain and release onExit

// The second revolute/prismatic joint attached to the gear joint.
@property (nonatomic, assign) SXJoint* joint2; // TO DO: maybe retain and release onExit

// The gear ratio.
@property (nonatomic) float ratio;

+(id) gearJoint;

@end
