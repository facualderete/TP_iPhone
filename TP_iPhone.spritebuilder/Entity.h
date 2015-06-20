#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface Entity : CCSprite

-(id) initWithImageNamed:(NSString*)imageName andHP:(int)entityHP;
-(int)currentHP;
-(void)takeHitWithDamage:(int)damage;

@end