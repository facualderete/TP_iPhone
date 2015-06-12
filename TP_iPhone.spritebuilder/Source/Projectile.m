#import "Projectile.h"

// -----------------------------------------------------------------------
#pragma mark - Projectile
// -----------------------------------------------------------------------

#define PROJECTILE_SPEED ((float) 200.0f)

@implementation Projectile

+ (Projectile *)projectile {
    return [[self alloc] init];
}

-(id) init {
    
    self = [self initWithImageNamed:@"projectile.png"];
    if (!self) return(nil);
    self.physicsBody.collisionGroup = @"playerGroup";
    self.physicsBody.collisionType  = @"projectileCollision";

    
    
    
    return self;
}

-(float)speed {
    return PROJECTILE_SPEED;
}


@end