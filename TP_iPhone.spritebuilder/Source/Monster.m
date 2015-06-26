#import "Monster.h"
#import "Player.h"
#import "MainScene.h"
#import "GameManager.h"

@implementation Monster

+ (Monster*) createMonster
{
    Monster* monster = [[Monster alloc] initWithImageNamed:@"monster.png" andHP:2];
    monster.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, monster.contentSize} cornerRadius:0];
    monster.physicsBody.collisionGroup = @"evilGroup";
    monster.physicsBody.collisionType  = @"monsterCollision";
    monster.physicsBody.type = CCPhysicsBodyTypeDynamic;
    monster.physicsBody.allowsRotation = NO;
    monster.physicsBody.mass = 1;
    [[GameManager gameManager] incrementMonsterCount];
    return monster;
}

-(void)update:(CCTime)delta {
    Player *player = [Player getPlayer];
    CGPoint monsterVel = CGPointMake(player.position.x - self.position.x, player.position.y - self.position.y);
    self.physicsBody.velocity = ccpMult(ccpNormalize(monsterVel), [[GameManager gameManager] monsterSpeed]);
    if( [self currentHP] < 0){
        [[GameManager gameManager] decrementMonsterCount];
        [[GameManager gameManager] incrementScoreCount];
        [self removeFromParent];
    }
}

@end