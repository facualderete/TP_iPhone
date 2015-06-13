#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Entity.h"

@interface Spawner : Entity

- (id)initWithPhysicsWorld:(CCPhysicsNode*)physicsWorld;

@property (nonatomic, weak) CCPhysicsNode* physicsWorld;

@end