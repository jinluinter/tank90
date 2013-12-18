//
//  MainScene.h
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapLayer.h"
#import "InputLayer.h"

@interface MainScene :CCScene{
    
    MapLayer* _mapLayer;       //显示地图
    InputLayer* _inputLayer;   //显示方向控制与开火
    int _leve;                 //显示处于第几关
    int _1pLeft;               //显示1p生命
    int _2pLeft;               //显示2p生命
    int _enemyLeft;            //显示敌人生命
    CCLabelTTF* _1plifeString;
    CCLabelTTF* _leveString;
    CCLabelTTF* _robotLifeString;
    
    //隐示属性 不需要生成get and set
    CCSpriteFrameCache* _frameCache;
    CGSize _winSize;
    
    NSMutableArray* _iconArray;  //敌人坦克图标
    
}

//map的生命周期是与Scene相同所以assign 就可以
@property(nonatomic,assign) MapLayer* mapLayer;
@property(nonatomic,assign) InputLayer* inputLayer;
@property(nonatomic,assign) int leve;
+ (id)scene;
- (id)initWithMapInformation:(int)leve status:(int)status life:(int)life;
//删除当前游戏层 所有子项
- (void)removeCurrentLayer;
- (void)addNewLayer;
- (void)chang1PTankLeft;
- (void)chang2PTankLeft;
- (void)changEnemyTankLeft;
- (void)changLeve;
- (void)robotLife;
@end
