#import "Monster.h"
#import "Player.h"
#import "MainScene.h"
#import "GameManager.h"

@implementation Monster {
    
    int frame_number;
}

-(id) init {
    
    self = [self initWithImageNamed:[NSString stringWithFormat:@"%@%d.png", @"skeleton-", 1] andHP:2];
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
    self.physicsBody.collisionGroup = @"evilGroup";
    self.physicsBody.collisionType  = @"monsterCollision";
    self.physicsBody.type = CCPhysicsBodyTypeDynamic;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = 1;
    [[GameManager gameManager] incrementMonsterCount];
    
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
    
    CGPoint monsterVel = CGPointMake(player.position.x - self.position.x, player.position.y - self.position.y);
    self.physicsBody.velocity = ccpMult(ccpNormalize(monsterVel), [[GameManager gameManager] monsterSpeed]);
    if( [self currentHP] < 0){
        [[GameManager gameManager] decrementMonsterCount];
        [[GameManager gameManager] incrementScoreCount];
        [self removeFromParent];
    }
}

-(void)animate:(CCTime)delta {
    NSString* frame_path = [NSString stringWithFormat:@"%@%d.png", @"skeleton-", frame_number];
    [self setSpriteFrame: [CCSpriteFrame frameWithImageNamed:frame_path]];
    frame_number++;
    if (frame_number == 3) {
        frame_number = 1;
    }
}

@end