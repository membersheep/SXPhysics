//
//  SPTerrain.mm
//  SPPhysics
//
//  Created by Alessandro Maroso on 30/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SXTerrain.h"
#import "SXWorld.h"

// TODO: Remake from scratch
@implementation SXTerrain
//
//@synthesize collisionType;
//@synthesize collidesWithType;
//@synthesize active;
//@synthesize sleepy;
//@synthesize awake;
//@synthesize solid;
//@synthesize friction;
//// The b2Body carried for the simulation
//@synthesize body;
//// The world containing this body
//@synthesize world;
//
//#pragma mark -
//#pragma mark Setters
//
//-(void) setFriction:(float)newFriction
//{
//    friction = newFriction;
//	
//	// if body exists
//	if (body)
//	{
//		// for each shape in the body
//		NSArray *shapeNames = [shapesList allKeys];
//		for (NSString *shapeName in shapeNames)
//		{
//			// get the shape
//			b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
//			
//			// set the shape friction
//			shape->SetFriction(friction);
//		}
//	}
//	else
//	{
//		// for each shape data in the body
//		NSArray *shapeNames = [shapeDataList allKeys];
//		for (NSString *shapeName in shapeNames)
//		{
//			// get the shape data
//			b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
//			
//			// set the shape data friction
//			shapeData->friction = friction;
//		}
//	}
//}
//
//-(void) setFriction:(float)newFriction forShape:(NSString *)shapeName
//{
//    // if body exists
//	if (body)
//	{
//		// get the shape with the given name
//		b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
//		
//		// if the shape exists
//		if (shape)
//		{
//			// set the shape friction
//			shape->SetFriction(newFriction);
//		}
//	}
//	else
//	{
//		// get the shape data with the given name
//		b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
//		
//		// if the shape data exists
//		if (shapeData)
//		{
//			// set the shape data friction
//			shapeData->friction = newFriction;
//		}
//	}
//}
//
//// Set the x position
//-(void) setX :(float)x
//{
//	super.x = x;
//	
//	// if body exists
//	if (body)
//	{
//		// set the body position in world coordinates
//		body->SetTransform(b2Vec2(self.x / PTM_RATIO, self.y / PTM_RATIO), body->GetAngle());
//	}
//}
//
//// Set the y position
//-(void) setY :(float)y
//{
//	super.y = y;
//	
//	// if body exists
//	if (body)
//	{
//		// set the body position in world coordinates
//		body->SetTransform(b2Vec2(self.x / PTM_RATIO, self.y / PTM_RATIO), body->GetAngle());
//	}
//}
//
//#pragma mark -
//#pragma mark Shapes
//
//// Add a chain shape with the specified vertices
//-(void) addChainWithName:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices
//{
//	// create a new array of vertices
//	b2Vec2* vertices = new b2Vec2[shapeVertices.count];
//	
//	for (int i = 0; i < shapeVertices.count; i++) 
//    {
//        NSValue *vertex = (NSValue*)[shapeVertices objectAtIndex:i];
//		// save the vertex in world coordinates
//		CGPoint point = [vertex CGPointValue];
//        // transform it in local coordinates and scale it to meters
//		vertices[i] = b2Vec2((point.x - self.x) / PTM_RATIO, (point.y - self.y) / PTM_RATIO);
//		// next vertex
//		i++;
//	}
//	
//	// create a chain shape
//	b2ChainShape *chainShape = new b2ChainShape();
//    chainShape->CreateChain(vertices, [shapeVertices count]);
//    // free the memory previously allocated for the vertices
//    delete [] vertices;
//    
//	// set up the data for the fixture of the chain shape
//	b2FixtureDef *shapeData = new b2FixtureDef();
//	shapeData->shape = chainShape;
//	shapeData->friction = friction;
//	shapeData->isSensor = !solid;
//	
//	// start with no shape object
//	b2Fixture* shapeObject = NULL;
//	
//	// if the body exists
//	if (body)
//	{
//		// get the shape with the given name
//		b2Fixture *oldShape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
//		
//		// if the shape is already in the list
//		if (oldShape)
//		{
//			// remove the old shape from the body
//			body->DestroyFixture(oldShape);
//			
//		}
//		
//		// set the collision type of the shape
//		shapeData->filter.categoryBits = collisionType;
//		shapeData->filter.maskBits = collidesWithType;
//		
//		// add the shape to the body and get the shape object
//		shapeObject = body->CreateFixture(shapeData);
//	}
//	
//	// if the shape object exists
//	if (shapeObject)
//	{
//		// add it to the list of shapes
//		[shapesList setObject:[NSValue valueWithPointer:shapeObject] forKey:shapeName];
//		
//		// delete the shape data
//		delete shapeData->shape;
//		delete shapeData;
//	}
//	else
//	{
//        // just update the data because the fixture will be created when the body is there, i.e. after being added to the SPWorld.
//		// get the shape data with the given name
//		b2FixtureDef *oldShapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
//		
//		// if the shape data was already in the list
//		if (oldShapeData)
//		{
//			// and if the shape exists
//			if (oldShapeData->shape)
//			{
//				// delete the shape
//				delete oldShapeData->shape;
//			}
//			
//			// delete the old shape data
//			delete oldShapeData;
//		}
//		
//		// save the new shape data
//		[shapeDataList setObject:[NSValue valueWithPointer:shapeData] forKey:shapeName];
//	}
//}
//
//// Removes a shape
//-(void) removeShapeWithName:(NSString *)shapeName
//{
//	// if body exists
//	if (body)
//	{
//		// get the shape with the given name
//		b2Fixture *oldShape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
//		
//		// if the shape is already in the list
//		if (oldShape)
//		{
//			// remove the old shape from the body
//			body->DestroyFixture(oldShape);
//			
//			// remove the shape from the list (keep it synced)
//			[shapesList removeObjectForKey:shapeName];
//		}
//	}
//	else
//	{
//		// get the shape data with the given name
//		b2FixtureDef *oldShapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
//		
//		// if the shape data was already in the list
//		if (oldShapeData)
//		{
//			// if the shape exists
//			if (oldShapeData->shape)
//			{
//				// delete the shape
//				delete oldShapeData->shape;
//			}
//			// delete the old shape data
//			delete oldShapeData;
//		}
//		// remove the shape data from the list
//		[shapeDataList removeObjectForKey:shapeName];
//	}
//}
//
//// Removes all shapes
//-(void) removeShapes
//{
//	// if body exists
//	if (body)
//	{
//		// for each shape in the body
//		NSArray *shapeNames = [shapesList allKeys];
//		for (NSString *shapeName in shapeNames)
//		{
//			// get the shape
//			b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
//			
//			// remove the shape from the body
//			body->DestroyFixture(shape);
//		}
//		
//		// clear the shapes list
//		[shapesList removeAllObjects];
//        //we don't need to clean the shape data list because it's cleaned after body creation
//	}
//	else
//        // clean the shape data list
//	{
//		// for each shape data in the map
//		NSArray *shapeNames = [shapeDataList allKeys];
//		for (NSString *shapeName in shapeNames)
//		{
//			// get the shape data
//			b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
//			
//			// if the shape exists
//			if (shapeData->shape)
//			{
//				// delete the shape
//				delete shapeData->shape;
//			}
//			
//			// delete the shape data
//			delete shapeData;
//		}
//		
//		// clear the list
//		[shapeDataList removeAllObjects];
//	}
//}
//
//
//#pragma mark -
//#pragma mark Children
//
//-(void) addChild:(SPDisplayObject *)child withChainNamed:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices
//{
//    // Move the pivot of the display object to match the center (box2D works with the shape center)
//    child.pivotX = child.width/2;
//    child.pivotY = child.height/2;
//    [self addChild:child];
//    [self addChainWithName:shapeName withVertices:shapeVertices];
//}
//
//#pragma mark -
//#pragma mark Creation and destruction
//
//// Destroy the terrain form the world
//-(void) destroyTerrain
//{
//	// if body exists
//	if (body)
//	{
//		// destroy the body
//		body->GetWorld()->DestroyBody(body);
//		body = NULL;
//	}
//	
//	// be inactive
//	active = false;
//}
//
//// Create the terrain in the SPWorld
//-(void) createTerrain
//{
//	// if physics manager exists (it does if we call this from onEnter)
//	if (world)
//	{
//		// if the b2World exists
//		if (world.world)
//		{
//			// if body exists
//			if (body)
//			{
//				// destroy it first
//				[self destroyTerrain];
//			}
//			
//			// set up the data structure for the body creation (with the default values initialized)
//			b2BodyDef bodyData;
//            // position setup
//			bodyData.position = b2Vec2(self.x / PTM_RATIO, self.y / PTM_RATIO);
//			bodyData.angle = SP_D2R(-self.rotation);
//			active = true;
//			bodyData.active = active;
//			bodyData.allowSleep = sleepy;
//			bodyData.awake = awake;
//            // terrain is always static
//			bodyData.type = b2_staticBody;
//			
//			// create the body
//			body = world.world->CreateBody(&bodyData);
//			
//			// give it a reference to this SPTerrain object
//			body->SetUserData(self);
//			
//			// add all the shapes to the body
//            // usually shapeData won't be empty when createBody will be called (i.e. when it's added to the SPWorld).
//			NSArray *shapeNames = [shapeDataList allKeys];
//			for (NSString *shapeName in shapeNames)
//			{
//				// get the shape data structure
//				b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
//				
//				// set the collision type of the shape
//				shapeData->filter.categoryBits = collisionType;
//				shapeData->filter.maskBits = collidesWithType;
//				
//				// add the shape to the body and get the shape object
//				b2Fixture* shapeObject = body->CreateFixture(shapeData);
//				
//				// add the shape object to the map
//				[shapesList setObject:[NSValue valueWithPointer:shapeObject] forKey:shapeName];
//				
//				// if the shape exists
//				if (shapeData->shape)
//				{
//					// delete the shape
//					delete shapeData->shape;
//				}
//				
//				// delete the shape data
//				delete shapeData;
//			}
//			
//			// clear the old shape data
//			[shapeDataList removeAllObjects];
//			
//			// initialize the timer which will call update every frame
//            updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
//		}
//	}
//}
//
//+(id) terrain
//{
//    return [[SPTerrain alloc] init];
//}
//
//// Init class with default values
//-(id) init
//{
//	if ((self = [super init]))
//	{
//		collisionType = 0xFFFF;
//		collidesWithType = 0xFFFF;
//		active = NO;
//		sleepy = YES;
//		awake = YES;
//		solid = YES;
//		friction = 0.3;
//		body = NULL; // will be created when self will be added to the world
//		world = nil; // will be set when self will be added to the world
//		
//		shapesList = [[NSMutableDictionary alloc] init];
//		shapeDataList = [[NSMutableDictionary alloc] init];
//        
//        [self addEventListener:@selector(onEnter:) atObject:self forType:SP_EVENT_TYPE_ADDED]; // execute onEnter self is added to a sprite
//        [self addEventListener:@selector(onExit:) atObject:self forType:SP_EVENT_TYPE_REMOVED]; // execute onExit when self is removed from a sprite
//	}
//	return self;
//}
//
//// Update the SPTerrain properties with the simulation
//-(void) update
//{
//	// if body exists
//	if (body)
//	{
//		// check if the body is active
//		BOOL wasActive = active;
//		active = body->IsActive();
//		
//		// if the body is or was active
//		if (active || wasActive)
//		{
//			awake = body->IsAwake();
//		}
//	}
//}
//
//// comment
//- (void) dealloc
//{
//	// remove body from world
//	[self destroyTerrain];
//	
//	// remove the shape dictionary
//	if (shapesList)
//		[shapesList release];
//	
//	// remove the shape data dictionary
//	if (shapeDataList)
//		[shapeDataList release];
//	
//	// don't forget to call "super dealloc"
//	[super dealloc];
//}
//
//// When the SPTerrain is added to a sprite we can create che body
//-(void) onEnter :(SPEvent*)event
//{
//	// skip if the body already exists
//	if (body)
//		return;
//	
//	// if physics manager is not defined
//	if (!world)
//	{
//		// if parent is a physics manager
//		if ([self.parent isKindOfClass:[SPWorld class]])
//		{
//			// use the parent as the physics manager
//			world = (SPWorld*)self.parent;
//		}
//	}
//	
//	// if physics manager is defined now
//	if (world)
//	{
//		// create the body
//		[self createTerrain];
//	}
//}
//
//// When the SPTerrain is removed from a sprite we can destroy che body
//-(void) onExit :(SPEvent*)event
//{
//	// destroy the body
//	[self destroyTerrain];
//	// get rid of the physics manager reference too
//	world = nil;
//}
//
//#pragma mark -
//#pragma mark Collision
//
//-(void) onOverlapBody:(SPBody*)sprite
//{
//    
//}
//
//-(void) onSeparateBody:(SPBody*)sprite
//{
//    
//}
//
//-(void) onCollideBody:(SPBody*)sprite withForce:(float)force withFrictionForce:(float)frictionForce
//{
//    
//}

@end
