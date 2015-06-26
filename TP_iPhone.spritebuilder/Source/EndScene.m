#import "EndScene.h"
#import "IntroScene.h"

@implementation EndScene

+ (EndScene*) initWithString:(NSString*)description andResult:(BOOL)winner {
    return [[self alloc] initWithString:(NSString*)description andResult:(BOOL)winner];
}

- initWithString:(NSString*)description andResult:(BOOL)winner{
    self = [super init];
    
    CCSprite* background;
    
    if (winner) {
        background = [CCSprite spriteWithImageNamed:@"endScene.png"];
        [[OALSimpleAudio sharedInstance] playBg:@"Game Over - Win.mp3" loop:YES];
    } else {
        [[OALSimpleAudio sharedInstance] playBg:@"Game Over - Loose.mp3" loop:YES];
        CCLabelTTF *label = [CCLabelTTF labelWithString:description fontName:@"Chalkduster" fontSize:36.0f];
        label.positionType = CCPositionTypeNormalized;
        label.color = [CCColor redColor];
        label.position = ccp(0.5f, 0.5f);
        [self addChild:label];
    }
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    CGSize imageSize = background.contentSize;
    background.scaleX = winSize.width / imageSize.width;
    background.scaleY = winSize.height / imageSize.height;
    background.anchorPoint = CGPointMake(0, 0);
    [self addChild:background];
    

    
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