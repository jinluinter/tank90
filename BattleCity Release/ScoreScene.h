//
//  ScoreScene.h
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreScene:CCScene {

    int _slow;
    int _quike;
    int _strong;
    int _strongYe;
    int _strongG;
    int leve;
    int life;
    int kind;
    int _leve;
    int _kind;
    int _life;
    
    CCLayerColor* layer;
    CGSize winSize;
}
- (id)initWithNumber:(int)slow quike:(int)quike strong:(int)strong strongY:(int)strongY strongG:(int)strongG
                leve:(int)leve kind:(int)kind life:(int)life;
+(id)scene;
@end
