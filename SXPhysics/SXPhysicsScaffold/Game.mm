//
//  Game.m
//  SXPhysics

//  Created by Alessandro Maroso on 29/01/14.
//  Copyright (c) 2014 waresme. All rights reserved.
//

#import "Game.h"

@interface Game ()

@property (nonatomic, strong) SXWorld* world;
@property (nonatomic, strong) SXBody* ground;
@property (nonatomic, strong) SXBody* sparrow;
@property (nonatomic, strong) SXBody* hotDog;

@end


// --- class implementation ------------------------------------------------------------------------

@implementation Game

- (id)init
{
    if ((self = [super init]))
    {
        SPQuad *background = [SPQuad quadWithWidth:1024 height:768];
        [self addChild:background];
        [self setup];
        [self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
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
    self.ground.x = [Sparrow currentController].stage.width/2;
    self.ground.y = [Sparrow currentController].stage.height;
    self.ground.physicsType = kStatic;
    SPImage* groundImage = [SPImage imageWithContentsOfFile:@"ground.png"];
    [self.ground addChild:groundImage withBoxNamed:@"box"];
    self.ground.x = [Sparrow currentController].stage.width/2;
    self.ground.y = [Sparrow currentController].stage.height-self.ground.height/2;
    [self.world addChild:self.ground];
    
    self.sparrow = [SXBody body];
    self.sparrow.name = @"sparrow";
    self.sparrow.physicsType = kKinematic;
    [self.sparrow addChild:[SPImage imageWithContentsOfFile:@"sparrow_round.png"] withCircleNamed:@"circle"];
    self.sparrow.x = [Sparrow currentController].stage.width/2;
    self.sparrow.y = [Sparrow currentController].stage.height/2;
    [self.world addChild:self.sparrow];
    
    self.hotDog = [SXBody createBodyForBodyName:@"hotdog" fromFile:@"shapedefs.plist"];
    [self.world addChild:self.hotDog];
    [self.hotDog addChild:[SPImage imageWithContentsOfFile:@"hotdog.png"]];
}

-(void)onTouch:(SPTouchEvent*)event
{
    SPTouch *touch = [event.touches anyObject];
    if (touch.phase == SPTouchPhaseEnded)
    {
        SPPoint *touchLocation = [touch locationInSpace:self.sparrow];
        [self.sparrow setVelocity:CGPointMake(touchLocation.x, touchLocation.y)];
    }
}

@end
