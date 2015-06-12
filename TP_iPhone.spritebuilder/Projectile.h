#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface Projectile : CCSprite

+ (Projectile *)projectile;
- (id)init;
-(float)speed;

@end