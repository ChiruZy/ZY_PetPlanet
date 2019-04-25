//
//  SettingViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/22.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needNavBar = YES;
    self.navigationItem.title = @"Setting";
    
    if ([ZYUserManager shareInstance].isLogin) {
        [_button setTitle:@"Login Out" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_button setTitle:@"Login In" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(loginIn) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)loginOut{
    [[ZYUserManager shareInstance] LoginOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loginIn{
    LoginViewController *login = [[LoginViewController alloc]initWithLoginBlock:^(NSString * _Nonnull uid) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:login animated:YES];
}

@end
