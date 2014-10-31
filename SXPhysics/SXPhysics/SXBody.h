//
//  SXBody.h
//  SXPhysics
//
//  Created by Alessandro Maroso on 27/09/12.
//  This class is based on the work by Isaac Drachman (29/07/11).
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "SXPhysics.h"

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
@property (nonatomic, assign) PhysicsType physicsType;

// 16-bit masks to filter collisions of the shapes fixed to the body
@property (nonatomic, assign) uint16 collisionType;
@property (nonatomic, assign) uint16 collidesWithType;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL sleepy;
@property (nonatomic, assign) BOOL awake;
@property (nonatomic, assign) BOOL solid;
@property (nonatomic, assign) BOOL fixed;
@property (nonatomic, assign) BOOL bullet;
@property (nonatomic, assign) float density;
@property (nonatomic, assign) float friction;
@property (nonatomic, assign) float bounce;
@property (nonatomic, assign) float damping;
@property (nonatomic, assign) float angularDamping;
@property (nonatomic, assign) float angularVelocity;
@property (nonatomic, assign) CGPoint velocity;

/// The b2Body carried for the simulation
@property (nonatomic, readonly) b2Body *body;

/// The world containing this body
@property (nonatomic, assign) SXWorld *world;

/// Returns an empty body
+(id) body;

/// Returns a body initialized with data from a Physics Editor plist file
+(SXBody*)createBodyForBodyName:(NSString*)name fromFile:(NSString*)plist;

-(void) setDensity:(float)newDensity forShape:(NSString *)shapeName;
-(void) setFriction:(float)newFriction forShape:(NSString *)shapeName;
-(void) setBounce:(float)newBounce forShape:(NSString *)shapeName;
-(void) applyForce:(SPPoint*)force atLocation:(SPPoint*)location asImpulse:(BOOL)impulse;
-(void) applyForce:(SPPoint*)force atLocation:(SPPoint*)location;
-(void) applyForce:(SPPoint*)force asImpulse:(BOOL)impulse;
-(void) applyForce:(SPPoint*)force;
-(void) applyTorque:(float)torque asImpulse:(BOOL)impulse;
-(void) applyTorque:(float)torque;

/// Manually add a fixture definition to the list of fixture that will be created
-(void)addFixture:(b2FixtureDef *)fixtureDef withName:(NSString *)shapeName;

/// Creates a box shaped fixture with specified size and location relative to the center of the SPBody
-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize atLocation:(CGPoint)shapeLocation;

/// Createsreates a box shaped fixture with specified size located at the center of the SPBody
-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize;

/// Createsreates a box shaped fixture containing the sprite (AABB style) and add it to the body at its location.
-(void) addBoxWithName:(NSString *)shapeName;

/// Createsreates a circle shaped fixture with specified radius and location relative to the center of the SPBody
-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius atLocation:(CGPoint)shapeLocation;

/// Createsreates a circle shaped fixture with specified radius located at the center of the SPBody
-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius;

/// Createsreates a circle shaped fixture containing the sprite (AABB style) and add it to the body at its location.
-(void) addCircleWithName:(NSString *)shapeName;

/// Creates a user-defined polygon fixture
-(void) addPolygonWithName:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices;

-(void) removeShapeWithName:(NSString *)shapeName;
-(void) removeShapes;
-(void) addChild:(SPDisplayObject *)child withFixture:(b2FixtureDef *)fixtureDef withName:(NSString *)fixtureName;
-(void) addChild:(SPDisplayObject *)child withBoxNamed:(NSString *)shapeName ofSize:(CGSize)shapeSize atLocation:(CGPoint)shapeLocation;
-(void) addChild:(SPDisplayObject *)child withBoxNamed:(NSString *)shapeName ofSize:(CGSize)shapeSize;
-(void) addChild:(SPDisplayObject *)child withBoxNamed:(NSString *)shapeName;
-(void) addChild:(SPDisplayObject *)child withCircleNamed:(NSString *)shapeName ofRadius:(float)shapeRadius atLocation:(CGPoint)shapeLocation;
-(void) addChild:(SPDisplayObject *)child withCircleNamed:(NSString *)shapeName ofRadius:(float)shapeRadius;
-(void) addChild:(SPDisplayObject *)child withCircleNamed:(NSString *)shapeName;
-(void) addChild:(SPDisplayObject *)child withPolygonNamed:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices;
-(void) addJoint:(SXJoint *)joint;
-(void) removeJoint:(SXJoint *)joint;
-(void) onOverlapBody:(SXBody*)sprite;
-(void) onSeparateBody:(SXBody*)sprite;
-(void) onCollideBody:(SXBody*)sprite withForce:(float)force withFrictionForce:(float)frictionForce;

@end
