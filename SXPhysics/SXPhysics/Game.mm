//
//  Game.m
//  SXPhysics

//  Created by Alessandro Maroso on 29/01/14.
//  Copyright (c) 2014 waresme. All rights reserved.
//

#import "Game.h"
#import "SXTouchJoint.h"

// --- private interface ---------------------------------------------------------------------------
// Example created and tested for ipad2.
// Objects are spawned when ground is touched.

@interface Game ()

@property (nonatomic, strong) SXWorld* world;
@property (nonatomic, strong) SXTouchJoint* touchJoint;
@property (nonatomic, strong) SXBody* ground;

@end


// --- class implementation ------------------------------------------------------------------------

@implementation Game

- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // Create the world.
    self.world = [[SXWorld alloc] init];
    // Set the gravity in m/s^2
    self.world.gravity = CGPointMake(0, 9.8 * PTM_RATIO);
    [self addChild:self.world];
    
    // Create the ground.
    self.ground = [SXBody body];
    self.ground.name = @"ground";
    // Make it static.
    self.ground.physicsType = kStatic;
    SPImage* groundImage = [SPImage imageWithContentsOfFile:@"ground.png"];
    [self.ground addChild:groundImage withBoxNamed:@"box"];
    [self.world addChild:self.ground];
    // Move the body to the bottom and to the center.
    NSLog(@"%f %f", self.world.width, self.world.height);
    self.ground.x = 512;
    self.ground.y = 768 - self.ground.height/2;
    
    // Create two (invisible) walls
    SXBody *leftWall = [SXBody body];
    leftWall.physicsType = kStatic;
    leftWall.x = 0;
    leftWall.y = 768/2;
    [leftWall addBoxWithName:@"leftWall" ofSize:CGSizeMake(1.0f, 768)]; // the box will be centered at the specified location
    SXBody *rightWall = [SXBody body];
    rightWall.physicsType = kStatic;
    rightWall.x = 1024;
    rightWall.y = 768/2;
    [rightWall addBoxWithName:@"rightWall" ofSize:CGSizeMake(1.0f, 768)];
    [self.world addChild:leftWall];
    [self.world addChild:rightWall];

    
    // Add a touch listeners
    [self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

-(SXBody*) sparrowSpawn
{
    NSLog(@"Spawn Sparrow");
    // Create the body
    SXBody* box = [SXBody body];
    // Load an image
    SPImage* boxImage = [SPImage imageWithContentsOfFile:@"sparrow_round.png"];
    // Stick an image on the body with a corresponding physical shape
    [box addChild:boxImage withCircleNamed:@"box"];
    // Set a random x position
    box.x = arc4random_uniform(800) + 100;
    // Set a y position at the top of the screen
    box.y = box.height/2;
    // Add it to the world.
    [self.world addChild:box];
    // Return a pointer to the body
    return box;
}

- (void)onTouch:(SPTouchEvent*)event
{
    SPTouch *touch = [[event touchesWithTarget:self] anyObject];
    SPPoint *position = [touch locationInSpace:self];
    
    if (touch.phase == SPTouchPhaseBegan)
    {
        NSLog(@"SPWorld touch position: %@", [position description]);
        NSLog(@"Touched object class: %@", [touch.target class]);
    }
    
    // TouchJoint test
    if (touch.phase == SPTouchPhaseBegan)
    {
        // find if a body was touched
        self.touchJoint.target = CGPointMake(position.x, position.y);
        id touchTarget = touch.target;
        while( ![touchTarget isKindOfClass:[SXBody class]] )
        {
            touchTarget = [touchTarget parent];
            if (touchTarget)
            {
                if([touchTarget isKindOfClass:[Game class]] )
                    break;
            }
            else break;
        }
        // if i found a body, create a touch joint to move it
        if([touchTarget isKindOfClass:[SXBody class]])
        {
            SXBody *touchBody = touchTarget;
            if ([touchBody.name isEqualToString:@"ground"])
            {
                [self sparrowSpawn];
                return;
            }
            NSLog(@"creating joint");
            // create mouse touch joint (instance variable)
            self.touchJoint = [SXTouchJoint touchJoint];
            self.touchJoint.bodyA = self.ground;
            self.touchJoint.bodyB = touchBody;
            // activate the collision with the reference body (the ground)
            self.touchJoint.collideConnected = YES;
            // the max force that will affect other bodies after collisions with the box
            self.touchJoint.maxForce = 50;
            // specify the initial target position (in world coordinates)
            self.touchJoint.target = CGPointMake(touchBody.x, touchBody.y);
            [self.world addChild:self.touchJoint];
            NSLog(@"joint created");
        }
    }
    if (touch.phase == SPTouchPhaseMoved)
    {
        // when there is a touch movement the target should be moved
        if(self.touchJoint)
            self.touchJoint.target = CGPointMake(position.x, position.y);
    }
    if (touch.phase == SPTouchPhaseEnded)
    {
        // remove the touch joint when the touch ends
        if(self.touchJoint)
            [self.world removeChild:self.touchJoint];
    }
}

@end
