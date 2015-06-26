#import "Player.h"
#import "EndScene.h"
#import "GameManager.h"

#define PLAYER_SPEED ((float) 200.0f)

@implementation Player

static Player* sPlayer;

+ (Player*) getPlayer
{
    return sPlayer;
}

+ (void) destroyPlayer {
    sPlayer = nil;
}

-(id) init {
    
    self = [self initWithImageNamed:@"player.png" andHP:[[GameManager gameManager] playerHP]];
    if (!self) return(nil);
    
    self.position  = ccp(75, 100);
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0.5f];
    self.physicsBody.collisionGroup = @"playerGroup";
    self.physicsBody.collisionType = @"playerCollision";
    self.physicsBody.type = CCPhysicsBodyTypeDynamic;
    self.physicsBody.mass = 10000;
    self.physicsBody.allowsRotation = NO;
    sPlayer = self;
    
    return self;
}

-(float)speed {
    return PLAYER_SPEED;
}

-(void)update:(CCTime)delta{
    if([self currentHP] < 0){
        [[CCDirector sharedDirector] replaceScene: [EndScene initWithString: @"A loser is YOU!"]
                                   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
        [self removeFromParent];
    }
}

@end