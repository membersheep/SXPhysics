//
//  Game.m
//  SXPhysics

//  Created by Alessandro Maroso on 29/01/14.
//  Copyright (c) 2014 waresme. All rights reserved.
//

#import "Game.h"

// --- private interface ---------------------------------------------------------------------------
// Example created and tested for ipad2.

@interface Game ()

@property (nonatomic, strong) SXWorld* world;

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
    SXBody* ground = [SXBody body];
    // Make it static.
    ground.physicsType = kStatic;
    SPImage* groundImage = [SPImage imageWithContentsOfFile:@"ground.png"];
    [ground addChild:groundImage withBoxNamed:@"box"];
    [self.world addChild:ground];
    // Move the body to the bottom and to the center.
    NSLog(@"%f %f", self.world.width, self.world.height);
    ground.x = 512;
    ground.y = 768 - ground.height/2;
    
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
    
    // Add a touch listener
    [self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

-(SXBody*) boxSpawn
{
    NSLog(@"Spawn Box");
    // Create the body
    SXBody* box = [SXBody body];
    // Load an image
    SPImage* boxImage = [SPImage imageWithContentsOfFile:@"sparrow_round.png"];
    // Stick an image on the body with a corresponding physical shape
    [box addChild:boxImage withBoxNamed:@"box"];
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
    if ([touch phase] == SPTouchPhaseEnded)
        [self boxSpawn];
}

@end
