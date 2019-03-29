//
//  ZYNavigationController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYNavigationController.h"
#import "Common.h"

@interface ZYNavigationController ()

@end

@implementation ZYNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        //self.navigationBar.clipsToBounds = YES;
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationBar.layer.shadowOffset = CGSizeMake(0, 3);
        self.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
        self.navigationBar.layer.shadowOpacity = 0.2;
        self.navigationBar.translucent = NO;
        [self.navigationBar setBarTintColor:HEXCOLOR(0xA19FEC)];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
        
        [self.navigationBar setBackIndicatorImage:[[UIImage alloc]init]];
        [self.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage alloc] init]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count <= 1) {
        viewController.hidesBottomBarWhenPushed = NO;
    }
}

@end
