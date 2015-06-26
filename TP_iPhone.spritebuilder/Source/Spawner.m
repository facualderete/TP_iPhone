#import "Spawner.h"
#import "Monster.h"
#import "GameManager.h"
// -----------------------------------------------------------------------
#pragma mark - Spawner
// -----------------------------------------------------------------------

#define RADIUS ((float) 20.0f)

@implementation Spawner

- (id)initWithPhysicsWorld:(CCPhysicsNode*)physicsWorld andPosition:(CGPoint)position {
    
    self = [super initWithImageNamed:@"spawner.png" andHP:3];
    if (!self) return(nil);
    
//    TODO: no anda el normalized!!
//    self.positionType = CCPositionTypeNormalized;
//    NSLog(@"%f : %f", position.x, position.y);
    self.position  = ccp(300, 160);
    self.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, self.contentSize} cornerRadius:0];
    self.physicsBody.collisionGroup = @"evilGroup";
    self.physicsBody.collisionType = @"spawnerCollision";
    self.physicsBody.type = CCPhysicsBodyTypeKinematic;
    self.physicsWorld = physicsWorld;

    self.scaleX = 0.23f;
    self.scaleY = 0.23f;
    
    
    [[GameManager gameManager] incrementSpawnerCount];
    return self;
}

-(void) addMonster:(CCTime)delta {
    Monster *monster = [Monster createMonster];
    //[self addChild:monster];
    monster.position = self.position;
    [self.physicsWorld addChild:monster];
    
}

- (void)onEnter
{
    [super onEnter];
    [self schedule:@selector(addMonster:) interval:2.5];
}

-(void)update:(CCTime)delta{
    if([self currentHP] < 0) {
        [[GameManager gameManager] decrementSpawnerCount];
        [self removeFromParent];
    }
}

@end