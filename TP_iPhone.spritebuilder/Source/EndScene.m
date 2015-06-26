#import "EndScene.h"
#import "IntroScene.h"

@implementation EndScene

+ (EndScene*) initWithString:(NSString*)description {
    return [[self alloc] initWithString:(NSString*)description];
}

- initWithString:(NSString*)description{
    self = [super init];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:description fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f);
    [self addChild:label];
    
    CCButton *restartButton = [CCButton buttonWithTitle:@"Restart" fontName:@"Verdana-Bold" fontSize:18.0f];
    restartButton.positionType = CCPositionTypeNormalized;
    restartButton.position = ccp(0.5f, 0.20f);
    [restartButton setTarget:self selector:@selector(onResetClicked:)];
    [self addChild:restartButton];
    
    return self;
}

- (void)onResetClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end