#import "Player.h"

// -----------------------------------------------------------------------
#pragma mark - Player
// -----------------------------------------------------------------------

#define PLAYER_SPEED ((float) 200.0f)

@implementation Player

+ (Player *)player {
    return [[self alloc] init];
}

-(id) init {
    
    self = [self initWithImageNamed:@"player.png"];
    if (!self) return(nil);
//    self.physicsBody.collisionGroup = @"playerGroup";    
    
    return self;
}

-(float)speed {
    return PLAYER_SPEED;
}

@end