//
//  Tank90Sprite.h
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ToolSprite.h"

@protocol Tank90SpriteDelegate;

typedef enum {
    kBorn = 1,
    kPlusStarOne,
    kPlusStarTwo,
    kPlusStarThree
}Tank90Kind;

typedef  enum {
    
    kUp = 1,
    kDown,
    kLeft,
    kRight,
    kFire,
    kStay,
    kPause
    
}Tank90Action;

typedef enum {
    
    kP1 = 0,
    kSlow,
    kQuike,
    kStrong,
    kStrongYellow,
    kStrongRed,
    kStrongRedLife3,
    kStrongGreen,
    kQuikeR,
    kSlowR,
    
}TankKind;

@interface Tank90Sprite:CCSprite {
    
    id<Tank90SpriteDelegate> _delegate;
    NSMutableArray* _enemyArray;         
    CGSize _mapSize;
    CGPoint _bornPosition;               
    BOOL      _isButtle1OnFire;
    BOOL      _isButtle2OnFire;
    Tank90Kind _kind;
    int _speed;
    int _life;
    int _buttleCount;                    
    Tank90Action _kAction;               
    BOOL _isCanFire;
    int _buttleOrientation;              
    CCSprite* _buttleSprite;
    Tank90Sprite* _tmpTank;              
    BOOL _isTankDone;
    BOOL _isHomeDone;
    BOOL _isHomeProtect;                 
    BOOL _isRead;
    BOOL _isProtect;                     
    ToolSprite* _tmpTool;                
    BOOL _isButtleDone;                  
    int _enemyKindForScore;              
    NSTimer* _timer;
    CGRect _homeRect;
}
@property(nonatomic,retain) id<Tank90SpriteDelegate> delegate;
@property(nonatomic,assign) CGPoint bornPosition;
@property(nonatomic,assign) CGSize mapSize;
@property(nonatomic,assign) int speed;
@property(nonatomic,assign) int life;
@property(nonatomic,assign) Tank90Kind kind;
@property(nonatomic,assign) Tank90Action kAction; 
@property(nonatomic,assign) BOOL isCanFire;
@property(nonatomic,retain) CCSprite* buttleSprite;
@property(nonatomic,assign) BOOL isRead;
@property(nonatomic,assign) BOOL isProtect; 
@property(nonatomic,assign) BOOL isButtleDone; 
@property(nonatomic,assign) BOOL isHomeProtect;
@property(nonatomic,assign) int enemyKindForScore;
@property(nonatomic,assign) NSTimer* timer;
@property(nonatomic,assign) CGRect homeRect;

+ (id)initWithDelegate:(id<Tank90SpriteDelegate>)aDelegate life:(int)numLife tKind:(Tank90Kind)tKind mapSize:(CGSize)mSize; 
- (void)playMoveVideo;

- (void)animationBorn;

- (void)animationBang;

- (void)animationShield;

- (void)check2Tool;

- (void)checkLife;

- (void)checkBang:(NSTimer *)timer;

- (BOOL)checkHome:(CCSprite *)buttle;

- (void)onButtle;

- (void)checkTool;
- (void)onFire;

- (void)fire:(CCSprite *)buttle orientation:(Tank90Action)buttleOrientation;

- (void)changeKind:(ToolSprite *)tool;


- (BOOL)checkWall:(CCSprite *)buttle;

- (BOOL)checkBound:(CCSprite *)buttle;

- (BOOL)checkStrongWall:(CCSprite *)buttle;

- (BOOL)checkLayer2:(CCSprite *)buttle;

- (void)removeShield;

- (void)removeShieldWall;

- (void)topButtle;

- (void)moveUp;
- (void)moveDown;
- (void)moveLeft;
- (void)moveRight;
- (BOOL)checkTankPosition;
- (BOOL)checkPoint:(CGPoint)pon;

@end

@protocol Tank90SpriteDelegate <NSObject>


- (void)initButtlesDidFinish:(Tank90Sprite *)aTank buttle1:(CCSprite *)buttle1 buttle2:(CCSprite *)buttle2;
- (void)initButtleDidFinish:(Tank90Sprite *)aTank buttle:(CCSprite *)buttle;

- (int)tileIDFromPosition:(CGPoint)pon aTank:(Tank90Sprite *)aTank;

- (int)tileIDFromPositionLayer2:(CGPoint)pon aTank:(Tank90Sprite *)aTank;

- (void)destpryTile:(CGPoint)pon aTank:(Tank90Sprite *)aTank;


- (NSMutableArray *)enemyArray:(Tank90Sprite *)aTank;

- (void)removeSprite:(Tank90Sprite *)aTank;

- (CCSprite *)home;

- (void)gameOver:(Tank90Sprite *)tank;

- (void)createTool;

- (NSMutableArray *)toolsArray:(Tank90Sprite *)aTank;

- (void)removeTool:(ToolSprite *)tool;

- (void)homeProtect:(BOOL)isProtect aTank:(Tank90Sprite *)aTank;

- (void)plusBoon:(Tank90Sprite *)aTank;

- (void)changeLife:(Tank90Sprite *)tank;

- (void)plusPass:(Tank90Sprite *)aTank;





- (Tank90Sprite *)tankFromMap:(Tank90Sprite *)aTank;
@end