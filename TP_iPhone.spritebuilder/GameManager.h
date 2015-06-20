#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface GameManager : NSObject

+(GameManager*)gameManager;
-(int)monsterCount;
-(int)spawnerCount;
-(int)gameScore;
-(id)init;
-(int)score;
-(void)incrementMonsterCount;
-(void)incrementSpawnerCount;
-(void)incrementScoreCount;
-(void)decrementMonsterCount;
-(void)decrementSpawnerCount;
-(void)resetScore;

@end