//
//  TankEnemySprite.h
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Tank90Sprite.h"

@protocol TankEnemySpriteDelegate;

@interface TankEnemySprite : Tank90Sprite {
    int  _score;
    id<TankEnemySpriteDelegate> _subDelegate;
    Tank90Sprite* _tank;
}
@property(nonatomic,assign)int score;
@property(nonatomic,assign)id<TankEnemySpriteDelegate> subDelegate;
@property(nonatomic,retain)Tank90Sprite* tank;
+ (TankEnemySprite *)initWithKind:(int)kind;
- (void)stopTankAction;
- (void)removeSelfFromMap;
- (BOOL)checkTank:(CCSprite *)buttle;
@end

@protocol TankEnemySpriteDelegate <NSObject,Tank90SpriteDelegate>


- (Tank90Sprite *)tankFromMap:(TankEnemySprite *)aTank;
@end
