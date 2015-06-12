#import "Spawner.h"

// -----------------------------------------------------------------------
#pragma mark - Spawner
// -----------------------------------------------------------------------

#define RADIUS ((float) 20.0f)


@implementation Spawner

+ (Spawner *)spawner {
    return [[self alloc] init];
}

-(id) init {
    
    self = [self initWithImageNamed:@"projectile.png"];
    if (!self) return(nil);
    
    return self;
}


@end