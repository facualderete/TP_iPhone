#import "Projectile.h"
#import "Player.h"

#define PROJECTILE_SPEED ((float) 200.0f)

@implementation Projectile


CGPoint initialPosition;

-(id) init {
    
    self = [self initWithImageNamed:@"fire-1.png"];
    if (!self) return(nil);

    initialPosition = [[Player getPlayer] position];
    self.physicsBody.type = CCPhysicsBodyTypeKinematic;

    return self;
}

-(float)speed {
    return PROJECTILE_SPEED;
}

-(CGPoint)initialPosition {
    return initialPosition;
}


@end