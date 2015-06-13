#import "Player.h"

// -----------------------------------------------------------------------
#pragma mark - Player
// -----------------------------------------------------------------------

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
    
    self = [self initWithImageNamed:@"player.png"];
    if (!self) return(nil);
    
    self.position  = ccp(75, 100); //75, 50
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
    self.physicsBody.collisionGroup = @"playerGroup";
    self.physicsBody.type = CCPhysicsBodyTypeKinematic;
    
    
    
//    self.physicsBody.collisionGroup = @"playerGroup";    
//    self.positionType = CCPositionTypeNormalized;
//    self.position  = ccp(0.1f, 0.1f);
//    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
    sPlayer = self;
    
    return self;
}

-(float)speed {
    return PLAYER_SPEED;
}

@end