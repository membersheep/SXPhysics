
//
//  SPTerrain.h
//  SPPhysics
//
//  Created by Alessandro Maroso on 30/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SXPhysics.h"

@class SXWorld;
@class SXBody;

@interface SXTerrain : SPDisplayObjectContainer
//{
//	uint16 collisionType, collidesWithType; 
//	BOOL active, sleepy, awake, solid;
//	float friction;
//	b2Body *body;
//	SPWorld *world;
//	
//    NSMutableArray *joints; 
//	NSMutableDictionary *shapesList; 
//	NSMutableDictionary *shapeDataList; 
//    
//    NSTimer *updateTimer;
//}
//
//// 16-bit masks to filter collisions
//@property (nonatomic) uint16 collisionType;
//@property (nonatomic) uint16 collidesWithType;
//@property (nonatomic) BOOL active;
//@property (nonatomic) BOOL sleepy;
//@property (nonatomic) BOOL awake;
//@property (nonatomic) BOOL solid;
//@property (nonatomic) float friction;
//// The b2Body carried for the simulation
//@property (nonatomic, readonly) b2Body *body;
//// The world containing this body
//@property (nonatomic, assign) SXWorld *world;
//
//+(id) terrain;
//
//-(void) setFriction:(float)newFriction;
//-(void) setFriction:(float)newFriction forShape:(NSString *)shapeName;
//
//-(void) addChainWithName:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices;
//-(void) removeShapeWithName:(NSString *)shapeName;
//-(void) removeShapes;
//
//-(void) addChild:(SPDisplayObject *)child withChainNamed:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices;
//
//-(void) onOverlapBody:(SPBody*)sprite;
//-(void) onSeparateBody:(SPBody*)sprite;
//-(void) onCollideBody:(SPBody*)sprite withForce:(float)force withFrictionForce:(float)frictionForce;

@end
