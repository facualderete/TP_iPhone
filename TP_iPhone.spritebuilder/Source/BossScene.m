#import "BossScene.h"
#import "IntroScene.h"
#import "Player.h"
#import "Projectile.h"
#import "Joystick.h"
#import "Spawner.h"
#import "Monster.h"
#import "GameManager.h"
#import "EndScene.h"

@implementation BossScene
{
    int wallThickness;
    float wallNotVisible;
    Player *_player;
	Boss *_boss;
    CCPhysicsNode *_physicsWorld;
    CGPoint currentJoystickPosition;
    Joystick *_joystick;
    CGPoint _playerVelocity;
    CGPoint _projectileVelocity;
    CGFloat d;
    CGPoint a;
    Projectile *_projectile;
    CGPoint _projectileHitPosition;
    CCLabelTTF *labelPlayerHP;
}

+ (MainScene*) scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    CCSprite* background = [CCSprite spriteWithImageNamed:@"bg2.png"];
    CGSize imageSize = background.contentSize;
    background.scaleX = winSize.width / imageSize.width;
    background.scaleY = winSize.height / imageSize.height;
    background.anchorPoint = CGPointMake(0, 0);
    [self addChild:background];
    
    wallThickness = 50;
    wallNotVisible = wallThickness -  (wallThickness / 5);
    
    self.userInteractionEnabled = YES;
    [self setMultipleTouchEnabled:(YES)];
    
    [[OALSimpleAudio sharedInstance] setBgVolume:0.5f];
    [[OALSimpleAudio sharedInstance] playBg:@"boss-music.mp3" loop:YES];

    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //TODO: sacar esto!!
//    _physicsWorld.debugDraw = YES;
    
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    //x, y, width, height
        
    CCNode* leftWall = [CCNode node];
    leftWall.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, wallThickness, self.contentSize.height + 10) cornerRadius:0.0f];
    leftWall.physicsBody.collisionType = @"wallCollision";
    leftWall.physicsBody.collisionGroup = @"wallGroup";
    leftWall.physicsBody.type = CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:leftWall];
    
    CCNode* rightWall = [CCNode node];
    rightWall.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(self.contentSize.width - wallThickness + 0, 0, wallThickness, self.contentSize.height + 10) cornerRadius:0.0f];
    rightWall.physicsBody.collisionType = @"wallCollision";
    rightWall.physicsBody.collisionGroup = @"wallGroup";
    rightWall.physicsBody.type = CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:rightWall];
    
    CCNode* topWall = [CCNode node];
    topWall.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, self.contentSize.height - wallThickness + 0, self.contentSize.width + 10, wallThickness) cornerRadius:0.0f];
    topWall.physicsBody.collisionType = @"wallCollision";
    topWall.physicsBody.collisionGroup = @"wallGroup";
    topWall.physicsBody.type = CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:topWall];
    
    CCNode* bottomWall = [CCNode node];
    bottomWall.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, self.contentSize.width + 10, wallThickness) cornerRadius:0.0f];
    bottomWall.physicsBody.collisionType = @"wallCollision";
    bottomWall.physicsBody.collisionGroup = @"wallGroup";
    bottomWall.physicsBody.type = CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:bottomWall];
    
    _player = [[Player alloc] init];
    [_physicsWorld addChild:_player];
    
	_boss = [[Boss alloc] init];
	[_physicsWorld addChild: _boss];
       
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    labelPlayerHP = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Player HP %d", _player.currentHP] fontName:@"Marker Felt" fontSize:12];
    labelPlayerHP.positionType = CCPositionTypeNormalized;
    labelPlayerHP.position = ccp(0.1, 0.9);
    [self addChild:labelPlayerHP];
	
	labelBossHP = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Boss HP %d", _boss.currentHP] fontName:@"Marker Felt" fontSize:12];
    labelBossHP.positionType = CCPositionTypeNormalized;
    labelBossHP.position = ccp(0.5, 0.9);
    [self addChild:labelBossHP];
    
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
    
    if (touchLocation.x > _player.position.x) {
        _player.flipX = NO;
    } else {
        _player.flipX = YES;
    }
    
    [[OALSimpleAudio sharedInstance] playEffect:@"lasershot.wav" loop:NO];
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
    
    if ((touchLocation.x - _joystick.position.x) < 0) {
        _player.flipX = YES;
    } else {
        _player.flipX = NO;
    }
}

- (void) update:(CCTime)delta
{
    if (ccpLength(_playerVelocity) > 0.1f) {
        _player.position = ccpAdd(_player.position,  ccpMult(ccpNormalize(_playerVelocity), delta * _player.speed));
    }
    
    _projectileVelocity = CGPointMake(_projectileHitPosition.x - _projectile.initialPosition.x, _projectileHitPosition.y - _projectile.initialPosition.y);
    
    _projectile.physicsBody.velocity = ccpMult(ccpNormalize(_projectileVelocity), _projectile.speed);

    if([[GameManager gameManager] spawnerCount] == 0 && [[GameManager gameManager] monsterCount] == 0) {
        
        [[CCDirector sharedDirector] replaceScene: [EndScene initWithString: @"A winrar is YOU!" andResult:YES]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    _playerVelocity = CGPointZero;
    [_joystick removeFromParent];
}

//Collisions
//-----------------------------------------------------------------------------------------------------

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)bossNode projectileCollision:(CCNode *)projectileNode {
    
    [[OALSimpleAudio sharedInstance] playEffect:@"skeletonhit.mp3" loop:NO];
    
    Boss* boss = (Boss*) bossNode;
    [boss takeHitWithDamage:1];
    [projectileNode removeFromParent];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)bossNode playerCollision:(CCNode *)playerNode {
    
    int lowerBound = 1;
    int upperBound = 8;
    float randValue = lowerBound + arc4random_uniform(upperBound - lowerBound + 1);
    
    if (randValue < 2) {
        [[OALSimpleAudio sharedInstance] playEffect:@"playerhit-1.wav" loop:NO];
    } else if (randValue < 3) {
        [[OALSimpleAudio sharedInstance] playEffect:@"playerhit-2.wav" loop:NO];
    } else if (randValue < 4) {
        [[OALSimpleAudio sharedInstance] playEffect:@"playerhit-3.wav" loop:NO];
    } else if (randValue < 5) {
        [[OALSimpleAudio sharedInstance] playEffect:@"playerhit-4.wav" loop:NO];
    } else if (randValue < 6) {
        [[OALSimpleAudio sharedInstance] playEffect:@"playerhit-5.wav" loop:NO];
    } else if (randValue < 7) {
        [[OALSimpleAudio sharedInstance] playEffect:@"playerhit-6.wav" loop:NO];
    } else if (randValue < 8) {
        [[OALSimpleAudio sharedInstance] playEffect:@"fuck.wav" loop:NO];
    }
    
    Player* player = (Player*) playerNode;
    Boss* boss = (Boss*) bossNode;
    
    [player takeHitWithDamage:1];
    [boss takeHitWithDamage:1];
    
    [labelPlayerHP setString:[NSString stringWithFormat:@"Player HP %d", _player.currentHP]];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair wallCollision:(CCNode *)wallNode projectileCollision:(CCNode *)projectileNode {
    
    [projectileNode removeFromParent];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair wallCollision:(CCNode *)wallNode playerCollision:(CCNode *)projectilePlayer {
    
    _playerVelocity = CGPointZero;
    return YES;
}

//-----------------------------------------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    [[GameManager gameManager] resetCounters];
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
