//
//  AppDelegate.h
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref  //弱引用
}

@property (nonatomic, retain) UIWindow *window;                     //主窗口
@property (readonly) UINavigationController *navController;         //导航控制器
@property (readonly) CCDirectorIOS *director;                       //导演类。

@end
