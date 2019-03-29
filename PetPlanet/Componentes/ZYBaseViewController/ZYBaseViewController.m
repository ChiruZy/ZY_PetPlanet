//
//  ZYBaseViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"

@interface ZYBaseViewController ()

@end

@implementation ZYBaseViewController

#pragma mark - init
- (instancetype)init{
    if (self = [super init]) {
        if (self.navigationController) {
            self.needNavBar = YES;
        }
    }
    return self;
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.navigationController.viewControllers.count>1) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemEvent)];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = @[backItem];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.needNavBar) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)backItemEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
