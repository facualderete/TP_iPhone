#import "Monster.h"
#import "Player.h"

@implementation Monster

+ (Monster*) createMonster
{
    Monster* monster = [[Monster alloc] initWithImageNamed:@"monster.png"];
    monster.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, monster.contentSize} cornerRadius:0];
    monster.physicsBody.collisionGroup = @"evilGroup";
    monster.physicsBody.collisionType  = @"monsterCollision";
    monster.physicsBody.type = CCPhysicsBodyTypeDynamic;
    monster.physicsBody.allowsRotation = NO;
    return monster;
}

-(void)update:(CCTime)delta {

    Player *player = [Player getPlayer];
    CGPoint monsterVel = CGPointMake(player.position.x - self.position.x, player.position.y - self.position.y);
//    NSLog(@"monsterVel = %f %f", player.position.x - self.position.x, player.position.y - self.position.y);
    self.physicsBody.velocity = ccpMult(ccpNormalize(monsterVel), 100);
}

@end