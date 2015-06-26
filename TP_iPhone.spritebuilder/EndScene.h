#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface EndScene : CCScene

+ (EndScene*) initWithString:(NSString*)description andResult:(BOOL)winner;

@end