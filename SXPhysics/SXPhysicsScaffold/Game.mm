//
//  Game.m
//  SXPhysics

//  Created by Alessandro Maroso on 29/01/14.
//  Copyright (c) 2014 waresme. All rights reserved.
//

#import "Game.h"
#import "SXTouchJoint.h"

@interface Game ()

@property (nonatomic, strong) SXWorld* world;
@property (nonatomic, strong) SXBody* ground;
@property (nonatomic, strong) SXBody* sparrow;
@property (nonatomic, strong) SXBody* test;
@property (nonatomic, strong) SXTouchJoint* touchJoint;

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
    self.world.gravity = CGPointMake(0, 1 * PTM_RATIO);
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
    
    self.test = [SXBody createBodyForBodyName:@"triangle" fromFile:@"triangle.plist"];
    self.test.x = [Sparrow currentController].stage.width/2;
    SPImage *testImage = [SPImage imageWithContentsOfFile:@"triangle.png"];
    [testImage alignPivotX:SPHAlignCenter pivotY:SPVAlignCenter];
    [self.test addChild:testImage];
    [self.world addChild:self.test];
    
    SXBody *test0 = [SXBody createBodyForBodyName:@"drink" fromFile:@"shapedefs.plist"];
    test0.x = [Sparrow currentController].stage.width*3/4;
    SPImage *test0Image = [SPImage imageWithContentsOfFile:@"drink.png"];
    [test0Image alignPivotX:SPHAlignCenter pivotY:SPVAlignCenter];
    [test0 addChild:test0Image];
    [self.world addChild:test0];
    
    SXBody *test1 = [SXBody createBodyForBodyName:@"hotdog" fromFile:@"shapedefs.plist"];
    test1.x = [Sparrow currentController].stage.width*1/4;
    SPImage *test1Image = [SPImage imageWithContentsOfFile:@"hotdog.png"];
    [test1Image alignPivotX:SPHAlignCenter pivotY:SPVAlignCenter];
    [test1 addChild:test1Image];
    [self.world addChild:test1];
}

-(void)onTouch:(SPTouchEvent*)event
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
