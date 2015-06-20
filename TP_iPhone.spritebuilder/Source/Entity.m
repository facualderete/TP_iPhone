#import "Entity.h"
#import "Player.h"
#import "EndScene.h"

@implementation Entity
{
    int hp;
}

- (id) initWithImageNamed:(NSString*)imageName andHP:(int)entityHP {
    self = [super initWithImageNamed:imageName];    
    hp = entityHP;
    return self;
}

-(int)currentHP {
    return hp;
}

-(void)takeHitWithDamage:(int)damage {
    hp -= damage;
}

@end