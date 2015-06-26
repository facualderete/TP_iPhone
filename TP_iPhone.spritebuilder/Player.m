#import "Player.h"
#import "EndScene.h"
#import "GameManager.h"

#define PLAYER_SPEED ((float) 200.0f)

@implementation Player {

    int frame_number;
}

static Player* sPlayer;

+ (Player*) getPlayer
{
    return sPlayer;
}

+ (void) destroyPlayer {
    sPlayer = nil;
}

-(id) init {
    
    self = [self initWithImageNamed:[NSString stringWithFormat:@"%@%d.png", @"player-", 1] andHP:[[GameManager gameManager] playerHP]];
    if (!self) return(nil);
    
    self.position  = ccp(75, 150);
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0.5f];
    self.physicsBody.collisionGroup = @"playerGroup";
    self.physicsBody.collisionType = @"playerCollision";
    self.physicsBody.type = CCPhysicsBodyTypeDynamic;
    self.physicsBody.mass = 10000;
    self.physicsBody.allowsRotation = NO;
    sPlayer = self;
    
    frame_number = 1;
    [self schedule:@selector(animate:) interval:0.3f];
    
    return self;
}

-(float)speed {
    return PLAYER_SPEED;
}

-(void)animate:(CCTime)delta {
    NSString* frame_path = [NSString stringWithFormat:@"%@%d.png", @"player-", frame_number];
    [self setSpriteFrame: [CCSpriteFrame frameWithImageNamed:frame_path]];
    frame_number++;
    if (frame_number == 3) {
        frame_number = 1;
    }
}

-(void)update:(CCTime)delta{
    if([self currentHP] < 1){
        [[CCDirector sharedDirector] replaceScene: [EndScene initWithString: @"FUCK!!11one" andResult:NO]
                                   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    }
}

@end