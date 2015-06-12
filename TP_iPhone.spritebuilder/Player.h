#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface Player : CCSprite

+ (Player *)player;
- (id)init;
-(float)speed;

@end