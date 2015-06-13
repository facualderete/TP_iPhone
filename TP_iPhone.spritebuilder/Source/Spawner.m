#import "Spawner.h"
#import "Monster.h"
// -----------------------------------------------------------------------
#pragma mark - Spawner
// -----------------------------------------------------------------------

#define RADIUS ((float) 20.0f)

@implementation Spawner

- (id)initWithPhysicsWorld:(CCPhysicsNode*)physicsWorld {
    
    self = [super initWithImageNamed:@"projectile.png"];
    if (!self) return(nil);
    self.position  = ccp(300, 160);
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
    self.physicsBody.collisionGroup = @"evilGroup";
    self.physicsBody.collisionType = @"spawnerCollision";
    self.physicsBody.type = CCPhysicsBodyTypeKinematic;
    self.physicsWorld = physicsWorld;
    
    
    return self;
}

-(void) addMonster:(CCTime)delta {
    Monster *monster = [Monster createMonster]; //[[Monster alloc] init];
    //[self addChild:monster];
    monster.position = self.position;
    [self.physicsWorld addChild:monster];
    
}

- (void)onEnter
{
    [super onEnter];
    [self schedule:@selector(addMonster:) interval:1.5];
}

@end