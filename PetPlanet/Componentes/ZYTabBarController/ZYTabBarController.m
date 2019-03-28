//
//  ZYTabBarController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/26.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYTabBarController.h"

@interface ZYTabBarController ()

@end

@implementation ZYTabBarController

- (instancetype)initWithControllers:(NSArray<UIViewController *>*)controllers{
    if (self = [super init]) {
        self.tabBar.clipsToBounds = YES;
        [UITabBar appearance].translucent = NO;
        self.tabBar.backgroundColor = [UIColor whiteColor];
        self.viewControllers = controllers;
    }
    return self;
}

- (void)setItemsWithImageNameArray:(NSArray<NSString *> *)nameArray{
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > nameArray.count-1) {
            *stop = YES;
            return;
        }
        UIViewController *vc = obj;
        UIImage *image = [UIImage imageNamed:nameArray[idx]];
        UIImage *imageSelected = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",nameArray[idx]]];
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"" image:image selectedImage:imageSelected];
        item.imageInsets = UIEdgeInsetsMake(5, 0, - 5, 0);
        vc.tabBarItem = item;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
@end
