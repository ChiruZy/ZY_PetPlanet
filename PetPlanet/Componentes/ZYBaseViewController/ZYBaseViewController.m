//
//  ZYBaseViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"
#import "ZYSVPManager.h"

@interface ZYBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ZYBaseViewController

#pragma mark - init
- (instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled  = YES;
    
    if (self.navigationController.viewControllers.count>1) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemEvent)];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = @[backItem];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:!self.needNavBar animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZYSVPManager dismiss];
}

- (void)backItemEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL result = NO;
    if( gestureRecognizer == self.navigationController.interactivePopGestureRecognizer ){
        if(self.navigationController.viewControllers.count >= 2){
            result = YES;
        }
    }
    return result;
}
@end
