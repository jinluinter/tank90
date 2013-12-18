//
//  StartScene.m
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "StartScene.h"
#import "MainScene.h"
#import "WinScene.h"

@interface StartScene(PrivateMethods)

- (void)initMenum;

@end

@implementation StartScene

+(id)scene {
    
    CCScene* scene = [CCScene node];
    CCLayer* layer = [StartScene node];
    [scene addChild:layer];
    return scene;
}

- (id)init {
    
    if (self = [super init]) {
        [self initMenum];
    }
    return  self;
}


- (void)initMenum {
    

    [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
    [CCMenuItemFont setFontSize:25];
    

    CCMenuItemFont* item1 = [CCMenuItemFont itemWithString:@"Start Game" target:self selector:@selector(menuItem1Touch:)];
    item1.position = ccp(0,-50);


    CCMenuItemImage* item3 = [CCMenuItemImage itemWithNormalImage:@"BattleCity.png" selectedImage:nil];
    item3.position = ccp(0,50);
    

    CCMenu* menu = [CCMenu menuWithItems:item1,item3, nil];
    

    [self addChild:menu];
}
- (void)menuItem1Touch:(id)sender {
    
    
    if (_isRun) return;
    

    CCScene* gameScene = [[ MainScene alloc] initWithMapInformation:1 status:1 life:3];

    
    [[CCDirector sharedDirector] replaceScene:gameScene];
    [gameScene release];
    _isRun = YES;
     
}
- (void)dealloc {
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [super dealloc];
}
- (void)onExit {
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [super onExit];
}
@end
