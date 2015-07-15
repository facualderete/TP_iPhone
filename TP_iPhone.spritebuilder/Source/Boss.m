#import "Boss.h"
#import "Player.h"
#import "BossProjectile.h"
#import "GameManager.h"

@implementation Boss {
	int frame_number;
}

static Boss* sBoss;

+ (Player*) getBoss{
    return sBoss;
}

+ (void) destroyBoss {
    sBoss = nil;
}

-(id) init {
    
    self = [self initWithImageNamed:[NSString stringWithFormat:@"%@%d.png", @"boss-", 1] andHP:30];
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
    self.physicsBody.collisionGroup = @"evilGroup";
    self.physicsBody.collisionType  = @"monsterCollision";
    self.physicsBody.type = CCPhysicsBodyTypeDynamic;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = 1;
    self.position  = ccp(490, 150);
	
    frame_number = 1;
    
    [self schedule:@selector(animate:) interval:0.3f];
    
    return self;
}

-(void)update:(CCTime)delta {
    Player *player = [Player getPlayer];
    
    if (player.position.x > self.position.x) {
        self.flipX = NO;
    } else {
        self.flipX = YES;
    }
    
    CGPoint bossVel = CGPointMake(player.position.x - self.position.x, player.position.y - self.position.y);
    self.physicsBody.velocity = ccpMult(ccpNormalize(bossVel), [[GameManager gameManager] bossSpeed]);
    if( [self currentHP] < 0){
        [[GameManager gameManager] decrementMonsterCount];
        [[GameManager gameManager] incrementScoreCount];
        [self removeFromParent];
    }
}

-(void) fireProjectile:(CCTime)delta {
    BossProjectile *projectile = [[BossProjectile alloc] init];;
    projectile.position = self.position;
    [self.physicsWorld addChild:projectile];
}

- (void)onEnter{
    [super onEnter];
    [self schedule:@selector(fireProjectile:) interval:1];
}

-(void)animate:(CCTime)delta {
    NSString* frame_path = [NSString stringWithFormat:@"%@%d.png", @"boss-", frame_number];
    [self setSpriteFrame: [CCSpriteFrame frameWithImageNamed:frame_path]];
    frame_number++;
    if (frame_number == 3) {
        frame_number = 1;
    }
}

@end