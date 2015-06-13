#import "MainScene.h"
#import "IntroScene.h"
#import "Player.h"
#import "Projectile.h"
#import "Joystick.h"
#import "Spawner.h"
#import "Monster.h"

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
//    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
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
    _player = [[Player alloc] init];
    [_physicsWorld addChild:_player];
    
    //6
    _spawner = [[Spawner alloc] initWithPhysicsWorld:_physicsWorld];
    [_physicsWorld addChild:_spawner];
    
    // 7
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    return self;
}

- (void)dealloc
{
    // clean up code goes here
}

- (void)onExit
{
    [super onExit];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // 1
    CGPoint touchLocation = [touch locationInNode:self];
    
    _joystick = [[Joystick alloc] init];
    [self addChild:_joystick];
    _joystick.position = touchLocation;
    
    _projectileHitPosition = touchLocation;
    
    _projectile = [[Projectile alloc] init];
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
    
    _projectileVelocity = CGPointMake(_projectileHitPosition.x - _projectile.initialPosition.x, _projectileHitPosition.y - _projectile.initialPosition.y);
    
    _projectile.physicsBody.velocity = ccpMult(ccpNormalize(_projectileVelocity), _projectile.speed);
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    _playerVelocity = CGPointZero;
    [_joystick removeFromParent];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monsterNode projectileCollision:(CCNode *)projectileNode {
    
    Monster* monster = (Monster*) monsterNode;
    
    if ((monster).currentHP > 0) {
        [monster takeHit];
    } else {
        [monsterNode removeFromParent];
    }
    
    [projectileNode removeFromParent];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair spawnerCollision:(CCNode *)spawner projectileCollision:(CCNode *)projectile {
    [spawner removeFromParent];
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
