#import "Joystick.h"

// -----------------------------------------------------------------------
#pragma mark - Projectile
// -----------------------------------------------------------------------

#define RADIUS ((float) 20.0f)


@implementation Joystick

+ (Joystick *)joystick {
    return [[self alloc] init];
}

-(id) init {
    
    self = [self initWithImageNamed:@"projectile-hd.png"];
    if (!self) return(nil);
    
    return self;
}

-(float)radius {
    return RADIUS;
}

@end