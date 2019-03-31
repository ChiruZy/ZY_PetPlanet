//
//  AppDelegate.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/7.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeVC/WelcomeViewController.h"
#import "AdoptViewController.h"
#import "CandyViewController.h"
#import "MineViewController.h"
#import "ZYTabBarController.h"
#import "ZYNavigationController.h"
#import "MessageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
//    WelcomeViewController *wvc =[WelcomeViewController new];
//    _window.rootViewController = wvc;
    __weak typeof(self) weakSelf = self;
    [weakSelf resetRootViewController];
//    wvc.block = ^{
//        [weakSelf resetRootViewController];
//    };
    [_window makeKeyAndVisible];
    
      [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    return YES;
}

- (void)resetRootViewController{
    AdoptViewController *adoptVC = [AdoptViewController new];
    ZYNavigationController *adoptNav = [[ZYNavigationController alloc]initWithRootViewController:adoptVC];
    
    CandyViewController *candyVC = [CandyViewController new];
    ZYNavigationController * candyNav = [[ZYNavigationController alloc]initWithRootViewController:candyVC];
    
    MineViewController *mineVC = [MineViewController new];
    ZYNavigationController * mineNav = [[ZYNavigationController alloc]initWithRootViewController:mineVC];
    
    MessageViewController *messageVC = [MessageViewController new];
    ZYNavigationController * messageNav = [[ZYNavigationController alloc]initWithRootViewController:messageVC];
    
    ZYTabBarController *tabBar = [[ZYTabBarController alloc]initWithControllers:@[candyNav,adoptNav,messageNav,mineNav]];
    [tabBar setItemsWithImageNameArray:@[@"main",@"candy",@"message",@"mine"]];
    _window.rootViewController = tabBar;
}
@end
