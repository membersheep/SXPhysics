//
//  SPJoint.h
//  SPPhysics
//
//  Created by Alessandro Maroso on 11/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"

@class SPWorld;
@class SPBody;

typedef enum
{
    revolute,
    distance,
    prismatic,
    wheel,
    weld,
    pulley,
    friction,
    gear,
    touch, 
    unknown
} JointType;

@interface SPJoint : SPImage
{
    JointType jointType;
    b2Joint* joint;
    SPWorld* world; 
    SPBody* bodyA; 
    SPBody* bodyB; 
    BOOL collideConnected;
    CGPoint localAnchorA;
	CGPoint localAnchorB;
    
    b2JointDef* jointData;// The joint definition data (internal use only, property not needed)
}
// The type of joint
@property (nonatomic) JointType jointType;
// The box2d joint
@property (nonatomic, readonly) b2Joint* joint; 
// The world on which the joint will be created
@property (nonatomic, assign) SPWorld* world; // TO DO: maybe retain and release onExit
// First Body
@property (nonatomic, assign) SPBody* bodyA; // TO DO: maybe retain and release onExit
// Second Body
@property (nonatomic, assign) SPBody* bodyB; // TO DO: maybe retain and release onExit
// Set true if the bodies connected must collide with each other
@property (nonatomic) BOOL collideConnected; 
// The local anchor point relative to bodyA's origin. Changing it after the joint creation won't affect the joint behaviour.
@property (nonatomic) CGPoint localAnchorA;
// The local anchor point relative to bodyB's origin. Changing it after the joint creation won't affect the joint behaviour.
@property (nonatomic) CGPoint localAnchorB;

-(BOOL) isActive;

// Protected methods (to put in another "internal" header)
-(void) createJoint;
-(void) destroyJoint;

@end
