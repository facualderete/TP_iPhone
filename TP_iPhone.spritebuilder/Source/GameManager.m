#import "GameManager.h"

@implementation GameManager {

    int monsterCount;
    int spawnerCount;
    int score;
    int playerHP;
    int monsterSpeed;
    int spawnerDifficulty;
	int projectileSpeed;
}

static GameManager* _gameManager = nil;

+(GameManager*)gameManager {
    @synchronized([GameManager class]) {
        if (!_gameManager)
            _gameManager = [[self alloc] init];
        return _gameManager;
    }
    return nil;
}

+(id)alloc {
    @synchronized([GameManager class]) {
        NSAssert(_gameManager == nil, @"Attempted to allocate a second instance of a singleton.");
        _gameManager = [super alloc];
        return _gameManager;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        monsterCount = 0;
        score = 0;
        spawnerCount = 0;
    }
    return self;
}

-(void)setSpawnerDifficulty:(int)diff {
    spawnerDifficulty = diff;
}

-(int)getSpawnerDifficulty {
    return spawnerDifficulty;
}

-(void)projectileSpeed:(int)speed  {
	projectileSpeed = speed;
}

-(int)projectileSpeed {
	return projectileSpeed;
}

-(void)setMonsterSpeed:(int)speed {
    monsterSpeed = speed;
}

-(int)monsterSpeed {
    return monsterSpeed;
}

-(void)setPlayerHP:(int)hp {
    playerHP = hp;
}

-(int)playerHP {
    return playerHP;
}

-(int)monsterCount {
    return monsterCount;
}

-(int)spawnerCount {
    return spawnerCount;
}

-(int)score {
    return score;
}

-(void)incrementMonsterCount {
    monsterCount++;
}

-(void)incrementSpawnerCount {
    spawnerCount++;
}

-(void)incrementScoreCount {
    score++;
}

-(void)decrementMonsterCount {
    monsterCount--;
}

-(void)decrementSpawnerCount {
    spawnerCount--;
}

-(void)resetScore {
    score = 0;
}

-(void)resetCounters {
    monsterCount = 0;
    spawnerCount = 0;
    score = 0;
}

@end