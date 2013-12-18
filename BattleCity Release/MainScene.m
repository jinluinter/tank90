//
//  MainScene.m
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainScene.h"
#import "SimpleAudioEngine.h"

@interface MainScene(PrivateMethods)

-(void)iconTank;
- (void)showLife:(int)numLife;
- (void)showLeve:(int)inLeve;

@end

@implementation MainScene

@synthesize mapLayer = _mapLayer,leve = _leve,inputLayer = _inputLayer;

+ (id)scene {
    
    MainScene* scene = [MainScene node];

    return scene;
}





- (id)initWithMapInformation:(int)leve status:(int)status life:(int)life {
    
    self = [super init];
    
    if (self != nil){
        

        [[SimpleAudioEngine sharedEngine] playEffect:@"02 start.aif"];
        

        _winSize = [[CCDirector sharedDirector] winSize];
        

        CCLayerColor* backColor = [CCLayerColor layerWithColor:ccc4(192,192,192,255)];
        [self addChild:backColor];
        

        _frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [_frameCache addSpriteFramesWithFile:@"images.plist"];
        

        _iconArray = [[NSMutableArray arrayWithCapacity:0]retain];
        

        [self iconTank];
        

        CCSpriteFrame* ipLifeFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"IP.png"]; 
        CCSprite* ipLife = [CCSprite spriteWithSpriteFrame:ipLifeFrame];
        ipLife.position = ccp(30,_winSize.height - 50);
        [self addChild:ipLife];
        
        CCSpriteFrame* ipIconFrmae = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"p1.png"];
        CCSprite* ipLifeIcok = [CCSprite spriteWithSpriteFrame:ipIconFrmae];
        ipLifeIcok.position = ccp(20,_winSize.height - 70);
        ipLifeIcok.scale = 0.5f;
        [self addChild:ipLifeIcok];
        [self showLife:life];
        

        CCSpriteFrame* flagFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flag.png"];
        CCSprite* flag = [CCSprite spriteWithSpriteFrame:flagFrame];
        flag.position  = ccp(_winSize.width - 50 , _winSize.height - 200);
        [self addChild:flag];
        [self showLeve:leve];
        

        _mapLayer = [[MapLayer alloc] initWithMap:leve kind:status life:life];
        _mapLayer.delegate = self;
        [self addChild:_mapLayer];
        [_mapLayer release];
        

        _inputLayer = [InputLayer node];
        _inputLayer.mapLayer = _mapLayer;
        [self addChild:_inputLayer];

    }
    return self;
}





- (void)changLeve {
    
    [_leveString removeFromParentAndCleanup:YES];
    _leve++;
    _leveString = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_leve] fontName:@"Courier-Bold" fontSize:20];
    _leveString.position = ccp(_winSize.width - 40,_winSize.height - 80);
    _leveString.color = ccc3(0, 0, 0);
    [self addChild:_leveString];
}

- (void)removeCurrentLayer {
    [self unschedule:_cmd];//测试代码
    [_mapLayer removeFromParentAndCleanup:YES];
    
}

-(void)iconTank{
    

    int width = 55;
    int height = 15;
    

    CCSpriteFrame* iconFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"enemy.png"];
    

    CCSprite* iconA;
    CCSprite* iconB;
    

    for (int i = 0; i <10; i ++) {
        
        height += 15;
        iconA = [CCSprite spriteWithSpriteFrame:iconFrame];
        iconA.position = ccp(_winSize.width - width,_winSize.height - height);
        [self addChild:iconA];
        [_iconArray addObject:iconA];
        
        iconB = [CCSprite spriteWithSpriteFrame:iconFrame];
        iconB.position = ccp(_winSize.width - width + 18,_winSize.height - height);
        [self addChild:iconB];
        [_iconArray addObject:iconB];
    }
}

- (void)showLife:(int)numLife {
    
    [_1plifeString removeFromParentAndCleanup:YES];
    _1plifeString = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",numLife] fontName:@"Courier-Bold" fontSize:20];
    _1plifeString.color = ccc3(0, 0, 0);
    _1plifeString.position = ccp(45,_winSize.height - 70);
    [self addChild:_1plifeString];
}

- (void)showLeve:(int)inLeve {
    
    [_leveString removeFromParentAndCleanup:YES];
    _leveString = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",inLeve] fontName:@"Courier-Bold" fontSize:20];
    _leveString.color = ccc3(0, 0, 0);
    _leveString.position = ccp(_winSize.width - 50 , _winSize.height - 230);
    [self addChild:_leveString];
}

#pragma mark-
#pragma mark  MapLayerDelegate methods


- (void)bornEnmey {
    if (_iconArray.count > 0) {
        
        CCSprite* icon = [_iconArray lastObject];
        [icon removeFromParentAndCleanup:YES];
        [_iconArray removeLastObject];
    }

}

- (void)changeTankLife:(int)inLife {
    [self showLife:inLife];
}

- (void)dealloc {
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [super dealloc];
}

- (void)onExit {
    
     
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [_iconArray release],_iconArray = nil;
    [self removeAllChildrenWithCleanup:YES];   
    [super onExit];
   
}

@end
