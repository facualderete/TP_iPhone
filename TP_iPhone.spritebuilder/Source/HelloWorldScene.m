//
//  HelloWorldScene.m
//  Cocos2DSimpleGame
//
//  Created by Martin Walsh on 18/01/2014.
//  Copyright Razeware LLC 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    // 1
    CCSprite *_player;
    CCPhysicsNode *_physicsWorld;
    CGPoint currentJoystickPosition;
    CCSprite *joystick;
    CGPoint _playerVelocity;
    CGPoint _projectileVelocity;
    CGFloat d;
    CGPoint a;
    CCSprite *projectile;
    CGPoint _projectileHitPosition;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // 2
    self = [super init];
    if (!self) return(nil);
    
    // 3
    self.userInteractionEnabled = YES;
    [self setMultipleTouchEnabled:(YES)];
    
    [[OALSimpleAudio sharedInstance] playBg:@"background-music-aac.caf" loop:YES];
    
    // 4
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [self addChild:background];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // 5
    _player = [CCSprite spriteWithImageNamed:@"player.png"];
    _player.position  = ccp(self.contentSize.width/8,self.contentSize.height/2);
    _player.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _player.contentSize} cornerRadius:0]; // 1
    _player.physicsBody.collisionGroup = @"playerGroup"; // 2
    [_physicsWorld addChild:_player];
    
    // 6
    //CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    //[_player runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    NSLog(@"Print en pantalla!!");
    // 7
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
	return self;
}

- (void)addMonster:(CCTime)dt {
    
    CCSprite *monster = [CCSprite spriteWithImageNamed:@"monster.png"];
    
    // 1
    int minY = monster.contentSize.height / 2;
    int maxY = self.contentSize.height - monster.contentSize.height / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    // 2
    monster.position = CGPointMake(self.contentSize.width + monster.contentSize.width/2, randomY);
    monster.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, monster.contentSize} cornerRadius:0];
    monster.physicsBody.collisionGroup = @"monsterGroup";
    monster.physicsBody.collisionType  = @"monsterCollision";
    [_physicsWorld addChild:monster];
    
    // 3
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    // 4
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-monster.contentSize.width/2, randomY)];
    CCAction *actionRemove = [CCActionRemove action];
    [monster runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Pr frame update is automatically enabled, if update is overridden
    
    [self schedule:@selector(addMonster:) interval:1.5];
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // 1
    CGPoint touchLocation = [touch locationInNode:self];
    NSLog(@"Value of X = %0.02f %0.02f", touchLocation.x, touchLocation.y);
    
    joystick = [CCSprite spriteWithImageNamed:@"projectile.png"];
    [self addChild:joystick];
    joystick.position = touchLocation;
    
    _projectileHitPosition = touchLocation;
    
    projectile = [CCSprite spriteWithImageNamed:@"projectile.png"];
    projectile.position = _player.position;
    projectile.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:projectile.contentSize.width/2.0f andCenter:projectile.anchorPointInPoints];
    projectile.physicsBody.collisionGroup = @"playerGroup";
    projectile.physicsBody.collisionType  = @"projectileCollision";
    [_physicsWorld addChild:projectile];

//    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:0.5f position:joystick.position];
//    CCActionRemove *actionRemove = [CCActionRemove action];
//    [projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    currentJoystickPosition = touchLocation;

    NSLog(@"Value of X = %0.02f %0.02f", currentJoystickPosition.x, currentJoystickPosition.y);
    
    _playerVelocity = CGPointMake(touchLocation.x - joystick.position.x, touchLocation.y - joystick.position.y);
    
    const CGFloat VIRTUAL_JOYSTICK_RADIUS = 20.0f;
    
    if (ccpLength(_playerVelocity) > VIRTUAL_JOYSTICK_RADIUS) {
        //update virtual joystick initial position
        d = ccpLength(_playerVelocity) - VIRTUAL_JOYSTICK_RADIUS;
        a = ccpMult(ccpNormalize(_playerVelocity), d);
        joystick.position = ccpAdd(joystick.position, a);
    }
}

- (void) update:(CCTime)delta
{
    const CGFloat PLAYER_SPEED = 200.0f;
    const CGFloat PROJECTILE_SPEED = 200.0f;
    
    if (ccpLength(_playerVelocity) > 0.1f) {
        _player.position = ccpAdd(_player.position,  ccpMult(ccpNormalize(_playerVelocity), delta * PLAYER_SPEED));
    }
    
    _projectileVelocity = CGPointMake(_projectileHitPosition.x - _player.position.x, _projectileHitPosition.y - _player.position.y);
    

//    projectile.position = ccpAdd(joystick.position,  ccpMult(ccpNormalize(_projectileVelocity), delta));;
    
    projectile.physicsBody.velocity = ccpMult(ccpNormalize(_projectileVelocity), PROJECTILE_SPEED);
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    _playerVelocity = CGPointZero;
    [joystick removeFromParent];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile {
    [monster removeFromParent];
    [projectile removeFromParent];
    return YES;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}



// -----------------------------------------------------------------------
@end