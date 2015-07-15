#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface GameManager : NSObject

+(GameManager*)gameManager;
-(int)monsterCount;
-(int)spawnerCount;
-(int)score;
-(id)init;
-(void)incrementMonsterCount;
-(void)incrementSpawnerCount;
-(void)incrementScoreCount;
-(void)decrementMonsterCount;
-(void)decrementSpawnerCount;
-(void)resetScore;
-(void)setSpawnerDifficulty:(int)diff;
-(int)getSpawnerDifficulty;
-(int)getProjectileSpeed;

-(void)setPlayerHP:(int)hp;
-(int)playerHP;
-(void)setMonsterSpeed:(int)speed;
-(int)monsterSpeed;

-(void)resetCounters;

@end