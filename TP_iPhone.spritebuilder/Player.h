#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Entity.h"

@interface Player : Entity

+ (Player *)player;
- (id)init;
-(float)speed;

+ (void) destroyPlayer;
+ (Player*) getPlayer;

@end