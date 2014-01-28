//
//  SPBody.mm
//  SPPhysics
//
//  Created by Alessandro Maroso on 27/09/12.
//  This class is based on the work by Isaac Drachman (29/07/11).
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPBody.h"
#import "SPWorld.h"
#import "SPJoint.h"

@implementation SPBody

@synthesize physicsType;
@synthesize collisionType;
@synthesize collidesWithType;
@synthesize active;
@synthesize sleepy;
@synthesize awake;
@synthesize solid;
@synthesize fixed;
@synthesize bullet;
@synthesize density;
@synthesize friction;
@synthesize bounce;
@synthesize damping;
@synthesize angularDamping;
@synthesize angularVelocity;
@synthesize velocity;
@synthesize body;
@synthesize world;

#pragma mark -
#pragma mark Setters
// Remember to keep synced the instance variables with the body properties.
// comment
-(void) setPhysicsType:(PhysicsType)newPhysicsType
{
	physicsType = newPhysicsType;
	// if body exists
	if (body)
	{
		// set the body physics type
		body->SetType( physicsType == kStatic ? b2_staticBody :
					   physicsType == kKinematic ? b2_kinematicBody :
					   physicsType == kDynamic ? b2_dynamicBody :
					   body->GetType());
	}
}

// TO DO: May be different shape by shape to be more flexible
-(void) setCollisionType:(uint16)newCollisionType
{
	collisionType = newCollisionType;
	
	// if body exists
	if (body)
	{
		// for each shape in the body
		NSArray *shapeNames = [shapesList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
			
			// get the collision filter for the shape
			b2Filter filter = shape->GetFilterData();
			
			// adjust the collision type
			filter.categoryBits = collisionType;
			
			// set the collision filter
			shape->SetFilterData(filter);
		}
	}
}

// TO DO: May be different shape by shape to be more flexible
-(void) setCollidesWithType:(uint16)newCollidesWithType
{
	collidesWithType = newCollidesWithType;
	
	// if body exists
	if (body)
	{
		
		// for each shape in the body
		NSArray *shapeNames = [shapesList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
			
			// get the collision filter for the shape
			b2Filter filter = shape->GetFilterData();
			
			// adjust the collides with type
			filter.maskBits = collidesWithType;
			
			// set the collision filter
			shape->SetFilterData(filter);
		}
	}
}

// comment
-(void) setActive:(BOOL)newActive
{
	active = newActive;
	
	// if body exists
	if (body)
	{
		// set the body active
		body->SetActive(active);
	}
	else
	{
		// sprite cannot be active without body
		active = NO;
	}
}

// comment
-(void) setSleepy:(BOOL)newSleepy
{
	sleepy = newSleepy;

	// if body exists
	if (body)
	{
		// set the body sleepy
		body->SetSleepingAllowed(sleepy);
	}
}

// comment
-(void) setAwake:(BOOL)newAwake
{
	awake = newAwake;
	
	// if body exists
	if (body)
	{
		// set the body awake
		body->SetAwake(awake);
	}
}

// comment
-(void) setSolid:(BOOL)newSolid
{
	solid = newSolid;
	
	// if body exists
	if (body)
	{
		// for each shape in the body
		NSArray *shapeNames = [shapesList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
			
			// set the shape solid
			shape->SetSensor(!solid);
		}
	}
	else
	{
		// for each shape data in the body
		NSArray *shapeNames = [shapeDataList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
			
			// set the shape data solid
			shapeData->isSensor = !solid;
		}
	}
}

// comment
-(void) setFixed:(BOOL)newFixed
{
	fixed = newFixed;
	
	// if body exists
	if (body)
	{
		// set the body fixed
		body->SetFixedRotation(fixed);
	}
}

// comment
-(void) setBullet:(BOOL)newBullet
{
	bullet = newBullet;
	
	// if body exists
	if (body)
	{
		// set the body bullet
		body->SetBullet(bullet);
	}
}

// comment
-(void) setDensity:(float)newDensity
{
	density = newDensity;
	
	// if body exists
	if (body)
	{
		// for each shape in the body
		NSArray *shapeNames = [shapesList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
			
			// set the shape density (from g/p2 to kg/m2)
			shape->SetDensity(density * PTM_RATIO * PTM_RATIO / GTKG_RATIO);
		}
	}
	else
	{
		// for each shape data in the body
		NSArray *shapeNames = [shapeDataList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
			
			// set the shape data density
			shapeData->density = density * PTM_RATIO * PTM_RATIO / GTKG_RATIO;
		}
	}
}

// comment
-(void) setDensity:(float)newDensity forShape:(NSString *)shapeName
{
	// if body exists
	if (body)
	{
		// get the shape with the given name
		b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
		
		// if the shape exists
		if (shape)
		{
			shape->SetDensity(newDensity * PTM_RATIO * PTM_RATIO / GTKG_RATIO);
		}
	}
	else
	{
		// get the shape data with the given name
		b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
		
		// if the shape data exists
		if (shapeData)
		{
			// set the shape data density
			shapeData->density = newDensity * PTM_RATIO * PTM_RATIO / GTKG_RATIO;
		}
	}
}

// comment
-(void) setFriction:(float)newFriction
{
	friction = newFriction;
	
	// if body exists
	if (body)
	{
		// for each shape in the body
		NSArray *shapeNames = [shapesList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
			
			// set the shape friction
			shape->SetFriction(friction);
		}
	}
	else
	{
		// for each shape data in the body
		NSArray *shapeNames = [shapeDataList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
			
			// set the shape data friction
			shapeData->friction = friction;
		}
	}
}

// comment
-(void) setFriction:(float)newFriction forShape:(NSString *)shapeName
{
	// if body exists
	if (body)
	{
		// get the shape with the given name
		b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
		
		// if the shape exists
		if (shape)
		{
			// set the shape friction
			shape->SetFriction(newFriction);
		}
	}
	else
	{
		// get the shape data with the given name
		b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
		
		// if the shape data exists
		if (shapeData)
		{
			// set the shape data friction
			shapeData->friction = newFriction;
		}
	}
}

// comment
-(void) setBounce:(float)newBounce
{
	bounce = newBounce;
	
	// if body exists
	if (body)
	{
		// for each shape in the body
		NSArray *shapeNames = [shapesList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
			
			// set the shape bounce
			shape->SetRestitution(bounce);
		}
	}
	else
	{
		// for each shape data in the body
		NSArray *shapeNames = [shapeDataList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
			
			// set the shape data bounce
			shapeData->restitution = bounce;
		}
	}
}

// comment
-(void) setBounce:(float)newBounce forShape:(NSString *)shapeName
{
	// if body exists
	if (body)
	{
		// get the shape with the given name
		b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
		
		// if the shape exists
		if (shape)
		{
			// set the shape bounce
			shape->SetRestitution(newBounce);
		}
	}
	else
	{
		// get the shape data with the given name
		b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
		
		// if the shape data exists
		if (shapeData)
		{
			// set the shape data bounce
			shapeData->restitution = newBounce;
		}
	}
}

// comment
-(void) setDamping:(float)newDamping
{
	damping = newDamping;
	
	// if body exists
	if (body)
	{
		// set the body damping
		body->SetLinearDamping(damping);
	}
}

// comment
-(void) setAngularDamping:(float)newAngularDamping
{
	angularDamping = newAngularDamping;
	
	// if body exists
	if (body)
	{
		// set the body angular damping
		body->SetAngularDamping(angularDamping);
	}
}

// comment
-(void) setAngularVelocity:(float)newAngularVelocity
{
	angularVelocity = newAngularVelocity;
	
	// if body exists
	if (body)
	{
		// set the body angular velocity in radians
		body->SetAngularVelocity(SP_D2R(-angularVelocity));
	}
}

// comment
-(void) setVelocity:(CGPoint)newVelocity
{
	velocity = newVelocity;
	
	// if body exists
	if (body)
	{
		// set the body velocity
		body->SetLinearVelocity(b2Vec2(velocity.x / PTM_RATIO, velocity.y / PTM_RATIO));
	}
}

// Set the x position
-(void) setX :(float)x
{
	super.x = x;
	
	// if body exists
	if (body)
	{
		// set the body position in world coordinates
		body->SetTransform(b2Vec2(self.x / PTM_RATIO, self.y / PTM_RATIO), body->GetAngle());
	}
}

// Set the y position
-(void) setY :(float)y
{
	super.y = y;
	
	// if body exists
	if (body)
	{
		// set the body position in world coordinates
		body->SetTransform(b2Vec2(self.x / PTM_RATIO, self.y / PTM_RATIO), body->GetAngle());
	}
}

// comment
-(void) setRotation:(float)newRotation
{
	super.rotation = newRotation;
	
	// if body exists
	if (body)
	{
		// set the body rotation in radians
		body->SetTransform(body->GetPosition(), self.rotation);
	}
}

#pragma mark -
#pragma mark Applying Force and Torque

// Apply a force to the body at a specified location as an impulse (if impulse is YES)
-(void) applyForce:(SPPoint*)force atLocation:(SPPoint*)location asImpulse:(BOOL)impulse
{ 
	// if body exists
	if (body)
	{
		// get force in b2World coordinates (from points*gram to meters*kilograms)
		b2Vec2 b2force(force.x / PTM_RATIO * GTKG_RATIO, force.y / PTM_RATIO * GTKG_RATIO);
        // get location in b2World coordinates
		b2Vec2 b2location(location.x / PTM_RATIO, location.y / PTM_RATIO);
		
		// if the force should be an instantaneous impulse
		if (impulse)
		{
			// apply an instant linear impulse
			body->ApplyLinearImpulse(b2force, b2location);
		}
		else
		{
			// apply the force
			body->ApplyForce(b2force, b2location);
		}
	}
}

// Apply a force to the body at a specified location
-(void) applyForce:(SPPoint*)force atLocation:(SPPoint*)location
{
	[self applyForce:force atLocation:location asImpulse:NO];
}

// Apply a force to the body center as an impulse (if impulse is YES)
-(void) applyForce:(SPPoint*)force asImpulse:(BOOL)impulse
{
	// get the center of the body
	b2Vec2 center = body->GetWorldCenter();
    // transform it to Sparrow coordinates (points not meters)
    SPPoint *location = [SPPoint pointWithX:center.x * PTM_RATIO y:center.y * PTM_RATIO];
	[self applyForce:force atLocation:location asImpulse:impulse];
}

// Apply a force to the body center
-(void) applyForce:(SPPoint*)force
{
	[self applyForce:force asImpulse:NO];
}

// comment
-(void) applyTorque:(float)torque asImpulse:(BOOL)impulse
{
	// if body exists
	if (body)
	{
		// if the torque should be an instantaneous impulse
		if (impulse)
		{
			// apply an instant linear impulse
			body->ApplyAngularImpulse(torque / PTM_RATIO / PTM_RATIO * GTKG_RATIO);
		}
		else
		{
			// apply the torque
			body->ApplyTorque(torque / PTM_RATIO / PTM_RATIO * GTKG_RATIO);
		}
	}
}

// comment
-(void) applyTorque:(float)torque
{
	[self applyTorque:torque asImpulse:NO];
}

#pragma mark -
#pragma mark Shapes (Colliders)

// By default all shapes within an object share the same fixture phisical data (density, friction,restitution or "bounciness", solidity or being just a sensor)
-(void) addShape:(b2Shape *)shape withName:(NSString *)shapeName
{
	// set up the data for the fixture of this shape
	b2FixtureDef *shapeData = new b2FixtureDef();
	shapeData->shape = shape;
	shapeData->density = density * PTM_RATIO * PTM_RATIO / GTKG_RATIO;
	shapeData->friction = friction;
	shapeData->restitution = bounce;
	shapeData->isSensor = !solid;
	
	// start with no shape object
	b2Fixture* shapeObject = NULL;
	
	// if the body exists
	if (body)
	{
		// get the shape with the given name
		b2Fixture *oldShape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
		
		// if the shape is already in the list
		if (oldShape)
		{
			// remove the old shape from the body
			body->DestroyFixture(oldShape);
			
		}
		
		// set the collision type of the shape
		shapeData->filter.categoryBits = collisionType;
		shapeData->filter.maskBits = collidesWithType;
		
		// add the shape to the body and get the shape object
		shapeObject = body->CreateFixture(shapeData);
	}
	
	// if the shape object exists
	if (shapeObject)
	{
		// add it to the list of shapes
		[shapesList setObject:[NSValue valueWithPointer:shapeObject] forKey:shapeName];
		
		// delete the shape data
		delete shapeData->shape;
		delete shapeData;
	}
	else
	{
        // just update the data because the fixture will be created when the body is there, i.e. after being added to the SPWorld.
		// get the shape data with the given name
		b2FixtureDef *oldShapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
		
		// if the shape data was already in the list
		if (oldShapeData)
		{
			// if the shape exists
			if (oldShapeData->shape)
			{
				// delete the shape
				delete oldShapeData->shape;
			}
			
			// delete the old shape data
			delete oldShapeData;
		}
		
		// save the new shape data
		[shapeDataList setObject:[NSValue valueWithPointer:shapeData] forKey:shapeName];
	}			
}

// comment
-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize atLocation:(CGPoint)shapeLocation
{
	// create a box shape
	b2PolygonShape *boxShape = new b2PolygonShape();
	boxShape->SetAsBox(shapeSize.width / 2 / PTM_RATIO, shapeSize.height / 2 / PTM_RATIO, b2Vec2((shapeLocation.x - self.x) / PTM_RATIO, (shapeLocation.y - self.y) / PTM_RATIO), 0);
	
	// add it
	[self addShape:boxShape withName:shapeName];
}

// comment
-(void) addBoxWithName:(NSString *)shapeName ofSize:(CGSize)shapeSize
{
	[self addBoxWithName:shapeName ofSize:shapeSize atLocation:CGPointMake(self.x,self.y)];
}

// Automatically creates a box shape(collider) containing the sprite (AABB style) and add it to the body at its location.
-(void) addBoxWithName:(NSString *)shapeName
{
	[self addBoxWithName:shapeName ofSize:CGSizeMake(self.bounds.width,self.bounds.height)];
}

// comment
-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius atLocation:(CGPoint)shapeLocation
{
	// create a circle shape
	b2CircleShape *circleShape = new b2CircleShape();
	circleShape->m_radius = shapeRadius / PTM_RATIO;
	circleShape->m_p.Set((shapeLocation.x - self.x) / PTM_RATIO, (shapeLocation.y - self.y) / PTM_RATIO);
	
	// add it
	[self addShape:circleShape withName:shapeName];
}

// comment
-(void) addCircleWithName:(NSString *)shapeName ofRadius:(float)shapeRadius
{
	[self addCircleWithName:shapeName ofRadius:shapeRadius atLocation:CGPointMake(self.x,self.y)];
}

// Automatically creates a circle shape(collider) containing the sprite (circumscribed to it) and add it to the body at its location.
-(void) addCircleWithName:(NSString *)shapeName
{
	float cwidth = self.bounds.width;
	float cheight = self.bounds.height;
	float diameter = (cwidth < cheight) ? cwidth : cheight;
	[self addCircleWithName:shapeName ofRadius:(diameter / 2)];
}

// comment
-(void) addPolygonWithName:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices
{
	// the number of vertices should be within limits (by default the limit is set to 8)
	assert([shapeVertices count] <= b2_maxPolygonVertices);
	
	// create a new array of vertices
	b2Vec2 vertices[b2_maxPolygonVertices];
	
	for (int i = 0; i< shapeVertices.count; i++) {
        NSValue *vertex = (NSValue*)[shapeVertices objectAtIndex:i];
		// save the vertex in world coordinates
		CGPoint point = [vertex CGPointValue];
		vertices[i] = b2Vec2((point.x - self.x) / PTM_RATIO, (point.y - self.y) / PTM_RATIO);
		
		// next vertex
		i++;
	}
	
	// create a polygon shape
	b2PolygonShape *polygonShape = new b2PolygonShape();
	polygonShape->Set(vertices, [shapeVertices count]);
	
	// add it
	[self addShape:polygonShape withName:shapeName];
}

// comment
-(void) removeShapeWithName:(NSString *)shapeName
{
	// if body exists
	if (body)
	{
		// get the shape with the given name
		b2Fixture *oldShape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
		
		// if the shape is already in the list
		if (oldShape)
		{
			// remove the old shape from the body
			body->DestroyFixture(oldShape);
			
			// remove the shape from the list (keep it synced)
			[shapesList removeObjectForKey:shapeName];
		}
	}
	else
	{
		// get the shape data with the given name
		b2FixtureDef *oldShapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
		
		// if the shape data was already in the list
		if (oldShapeData)
		{
			// if the shape exists
			if (oldShapeData->shape)
			{
				// delete the shape
				delete oldShapeData->shape;
			}
			
			// delete the old shape data
			delete oldShapeData;
		}
		
		// remove the shape data from the list
		[shapeDataList removeObjectForKey:shapeName];
	}
}

// comment
-(void) removeShapes
{
	// if body exists
	if (body)
	{
		// for each shape in the body
		NSArray *shapeNames = [shapesList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape
			b2Fixture *shape = (b2Fixture *)[[shapesList objectForKey:shapeName] pointerValue];
			
			// remove the shape from the body
			body->DestroyFixture(shape);
		}
		
		// clear the shapes list
		[shapesList removeAllObjects];
        //we don't need to clean the shape data list because it's cleaned after body creation
	}
	else
    // clean the shape data list
	{
		// for each shape data in the map
		NSArray *shapeNames = [shapeDataList allKeys];
		for (NSString *shapeName in shapeNames)
		{
			// get the shape data
			b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
			
			// if the shape exists
			if (shapeData->shape)
			{
				// delete the shape
				delete shapeData->shape;
			}
			
			// delete the shape data
			delete shapeData;
		}
		
		// clear the list
		[shapeDataList removeAllObjects];
	}
}

#pragma mark -
#pragma mark Children with Shapes

// comment
-(void) addChild:(SPDisplayObject *)child withBoxNamed:(NSString *)shapeName ofSize:(CGSize)shapeSize atLocation:(CGPoint)shapeLocation 
{
    // Move the pivot of the display object to match the center (box2D works with the shape center)
    child.pivotX = child.width/2;
    child.pivotY = child.height/2;
    [self addChild:child];
    [self addBoxWithName:shapeName ofSize:shapeSize atLocation:shapeLocation];
}

// comment
-(void) addChild:(SPDisplayObject *)child withBoxNamed:(NSString *)shapeName ofSize:(CGSize)shapeSize
{
    // add the child with a box at the default location
    [self addChild:child withBoxNamed:shapeName ofSize:shapeSize atLocation:CGPointMake(self.x, self.y)];
}

// comment
-(void) addChild:(SPDisplayObject *)child withBoxNamed:(NSString *)shapeName
{
    // TO DO: modify the dimensions to the single child dimensions, not the whole sprite
    [self addChild:child withBoxNamed:shapeName ofSize:CGSizeMake(child.bounds.width, child.bounds.height)];
}

// comment
-(void) addChild:(SPDisplayObject *)child withCircleNamed:(NSString *)shapeName ofRadius:(float)shapeRadius atLocation:(CGPoint)shapeLocation
{
    // Move the pivot of the display object to match the center (box2D works with the shape center)
    child.pivotX = child.width/2;
    child.pivotY = child.height/2;
    [self addChild:child];
    [self addCircleWithName:shapeName ofRadius:shapeRadius atLocation:shapeLocation];
}

// comment
-(void) addChild:(SPDisplayObject *)child withCircleNamed:(NSString *)shapeName ofRadius:(float)shapeRadius
{
    // TO DO: maybe the default location must be (child.x, child.y)
    [self addChild:child withCircleNamed:shapeName ofRadius:shapeRadius atLocation:CGPointMake(self.x, self.y)];
}

// comment
-(void) addChild:(SPDisplayObject *)child withCircleNamed:(NSString *)shapeName
{
    float cwidth = child.bounds.width;
	float cheight = child.bounds.height;
	float diameter = (cwidth < cheight) ? cwidth : cheight;
    [self addChild:child withCircleNamed:shapeName ofRadius:diameter/2];
}

// comment
-(void) addChild:(SPDisplayObject *)child withPolygonNamed:(NSString *)shapeName withVertices:(NSMutableArray*)shapeVertices
{
    // Move the pivot of the display object to match the center (box2D works with the shape center)
    child.pivotX = child.width/2;
    child.pivotY = child.height/2;
    [self addChild:child];
}

#pragma mark -
#pragma mark Joints

-(void) addJoint:(SPJoint *)joint
{
    if (joint) 
    {
        [joints addObject:joint];
    }
}

-(void) removeJoint:(SPJoint *)joint
{
    if (joint) 
    {
        [joints removeObject:joint];
    }
}

// TO DO: methods to access joints list
// TO DO: before the body deletion, joints must be deleted!

#pragma mark -
#pragma mark Creation and Destruction

// destroys the b2body
-(void) destroyBody
{
	// if body exists
	if (body)
	{
		// destroy the body
//		body->GetWorld()->DestroyBody(body);
        [world safelyDestroyb2Body: body];
		body = NULL;
	}
	
	// be inactive
	active = false;
}

// create the b2body in the box2d world
-(void) createBody
{
	// if physics manager exists (it does if we call this from onEnter)
	if (world)
	{
		// if the b2World exists
		if (world.world)
		{
			// if body exists
			if (body)
			{
				// destroy it first
				[self destroyBody];
			}
			
			// set up the data structure for the body creation (with the default values initialized)
			b2BodyDef bodyData;
			bodyData.linearVelocity = b2Vec2(velocity.x / PTM_RATIO, velocity.y / PTM_RATIO);
			bodyData.angularVelocity = SP_D2R(-angularVelocity);
			bodyData.angularDamping = angularDamping;
			bodyData.linearDamping = damping;
			bodyData.position = b2Vec2(self.x / PTM_RATIO, self.y / PTM_RATIO);
			bodyData.angle = SP_D2R(-self.rotation);
			active = true;
			bodyData.active = active;
			bodyData.allowSleep = sleepy;
			bodyData.awake = awake;
			bodyData.fixedRotation = fixed;
			bodyData.bullet = bullet;
			bodyData.type = (physicsType == kStatic ? b2_staticBody :
                             physicsType == kKinematic ? b2_kinematicBody :
                             physicsType == kDynamic ? b2_dynamicBody :
                             bodyData.type);
			
			// create the body
			body = world.world->CreateBody(&bodyData);
			
			// give it a reference to this SPBody object
			body->SetUserData(self);
			
			// add all the shapes to the body
			NSArray *shapeNames = [shapeDataList allKeys]; // _shapeData won't be empty when createBody will be called (i.e. when it's added to the SPWorld).
			for (NSString *shapeName in shapeNames)
			{
				// get the shape data structure
				b2FixtureDef *shapeData = (b2FixtureDef *)[[shapeDataList objectForKey:shapeName] pointerValue];
				
				// set the collision type of the shape
				shapeData->filter.categoryBits = collisionType;
				shapeData->filter.maskBits = collidesWithType;
				
				// add the shape to the body and get the shape object
				b2Fixture* shapeObject = body->CreateFixture(shapeData);
				
				// add the shape object to the map
				[shapesList setObject:[NSValue valueWithPointer:shapeObject] forKey:shapeName];
				
				// if the shape exists
				if (shapeData->shape)
				{
					// delete the shape
					delete shapeData->shape;
				}
				
				// delete the shape data
				delete shapeData;
			}
			
			// clear the old shape data
			[shapeDataList removeAllObjects];
			
			// update every frame
            updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
		}
	}
}


// Default constructor - convenience constructor.
+(id) body
{
    return [[SPBody alloc] init];
}

// Init class with default values
-(id) init
{
	if ((self = [super init]))
	{
		physicsType = kDynamic;
		collisionType = 0xFFFF;
		collidesWithType = 0xFFFF;
		active = NO;
		sleepy = YES;
		awake = YES;
		solid = YES;
		fixed = NO;
		bullet = NO;
		density = 1.0;
		friction = 0.3;
		bounce = 0.2;
		damping = 0.0;
		angularDamping = 0.0;
		angularVelocity = 0.0;
		velocity = CGPointZero;
		body = NULL; // will be created when self will be added to the world
		world = nil; // will be set when self will be added to the world
		
		shapesList = [[NSMutableDictionary alloc] init];
		shapeDataList = [[NSMutableDictionary alloc] init];
        joints = [[NSMutableArray alloc] init];
        
        [self addEventListener:@selector(onEnter:) atObject:self forType:SP_EVENT_TYPE_ADDED]; // execute onEnter self is added to a sprite
        [self addEventListener:@selector(onExit:) atObject:self forType:SP_EVENT_TYPE_REMOVED]; // execute onExit when self is removed from a sprite
	}
	return self;
}

// comment
-(void) update
{
	// if body exists
	if (body)
	{
		// check if the body is active
		BOOL wasActive = active;
		active = body->IsActive();
		
		// if the body is or was active
		if (active || wasActive)
		{
			// update the display properties to match
			b2Vec2 bodyPosition = body->GetPosition();
            self.x = bodyPosition.x * PTM_RATIO;
            self.y = bodyPosition.y * PTM_RATIO;
            [self setRotation:body->GetAngle()]; // set the rotation of the object in radians. (In Sparrow, all angles are measured in radians.)
			// check if the body is awake (sleeping state of the body)
			awake = body->IsAwake();
		}
	}
}

// comment
- (void) dealloc
{
    NSLog(@" dealloc SPBody");
	// remove body from world
	[self destroyBody];
}

// When the SPBody is added to a sprite we can create che body
-(void) onEnter :(SPEvent*)event
{
	// skip if the body already exists
	if (body)
		return;
	
	// if physics manager is not defined
	if (!world)
	{
		// if parent is a physics manager
		if ([self.parent isKindOfClass:[SPWorld class]])
		{
			// use the parent as the physics manager
			world = (SPWorld*)self.parent;
		}
	}
	
	// if physics manager is defined now
	if (world)
	{
		// create the body
		[self createBody];
	}
}


// When the SPBody is removed from a sprite we can destroy the body
-(void) onExit :(SPEvent*)event
{
    // destroy all the joints connected to this body
    for (SPJoint* joint in joints)
    {
        [world removeChild:joint];
    }
	// destroy the body
	[self destroyBody];
	// get rid of the physics manager reference too
	world = nil;
}

#pragma mark -
#pragma mark Collision

// comment
-(void) onOverlapBody:(SPBody*)sprite
{
//    NSLog(@"Body overlapped");
}

// comment
-(void) onSeparateBody:(SPBody*)sprite
{
//    NSLog(@"Body separated");
}

// comment
-(void) onCollideBody:(SPBody*)sprite withForce:(float)force withFrictionForce:(float)frictionForce
{
//    NSLog(@"Body overlapped");
}


@end
