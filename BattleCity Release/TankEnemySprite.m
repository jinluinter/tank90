//
//  TankEnemySprite.m
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TankEnemySprite.h"
#define FRAME(image) [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:image]

@implementation TankEnemySprite
@synthesize score = _score,subDelegate = _subDelegate,tank = _tank;


+ (TankEnemySprite *)initWithKind:(int)kind {
    
    CCSpriteFrame* frame;
    TankEnemySprite* tank;
    switch (kind) {  
        case kSlow:{
            frame = FRAME(@"en1.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            tank.life = 1;
            tank.speed = 1;
            tank.score = 500;
            tank.kind = kSlow;
            tank.enemyKindForScore = kSlow;
            [tank setRotation:180];
            break;
        }
        case kQuike:{
            frame = FRAME(@"en2.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 1;
            tank.speed = 2;
            tank.score = 1000;
            tank.kind = kQuike;
            tank.enemyKindForScore = kQuike;
            [tank setRotation:180];
            break;
        }
        case kStrong:{
            frame = FRAME(@"en6.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 1;
            tank.speed = 1;
            tank.score = 1000;
            tank.kind = kStrong;
            tank.enemyKindForScore = kStrong;
            [tank setRotation:180];
            break;
        }
        case kStrongYellow:{
            frame = FRAME(@"en5.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 2;
            tank.speed = 1;
            tank.score = 1500;
            tank.kind = kStrongYellow;
            tank.enemyKindForScore = kStrongYellow;
            [tank setRotation:180];
            break;
        }
        case kStrongRedLife3:{
            frame = FRAME(@"en7.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 3;
            tank.speed = 1;
            tank.score = 2000;
            tank.isRead = YES;
            tank.kind = kStrongRedLife3;
            tank.enemyKindForScore = kStrongRedLife3;
            [tank setRotation:180];
            break;
        }
        case kStrongRed:{
            frame = FRAME(@"en7.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 1;
            tank.speed = 1;
            tank.score = 2500;
            tank.kind = kStrongRed;
            tank.enemyKindForScore = kStrongRed;
            tank.isRead = YES;
            [tank setRotation:180];
            break;
        }
        case kStrongGreen:{
            frame = FRAME(@"en3.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 3;
            tank.speed = 1;
            tank.score = 3000;
            tank.kind = kStrongGreen;
            tank.enemyKindForScore = kStrongGreen;
            [tank setRotation:180];
            break;
        }
        case kQuikeR:{
            frame = FRAME(@"en2r.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            
            tank.life = 1;
            tank.speed = 2;
            tank.score = 1000;
            tank.kind = kQuikeR;
            tank.enemyKindForScore = kQuikeR;
            tank.isRead = YES;
            [tank setRotation:180];
            break;
        }
        case kSlowR:{
            frame = FRAME(@"en1r.png");
            tank = [TankEnemySprite spriteWithSpriteFrame:frame];
            tank.life = 1;
            tank.speed = 1;
            tank.score = 500;
            tank.isRead = YES;
            [tank setRotation:180];
            tank.kind = kSlowR;
            tank.enemyKindForScore = kSlowR;
            break;
        }
        default:
            break;
    }
    
    tank.scale = 0.8f;
    tank.kAction = kDown;
    tank.isCanFire = YES;
    [tank animationBorn];
    [tank scheduleOnce:@selector(initAction) delay:1]; 
    return tank;
}
- (void)initAction {
    
    [self unschedule:@selector(initAction)];
    [self schedule:@selector(doRandomAction) interval:1];
    [self schedule:@selector(keepMove) interval:1/30];
    [self schedule:@selector(rodmoFire) interval:1];
}
- (void)doRandomAction {
    
    float ran = CCRANDOM_0_1();
    
    if (ran < 0.4) _kAction = kDown;
    else if (ran < 0.6) _kAction = kLeft;
    else if (ran < 0.9) _kAction = kRight;
    else _kAction = kUp;
    

}
- (void)keepMove {
    
    switch (_kAction) {
        case kUp:
            [self moveUp];
            break;
        case kDown:
            [self moveDown];
            break;
        case kLeft:
            [self moveLeft];
            break;
        case kRight:
            [self moveRight];
            break;
        default:
            break;
    }
}


- (void)checkTool {
    
}

- (void)stopTankAction {
    [self unschedule:@selector(doRandomAction)];
    [self unschedule:@selector(keepMove)];
    [self unschedule:@selector(rodmoFire)];
}

-(void)removeSelfFromMap {

    [self removeFromParentAndCleanup:YES];
}

- (void)rodmoFire {
    
    int rodom ; 

    for (int i = 0 ;i < 4; i++){
        rodom = arc4random() % 4;
        if (rodom == 0){
            [self onFire];
        }else if (rodom == 1){
            [self unschedule:@selector(onFire)];
            [self scheduleOnce:@selector(onFire) delay:0.2];
        }else if (rodom == 2){
            [self unschedule:@selector(onFire)];
            [self scheduleOnce:@selector(onFire) delay:0.4];
        }else if (rodom == 3){
            [self unschedule:@selector(onFire)];
            [self scheduleOnce:@selector(onFire) delay:0.7];
        }
    }
}

- (void)onFire {
   
     CCSpriteFrame* frameButtle = FRAME(@"bullet.png");
    if (_isCanFire == NO) return;
    _buttleOrientation = _kAction;     
    CCSprite* buttle = [CCSprite spriteWithSpriteFrame:frameButtle];
    
    _buttleSprite = buttle;
    
    [_delegate initButtleDidFinish:self buttle:buttle];
    buttle.visible = NO;
    _isCanFire = NO;
    
    [self fire:buttle orientation:_kAction];
}
- (void)checkBang:(NSTimer *)timer {
    

    CCSprite* buttle = [timer userInfo];
    
    if ([self checkLayer2:buttle]){
        [timer invalidate];_timer = nil;
        _isCanFire = YES;
        [buttle removeFromParentAndCleanup:YES],_buttleSprite = nil;
        return;
    }
    
    if ([self checkHome:buttle]){
        [timer invalidate];_timer = nil;
        _isCanFire = YES;
        [buttle removeFromParentAndCleanup:YES],_buttleSprite = nil;
        return;
    }
    
    if (_isButtleDone) {  
        [timer invalidate];_timer = nil;
        [buttle removeFromParentAndCleanup:YES];
        _isCanFire = YES;
        _isButtleDone = NO;
        _buttleSprite = nil;
        return;
    }
    
    if ([self checkTank:buttle]){
        [timer invalidate];_timer = nil;
        [buttle removeFromParentAndCleanup:YES],_buttleSprite = nil;
        _isCanFire = YES;
        return;
    }
    
    if ([self checkWall:buttle]) {
        [timer invalidate];_timer = nil;
        [buttle removeFromParentAndCleanup:YES],_buttleSprite = nil;
        _isCanFire = YES;
        return;
    }
    
    if ([self checkStrongWall:buttle]) {
        [timer invalidate];_timer = nil;
        [buttle removeFromParentAndCleanup:YES],_buttleSprite = nil;
        _isCanFire = YES;
        return;
    }
    
    if ([self checkBound:buttle]){
        [timer invalidate];_timer = nil;
        _isCanFire = YES;
        [buttle removeFromParentAndCleanup:YES],_buttleSprite = nil;
        return;
    }
}
- (BOOL)checkHome:(CCSprite *)buttle {
    

    CGRect rc = _homeRect;
    if (CGRectContainsPoint(rc, buttle.position)) {
        
        if (_tank.isHomeProtect) return YES;
        if (!_isHomeDone){
            _isHomeDone = YES;
            [_delegate gameOver:self]; 
            
        }
        return YES;
    }
    return NO;
}
- (BOOL)checkTank:(CCSprite *)buttle {
    

    CGRect tankRect;
     
     //敌人tank才做这个检测 所以self值得是敌人tank
    
    if (_tank.visible != NO){
        
        
        tankRect = CGRectMake(_tank.position.x - _tank.boundingBox.size.width/2,
                              _tank.position.y - _tank.boundingBox.size.height/2,
                              _tank.boundingBox.size.width,
                              _tank.boundingBox.size.height);
        if (CGRectContainsPoint(tankRect, buttle.position)) {
            
            if (_tank.isProtect) { 
                return YES;
            }else {
                CCSpriteFrame* newFrame;
                if (_tank.kind == kPlusStarThree){
                    newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p1-b.png"];
                    _tank.displayFrame = newFrame;
                    _tank.speed = 1.5;
                    _tank.kind = kPlusStarTwo;
                    return YES;
                }else if (_tank.kind == kPlusStarTwo){
                    newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p1-a.png"];
                    _tank.displayFrame = newFrame;
                    _tank.speed = 1.5;
                    _tank.kind = kPlusStarOne;
                    return YES;
                }else {
                    
                    newFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p1.png"];
                    _tank.displayFrame = newFrame;
                    _tank.speed = 1;
                    _tank.kind = kBorn;
//           
                    [_tank topButtle];
                }
            }
        }
    }

return NO;
     
    
}
- (void)playMoveVideo {
    
}
- (BOOL)checkTankPosition {



    CGRect tankEnemy;
    CGPoint point;
    CGPoint tp = self.position;

    if (_kAction == kUp){
        point = ccp(tp.x,tp.y + self.boundingBox.size.height / 2 + _speed);
    }else if (_kAction == kDown){
        point = ccp(tp.x,tp.y - self.boundingBox.size.height / 2 - _speed);
    }else if (_kAction == kLeft) {
        point =  ccp(tp.x - self.boundingBox.size.width/2 - _speed,tp.y); 
    }else if (_kAction == kRight) {
        point = ccp(tp.x + self.boundingBox.size.width/2 + _speed,tp.y); 
    }
    tankEnemy = CGRectMake(_tank.position.x - _tank.boundingBox.size.width/2,
                           _tank.position.y - _tank.boundingBox.size.height/2,
                           _tank.boundingBox.size.width,
                           _tank.boundingBox.size.height); 
    if (CGRectContainsPoint(tankEnemy, point)){
        return YES;
    }
    return NO;
}
- (void)dealloc {
    
     CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [super dealloc];
}
- (void)onExit {
    
   
    
     CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [super onExit];
    
    [_buttleSprite removeFromParentAndCleanup:YES];     
    [_tank release],_tank = nil;
    
}
@end
