//
//  MapLayer.m
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapLayer.h"
#import "Tank90Sprite.h"
#import "TankEnemySprite.h"
#import "StartScene.h"
#import "ScoreScene.h"
#import "SimpleAudioEngine.h"

@interface MapLayer(PrivateMethods)

- (void)initAIPlistFile;
- (void)upQutoRemoveTool;
- (CGPoint)objectPosition:(CCTMXObjectGroup *)group object:(NSString *)object;

@end

@implementation MapLayer

@synthesize map = _map,delegate = _delegate,tank1 = _tank1;


- (id)initWithMap:(int)leve kind:(int)tKind life:(int)numLife {
    
    self = [super initWithColor:ccc4(0, 0, 0, 255)];
    if ( self != nil ) {
        
        _leve = leve;
        _winSize = [[CCDirector sharedDirector] winSize];
        

        self.map = [CCTMXTiledMap tiledMapWithTMXFile:[NSString stringWithFormat:@"map%d.tmx",leve]];

 

        float big = _winSize.height/_map.contentSize.height; 
        _map.scale = big;


        _bg1Layer = [_map layerNamed:@"bg1"];
        _bg2Layer = [_map layerNamed:@"bg2"];
        _bg2Layer.visible = NO;//将层2隐藏
        

        _objects = [_map objectGroupNamed:@"objects"];
        

        CGPoint homePoint = [self objectPosition:_objects object:@"home"];
        _home = [CCSprite spriteWithFile:@"home.png"];
        _home.position = ccp(homePoint.x + _home.textureRect.size.width/2,homePoint.y + _home.
                             textureRect.size.height/2);
        _homeRect = CGRectMake(_home.position.x - _home.textureRect.size.width/2,
                               _home.position.y - _home.textureRect.size.height/2,
                               _home.textureRect.size.width, 
                               _home.textureRect.size.height);
        [_map addChild:_home z:-1];
        

        [self changeWidth:_winSize.height height:_winSize.height];
        self.position = ccp(_winSize.width/6,0);
        [self addChild:_map];
        
        
         

        _tank1 = [Tank90Sprite initWithDelegate:self life:numLife tKind:tKind mapSize:_bg1Layer.contentSize];
        

        CGPoint tankPosition = [self objectPosition:_objects object:@"pl1"];
        _tank1.position = ccp(tankPosition.x + _tank1.boundingBox.size.width/2,tankPosition.y + _tank1.boundingBox.size.height/2);
        _tank1.bornPosition = _tank1.position;
        _tank1.homeRect = _homeRect;
        [_map addChild:_tank1 z:-1 tag:100];
       
        

        _enemyNum = 1;
        _enemyArray = [[NSMutableArray arrayWithCapacity:0] retain];
        [self initAIPlistFile]; 
        [self schedule:@selector(initEnemys) interval:2];
        

        _rodamPoint = 10;
        _pointArray = [[NSMutableArray arrayWithCapacity:0] retain];
        _propArray = [[NSMutableArray arrayWithCapacity:0]retain];
        
        for (int i = 1; i<=_rodamPoint;i++){
            CGPoint point = [self objectPosition:_objects object:[NSString stringWithFormat:@"t%d",i]];
            [_pointArray addObject:[NSValue valueWithCGPoint:point]];
        }
        
    }
    return  self;

}

- (CGPoint)objectPosition:(CCTMXObjectGroup *)group object:(NSString *)object {
    
    CGPoint point;
    NSMutableDictionary* dic = [group objectNamed:object];
    point.x = [[dic valueForKey:@"x"] intValue];
    point.y = [[dic valueForKey:@"y"] intValue];
    return point;
}


- (void)initAIPlistFile {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"AI" ofType:@"plist"];
    NSMutableDictionary* data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    _aiDic = [[data objectForKey:[NSString stringWithFormat:@"leve%d",_leve]] retain];
    [data release];
  
    
}

- (CGPoint)tileCoordinateFromPosition:(CGPoint)pos {
    
    int cox,coy;
    CGSize szLayer = _bg1Layer.layerSize;
    CGSize szTile = _map.tileSize;
    
    cox = pos.x / szTile.width;
    coy = szLayer.height - pos.y / szTile.height;
    if ((cox >=0) && (cox < szLayer.width) && (coy >= 0) && (coy < szLayer.height)) {
        return  ccp(cox,coy);
    }else {
        return ccp(-1,-1);
    }
    
} 

- (unsigned int)tileIDFromPosition:(CGPoint)pos {
    
    CGPoint cpt = [self tileCoordinateFromPosition:pos];
    if (cpt.x < 0) return  -1;
    if (cpt.y < 0) return -1;
    if (cpt.x >= _bg1Layer.layerSize.width) return -1;
    if (cpt.y >= _bg1Layer.layerSize.height) return -1;
    

    return [ _bg1Layer tileGIDAt:cpt];
    
}
- (unsigned int)tileIDFromPositionFroLayer2:(CGPoint)pos {
    
    if (!_bg2Layer.visible) return 0;
    CGPoint cpt = [self tileCoordinateFromPosition:pos];
    if (cpt.x < 0) return  -1;
    if (cpt.y < 0) return -1;
    if (cpt.x >= _bg2Layer.layerSize.width) return -1;
    if (cpt.y >= _bg2Layer.layerSize.height) return -1;
    return [ _bg2Layer tileGIDAt:cpt];
}



- (void)destpryTile:(CGPoint)pos {
    CGPoint cpt = [self tileCoordinateFromPosition:pos];
    [_bg1Layer setTileGID:0 at:cpt];
}


- (void)initEnemys {
  
    if (_enemyNum > 20 && _enemyArray.count == 0) {
        [self unschedule:@selector(initEnemys)];
        [self scheduleOnce:@selector(gotoScoreScene) delay:3];
    }
    
    if (_enemyNum > 20) return;
    if (_enemyArray.count >= 4) return;


    NSNumber* tankKind = [_aiDic objectForKey:[NSString stringWithFormat:@"%d",_enemyNum++]];

    TankEnemySprite* enemy = [TankEnemySprite initWithKind:tankKind.intValue];
    enemy.mapSize = _bg1Layer.contentSize;
    enemy.delegate = self;
    enemy.tank = _tank1;

    enemy.homeRect = _homeRect;
    
    

    if (_bornNum == 3){
        _bornNum = 0;
    }
    int random = _bornNum;
    _bornNum ++;
   
    CGPoint poin;

    if ( random == 0){
        poin = [self objectPosition:_objects object:@"en1"];
    }else if (random == 1) {
        poin = [self objectPosition:_objects object:@"en2"];
        
    }else if (random == 2) {
        poin = [self objectPosition:_objects object:@"en3"];
    }else {
        poin = [self objectPosition:_objects object:@"en3"];
    }
    

    enemy.position = ccp(poin.x + enemy.boundingBox.size.width/2,poin.y + enemy.boundingBox.size.height/2);
    [_map addChild:enemy z:-1];
    
    [_enemyArray addObject:enemy]; 
    

     [self.delegate bornEnmey];
}


- (void)gotoScoreScene {
    CCScene* scoreScene = [[ScoreScene alloc] initWithNumber:_slow quike:_quike strong:_strong strongY:_strongYe strongG:_strongG leve:_leve kind:_tank1.kind life:_tank1.life];
    [[CCDirector sharedDirector] replaceScene:scoreScene];
    [scoreScene release];
}

#pragma mark-
#pragma mark Tank90SpriteDelegate methods

- (void)initButtlesDidFinish:(Tank90Sprite *)aTank buttle1:(CCSprite *)buttle1 buttle2:(CCSprite *)buttle2 {
    
    [_map addChild:buttle1];
    [_map addChild:buttle2];

}

- (int)tileIDFromPosition:(CGPoint)pon aTank:(Tank90Sprite *)aTank {
    return [self tileIDFromPosition:pon];
}
- (void)initButtleDidFinish:(Tank90Sprite *)aTank buttle:(CCSprite *)buttle {

    [_map addChild:buttle];
}

- (void)destpryTile:(CGPoint)pon aTank:(Tank90Sprite *)aTank {
    [self destpryTile:pon];
}

- (NSMutableArray *)enemyArray:(Tank90Sprite *)aTank {
    return _enemyArray;
}

- (void)removeSprite:(Tank90Sprite *)aTank {
    
    
    TankEnemySprite* tank = (TankEnemySprite *)aTank;
   
    if (tank.enemyKindForScore == kSlow || tank.enemyKindForScore == kSlowR) {
        _slow++;
    }else if (tank.enemyKindForScore == kQuike || tank.enemyKindForScore == kQuikeR){
        _quike++;
    }else if (tank.enemyKindForScore == kStrong || tank.enemyKindForScore == kStrongRed){
        _strong++;
    }else if (tank.enemyKindForScore == kStrongYellow){
        _strongYe++;
    }else if (tank.enemyKindForScore == kStrongRedLife3 || tank.enemyKindForScore == kStrongGreen) {
        _strongG++;
    }
    
    [_enemyArray removeObject:tank];
    [tank stopTankAction];
    [tank scheduleOnce:@selector(removeSelfFromMap) delay:0.3];
}


- (CCSprite *)home {
    return _home;
}
- (void)gameOver:(Tank90Sprite *)tank {      
    
    [self unschedule:@selector(initEnemys)];
    
    if (_isGameOver)return;
  
    UIImage* image = [UIImage imageNamed:@"home2.png"];
    CCTexture2D* newTexture = [[CCTextureCache sharedTextureCache] addCGImage:image.CGImage forKey:nil];
    [_home setTexture:newTexture];
    
   
    CCSprite* gameSprite = [CCSprite spriteWithFile:@"gamedone.png"];
    gameSprite.scale = 8.0f;
    gameSprite.position = ccp(_bg1Layer.contentSize.width/2,-10);
    CGPoint overPoint = ccp(_bg1Layer.contentSize.width/2,_bg1Layer.contentSize.height/2);
    [_map addChild:gameSprite z:2];
    
    id ac1 = [CCMoveTo actionWithDuration:4 position:overPoint];
    [gameSprite runAction:ac1];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"gameover.aif"];
  
    [self schedule:@selector(retunMainScene) interval:5];
    _isGameOver = YES;
}
- (void)retunMainScene {
    [[CCDirector sharedDirector] replaceScene:[StartScene scene]];
}
- (void)createTool {

    [[SimpleAudioEngine sharedEngine] playEffect:@"sound3.aif"];
 
    int rodam = arc4random() % 6 + 1;  //有可能生成0 所以-1 +1
    
    ToolSprite* propSprite;
    if (_propArray.count != 0){
        propSprite = [_propArray lastObject];
        [propSprite removeFromParentAndCleanup:YES];
        [_propArray removeAllObjects];
    }
    propSprite = [ToolSprite initWithKind:rodam];

    NSValue* value =  [_pointArray lastObject];
    CGPoint point = [value CGPointValue];
    propSprite.position = ccp(point.x + propSprite.textureRect.size.width/2 , point.y + propSprite.textureRect.size.height/2);
    [_map addChild:propSprite z:-1];
    [_pointArray removeObject:value];
    [_propArray addObject:propSprite];
    
    
    
    [self upQutoRemoveTool]; 
    
}
- (void)upQutoRemoveTool{
    [self unschedule:@selector(autoRemoveTool)]; //取消之前定时 开启一个全新的
    [self scheduleOnce:@selector(autoRemoveTool) delay:10];
}
- (void)autoRemoveTool {
    ToolSprite* sprite = [_propArray lastObject];
    [sprite removeFromParentAndCleanup:YES];
    [_propArray removeAllObjects];
}

- (NSMutableArray *)toolsArray:(Tank90Sprite *)aTank {
    return _propArray;
}

- (void)removeTool:(ToolSprite *)tool {
    [_map removeChild:tool cleanup:YES];
}

- (void)homeProtect:(BOOL)isProtect aTank:(Tank90Sprite *)aTank {

    _bg2Layer.visible = isProtect;
}

- (void)plusBoon:(Tank90Sprite *)aTank {
    
    for (Tank90Sprite* tankSprite in _enemyArray) {
        [tankSprite animationBang];
        [tankSprite scheduleOnce:@selector(removeSelfFromMap) delay:0.3];
    }
    [_enemyArray removeAllObjects];
    
}

- (void)changeLife:(Tank90Sprite *)tank {
    [_delegate changeTankLife:tank.life];
}

- (void)plusPass:(Tank90Sprite *)aTank {
    
    for (TankEnemySprite* tankSprite in _enemyArray) {
        [tankSprite stopTankAction]; 
        [tankSprite scheduleOnce:@selector(initAction) delay:5];
    }
}

- (int)tileIDFromPositionLayer2:(CGPoint)pon aTank:(Tank90Sprite *)aTank {
    return [self tileIDFromPositionFroLayer2:pon];
}
#pragma mark-
#pragma mark TankEnemySpriteDelegate methods
- (Tank90Sprite *)tankFromMap:(Tank90Sprite *)aTank {
    return _tank1;
}

- (void)dealloc {
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    
    [super dealloc];
    
}
- (void)onExit {
    
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [super onExit]; 
    [_map release],_map = nil;  

    [_delegate release],_delegate = nil;
    [_propArray release],_propArray = nil;
    [_pointArray release],_pointArray = nil;
    [_enemyArray release],_enemyArray = nil;
    [_aiDic release],_aiDic = nil;
    [self removeAllChildrenWithCleanup:YES];
    
}
@end
