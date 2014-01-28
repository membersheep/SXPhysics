//
//  SPGearJoint.h
//  SPPhysics
//
//  Created by Alessandro Maroso on 24/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "SPJoint.h"

// Gear joints are created by using a mixture of either revolute or prismatic joints connected to a static body. The static body must be the first parameter of the joints.
@interface SPGearJoint : SPJoint
{
    SPJoint* joint1;
    SPJoint* joint2;
    float ratio;
}

// The first revolute/prismatic joint attached to the gear joint.
@property (nonatomic, assign) SPJoint* joint1; // TO DO: maybe retain and release onExit

// The second revolute/prismatic joint attached to the gear joint.
@property (nonatomic, assign) SPJoint* joint2; // TO DO: maybe retain and release onExit

// The gear ratio.
@property (nonatomic) float ratio;

+(id) gearJoint;

@end
