#import "Entity.h"

@implementation Entity
{
    int hp;
}

- (id) initWithImageNamed:(NSString*)imageName {
    self = [super initWithImageNamed:imageName];    
    hp = 5;
    return self;
}

-(int)currentHP {
    return hp;
}

-(void)takeHit {
    hp -= 1;
}

@end