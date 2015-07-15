#import "BossProjectile.h"
#import "Player.h"

@implementation Projectile {
    int frame_number;
}

CGPoint initialPosition;

-(id) init {
    
    self = [self initWithImageNamed:[NSString stringWithFormat:@"%@%d.png", @"skull-", 1]];
    if (!self) return(nil);

    initialPosition = [[Boss getBoss] position];
    self.physicsBody.type = CCPhysicsBodyTypeKinematic;

    frame_number = 1;
    [self schedule:@selector(animate:) interval:0.2f];
    
    return self;
}

-(void)animate:(CCTime)delta {
    NSString* frame_path = [NSString stringWithFormat:@"%@%d.png", @"skull-", frame_number];
    [self setSpriteFrame: [CCSpriteFrame frameWithImageNamed:frame_path]];
    frame_number++;
    if (frame_number == 5) {
        frame_number = 1;
    }
}

- (void) update:(CCTime)delta {
	Player *player = [Player getPlayer];
    CGPoint projectileVel = CGPointMake(player.position.x - self.position.x, player.position.y - self.position.y);
    self.physicsBody.velocity = ccpMult(ccpNormalize(projectileVel), [[GameManager gameManager] projectileSpeed]);
}

-(CGPoint)initialPosition {
    return initialPosition;
}


@end