#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface BossScene : CCScene <CCPhysicsCollisionDelegate>

+ (BossScene *)scene;
- (id)init;

@end