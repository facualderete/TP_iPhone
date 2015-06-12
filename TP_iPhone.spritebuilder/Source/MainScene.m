#import "MainScene.h"
#import "IntroScene.h"
#import "Player.h"
#import "Projectile.h"
#import "Joystick.h"
#import "Spawner.h"

@implementation MainScene
{
    // 1
    Player *_player;
    CCPhysicsNode *_physicsWorld;
    CGPoint currentJoystickPosition;
    Joystick *_joystick;
    CGPoint _playerVelocity;
    CGPoint _projectileVelocity;
    CGFloat d;
    CGPoint a;
    Projectile *_projectile;
    CGPoint _projectileHitPosition;
    Spawner *_spawner;
}

+ (MainScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // 2
    self = [super init];
    if (!self) return(nil);
    
    // 3
    self.userInteractionEnabled = YES;
    [self setMultipleTouchEnabled:(YES)];
    
//    [[OALSimpleAudio sharedInstance] playBg:@"background-music-aac.caf" loop:YES];
    
    // 4
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [self addChild:background];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // 5
    //TODO: ver cómo meter esto dentro de Player sin romper el collisionGroup
    _player = [Player player];
    _player.position  = ccp(self.contentSize.width/8,self.contentSize.height/2);
    _player.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _player.contentSize} cornerRadius:0];
    _player.physicsBody.collisionGroup = @"playerGroup";
    [_physicsWorld addChild:_player];
    
    //6
    _spawner = [Spawner spawner];
    _spawner.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    _spawner.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _spawner.contentSize} cornerRadius:0];
    _spawner.physicsBody.collisionGroup = @"spawnerGroup";
    _spawner.physicsBody.collisionType = @"spawnerCollision";
    [_physicsWorld addChild:_spawner];
    
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
    
    monster.position = _spawner.position;
    //    monster.position = CGPointMake(self.contentSize.width + monster.contentSize.width/2, randomY);
    
    //TODO: ver como pija hacer para que no colisione el monster con el spawner
    monster.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, monster.contentSize} cornerRadius:0];
    monster.physicsBody.collisionGroup = @"monsterGroup";
    monster.physicsBody.collisionType  = @"monsterCollision";
    [_physicsWorld addChild:monster];
    
    // 3
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    //TODO: esto hay que cambiarlo por una velocidad fija
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:_player.position];
    CCAction *actionRemove = [CCActionRemove action];
    [monster runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
    //    CGPoint touchLocation = [touch locationInNode:self];
    //    currentJoystickPosition = touchLocation;
    //
    //    _playerVelocity = CGPointMake(touchLocation.x - _joystick.position.x, touchLocation.y - _joystick.position.y);
    //
    //    if (ccpLength(_playerVelocity) > _joystick.radius) {
    //        d = ccpLength(_playerVelocity) - _joystick.radius;
    //        a = ccpMult(ccpNormalize(_playerVelocity), d);
    //        _joystick.position = ccpAdd(_joystick.position, a);
    //    }
    
}

- (void)dealloc
{
    // clean up code goes here
}

- (void)onEnter
{
    [super onEnter];
    [self schedule:@selector(addMonster:) interval:1.5];
}

- (void)onExit
{
    [super onExit];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // 1
    CGPoint touchLocation = [touch locationInNode:self];
    
    _joystick = [Joystick joystick];
    [self addChild:_joystick];
    _joystick.position = touchLocation;
    
    _projectileHitPosition = touchLocation;
    
    _projectile = [Projectile projectile];
    _projectile.position = _player.position;
    _projectile.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:_projectile.contentSize.width/2.0f andCenter:_projectile.anchorPointInPoints];
    _projectile.physicsBody.collisionGroup = @"playerGroup";
    _projectile.physicsBody.collisionType  = @"projectileCollision";
    [_physicsWorld addChild:_projectile];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    currentJoystickPosition = touchLocation;
    
    _playerVelocity = CGPointMake(touchLocation.x - _joystick.position.x, touchLocation.y - _joystick.position.y);
    
    if (ccpLength(_playerVelocity) > _joystick.radius) {
        d = ccpLength(_playerVelocity) - _joystick.radius;
        a = ccpMult(ccpNormalize(_playerVelocity), d);
        _joystick.position = ccpAdd(_joystick.position, a);
    }
}

- (void) update:(CCTime)delta
{
    if (ccpLength(_playerVelocity) > 0.1f) {
        _player.position = ccpAdd(_player.position,  ccpMult(ccpNormalize(_playerVelocity), delta * _player.speed));
    }
    
    _projectileVelocity = CGPointMake(_projectileHitPosition.x - _player.position.x, _projectileHitPosition.y - _player.position.y);
    
    _projectile.physicsBody.velocity = ccpMult(ccpNormalize(_projectileVelocity), _projectile.speed);
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    _playerVelocity = CGPointZero;
    [_joystick removeFromParent];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile {
    [monster removeFromParent];
    [projectile removeFromParent];
    return YES;
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
