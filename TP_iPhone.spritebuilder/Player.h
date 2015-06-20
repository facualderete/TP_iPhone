#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Entity.h"

@interface Player : Entity

- (id)init;
-(float)speed;

+ (void) destroyPlayer;
+ (Player*) getPlayer;

@end