//
//  SXBody.h
//  SXPhysics
//
//  Created by Alessandro Maroso on 27/09/12.
//  This class is based on the work by Isaac Drachman (29/07/11).
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Box2D.h"

@class SXWorld;
@class SXJoint;

typedef enum
{
	kStatic,
	kKinematic,
	kDynamic
} PhysicsType;

@interface SXBody : SPDisplayObjectContainer
{
    PhysicsType physicsType; 
	uint16 collisionType, collidesWithType; 
	BOOL active, sleepy, awake, solid, fixed, bullet;
	float density, friction, bounce;
	float damping, angularDamping;
	float angularVelocity;
	CGPoint velocity;
	b2Body *body; 
	SXWorld *world;
	
    // The array containing the joints attached to this body
    NSMutableArray *joints;
    // The shapes (fixtures) fixed to the b2Body
	NSMutableDictionary *shapesList;
    // The data structures to build the shapes 
	NSMutableDictionary *shapeDataList;

    NSTimer *updateTimer;
}

// The physic type of the b2Body
@property (nonatomic) PhysicsType physicsType;
// 16-bit masks to filter collisions of the shapes fixed to the body
@property (nonatomic) uint16 collisionType;
@property (nonatomic) uint16 collidesWithType;
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL sleepy;
@property (nonatomic) BOOL awake;
@property (nonatomic) BOOL solid;
@property (nonatomic) BOOL fixed;
@property (nonatomic) BOOL bullet;
@property (nonatomic) float density;
@property (nonatomic) float friction;
@property (nonatomic) float bounce;
@property (nonatomic) float damping;
@property (nonatomic) float angularDamping;
@property (nonatomic) float angularVelocity;
@property (nonatomic) CGPoint velocity;
// The b2Body carried for the simulation
@property (nonatomic, readonly) b2Body *body;
// The world containing this body
@property (nonatomic, assign) SXWorld *world;

+(id) body;

-(void) setDensity:(float)newDensity forShape:(NSString *)shapeName;
-(void) setFriction:(float)newFriction forShape:(NSString *)shapeName;
-(void) setBounce:(float)newBounce forShape:(NSString *)shapeName;

-(void) applyForce:(SPPoint*)force atLocation:(SPPoint*)location asImpulse:(BOOL)impulse;
-(void) applyForce:(SPPoint*)force atLocation:(SPPoint*)location;
-(void) applyForce:(SPPoint*)force asImpulse:(BOOL)impulse;
-(void) applyForce:(SPPoint*)force;
-(void) applyTorque:(float)torque asImpulse:(BOOL)impulse;
-(void) applyTorque:(float)torque;

-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize atLocation:(CGPoint)shapeLocation;
-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize;
-(void) addBoxWithName:(NSString *)shapeName;

-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius atLocation:(CGPoint)shapeLocation;
-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius;
-(void) addCircleWithName:(NSString *)shapeName;

-(void) addPolygonWithName:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices;

-(void) removeShapeWithName:(NSString *)shapeName;
-(void) removeShapes;

-(void) addChild:(SPDisplayObject *)child withBoxNamed:(NSString *)shapeName ofSize:(CGSize)shapeSize atLocation:(CGPoint)shapeLocation;
-(void) addChild:(SPDisplayObject *)child withBoxNamed:(NSString *)shapeName ofSize:(CGSize)shapeSize;
-(void) addChild:(SPDisplayObject *)child withBoxNamed:(NSString *)shapeName;

-(void) addChild:(SPDisplayObject *)child withCircleNamed:(NSString *)shapeName ofRadius:(float)shapeRadius atLocation:(CGPoint)shapeLocation;
-(void) addChild:(SPDisplayObject *)child withCircleNamed:(NSString *)shapeName ofRadius:(float)shapeRadius;
-(void) addChild:(SPDisplayObject *)child withCircleNamed:(NSString *)shapeName;

-(void) addChild:(SPDisplayObject *)child withPolygonNamed:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices;

-(void) addJoint:(SPJoint *)joint;
-(void) removeJoint:(SPJoint *)joint;

-(void) onOverlapBody:(SXBody*)sprite;
-(void) onSeparateBody:(SXBody*)sprite;
-(void) onCollideBody:(SXBody*)sprite withForce:(float)force withFrictionForce:(float)frictionForce;

@end
