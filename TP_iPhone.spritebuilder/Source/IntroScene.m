#import "IntroScene.h"
#import "MainScene.h"
#import "GameManager.h"

@implementation IntroScene

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    [[OALSimpleAudio sharedInstance] preloadBg:@"Menu.mp3"];
    [[OALSimpleAudio sharedInstance] preloadBg:@"Game Over - Loose.mp3"];
    [[OALSimpleAudio sharedInstance] preloadBg:@"Game Over - Win.mp3"];
    [[OALSimpleAudio sharedInstance] preloadBg:@"Game Music.mp3"];

    [[OALSimpleAudio sharedInstance] preloadEffect:@"fuck.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"lowhealth.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"playerDeath.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"playerhit-1.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"playerhit-2.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"playerhit-3.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"playerhit-4.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"playerhit-5.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"playerhit-6.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"skeletonhit.mp3"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"lasershot.wav"];
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
	CCSprite* background = [CCSprite spriteWithImageNamed:@"menubackground.png"];
	CGSize imageSize = background.contentSize;
    
    background.scaleX = winSize.width / imageSize.width;
    background.scaleY = winSize.height / imageSize.height;
    
	background.anchorPoint = CGPointMake(0, 0);
	[self addChild:background];
    
    [[OALSimpleAudio sharedInstance] playBg:@"Menu.mp3" loop:YES];

//    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Gauntlet" fontName:@"Chalkduster" fontSize:80.0f];
//    label.positionType = CCPositionTypeNormalized;
//    label.color = [CCColor redColor];
//    label.position = ccp(0.5f, 0.75f); // Middle of screen
//    [self addChild:label];
    
    CCButton *easyLevelButton = [CCButton buttonWithTitle:@"[ Easy ]" fontName:@"Verdana-Bold" fontSize:24.0f];
    easyLevelButton.positionType = CCPositionTypeNormalized;
    easyLevelButton.position = ccp(0.5f, 0.90f);
    [easyLevelButton setTarget:self selector:@selector(onEasyLevelClicked:)];
    [self addChild:easyLevelButton];
    
    CCButton *normalLevelButton = [CCButton buttonWithTitle:@"[ Normal ]" fontName:@"Verdana-Bold" fontSize:24.0f];
    normalLevelButton.positionType = CCPositionTypeNormalized;
    normalLevelButton.position = ccp(0.5f, 0.75f);
    [normalLevelButton setTarget:self selector:@selector(onNormalLevelClicked:)];
    [self addChild:normalLevelButton];
    
    CCButton *hardLevelButton = [CCButton buttonWithTitle:@"[ Hard ]" fontName:@"Verdana-Bold" fontSize:24.0f];
    hardLevelButton.positionType = CCPositionTypeNormalized;
    hardLevelButton.position = ccp(0.5f, 0.60f);
    [hardLevelButton setTarget:self selector:@selector(onHardLevelClicked:)];
    [self addChild:hardLevelButton];
	
	return self;
}

- (void)onEasyLevelClicked:(id)sender
{
    [[GameManager gameManager] setPlayerHP:20];
    [[GameManager gameManager] setMonsterSpeed:50];
    [[GameManager gameManager] setSpawnerDifficulty:1];
	[[GameManager gameManager] setProjectileSpeed:200];
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

- (void)onNormalLevelClicked:(id)sender
{
    [[GameManager gameManager] setPlayerHP:10];
    [[GameManager gameManager] setMonsterSpeed:100];
    [[GameManager gameManager] setSpawnerDifficulty:2];
	[[GameManager gameManager] setProjectileSpeed:150];
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

- (void)onHardLevelClicked:(id)sender
{
    [[GameManager gameManager] setPlayerHP:5];
    [[GameManager gameManager] setMonsterSpeed:150];
    [[GameManager gameManager] setSpawnerDifficulty:3];
	[[GameManager gameManager] setProjectileSpeed:125];
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

@end
