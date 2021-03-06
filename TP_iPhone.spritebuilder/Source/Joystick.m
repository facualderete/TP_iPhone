#import "Joystick.h"

// -----------------------------------------------------------------------
#pragma mark - Projectile
// -----------------------------------------------------------------------

#define RADIUS ((float) 20.0f)


@implementation Joystick

-(id) init {
    
    self = [self initWithImageNamed:@"joy.png"];
    if (!self) return(nil);
    self.opacity = 0.75f;
    return self;
}

-(float)radius {
    return RADIUS;
}

@end