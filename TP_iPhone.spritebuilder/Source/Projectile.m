#import "Projectile.h"
#import "Player.h"
#import "GameManager.h"

@implementation Projectile {
    int frame_number;
}

CGPoint initialPosition;


-(id) init {
    
    self = [self initWithImageNamed:[NSString stringWithFormat:@"%@%d.png", @"fire-", 1]];
    if (!self) return(nil);

    initialPosition = [[Player getPlayer] position];
    self.physicsBody.type = CCPhysicsBodyTypeKinematic;

    frame_number = 1;
    [self schedule:@selector(animate:) interval:0.2f];
    
    return self;
}

-(void)animate:(CCTime)delta {
    NSString* frame_path = [NSString stringWithFormat:@"%@%d.png", @"fire-", frame_number];
    [self setSpriteFrame: [CCSpriteFrame frameWithImageNamed:frame_path]];
    frame_number++;
    if (frame_number == 3) {
        frame_number = 1;
    }
}

-(float)speed {
    return [[GameManager gameManager] getProjectileSPeed];
}

-(CGPoint)initialPosition {
    return initialPosition;
}


@end