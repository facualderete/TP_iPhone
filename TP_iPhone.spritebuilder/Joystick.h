#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface Joystick : CCSprite

+ (Joystick *)joystick;
- (id)init;
-(float)radius;

@end