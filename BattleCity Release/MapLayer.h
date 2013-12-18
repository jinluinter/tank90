//
//  MapLayer.h
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class Tank90Sprite;

@protocol MapLayerDelegate;

@interface MapLayer : CCLayerColor {
    
    id<MapLayerDelegate> _delegate;
    CGSize _winSize;
    CCTMXTiledMap* _map;
    CCTMXLayer* _bg1Layer;     
    CCTMXLayer* _bg2Layer;     
    
    
    Tank90Sprite* _tank1;
   
    CCSprite* _home;
    NSMutableDictionary* _remoteSpheres;
    
    int _enemyNum; 
    
    NSMutableArray* _enemyArray;       
    NSMutableArray* _toolArray;        
    CCTMXObjectGroup* _objects;
    NSMutableDictionary* _aiDic;       
    
   
    int _slowTankCount;
    int _quikeTankCount;
    int _strongTankCount;
    
    int _rodamPoint;                   
    NSMutableArray* _pointArray;
    CGPoint _tmpPoint;                 
    NSMutableArray* _propArray;        
    
                                       
    int _slow;
    int _quike;
    int _strong;
    int _strongYe;
    int _strongG;
    int _leve;
    int _bornNum;                     
    BOOL _isGameOver; 
    CGRect _homeRect;

}
@property(nonatomic,retain)id<MapLayerDelegate> delegate;
@property(nonatomic,retain)CCTMXTiledMap* map;
@property(nonatomic,assign)CCTMXLayer* bg1Layer;
@property(nonatomic,assign)CCTMXLayer* bg2Layer;

@property(nonatomic,assign,readonly) Tank90Sprite* tank1;
@property(nonatomic,assign)CCSprite* home;
@property(nonatomic,assign)NSMutableArray* enemyArray; 
@property(nonatomic,retain)NSMutableArray* propArray;

- (id)initWithMap:(int)leve kind:(int)tKind life:(int)numLife;
@end

@protocol MapLayerDelegate <NSObject>


- (void)gameOver;

- (void)bornEnmey;

- (void)changeTankLife:(int)inLife;

@end