//
//  MessageViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MessageViewController.h"
#import "LoginViewController.h"
#import "HintView.h"

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet HintView *loginView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"Message";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ZYUserManager shareInstance].UserID.length>0) {
        _loginView.hidden = YES;
    }else{
        __weak typeof(self) weakSelf = self;
        [_loginView setType:HintLoginType needButton:YES];
        _loginView.login = ^{
            [weakSelf login];
        };
    }
}

- (void)login{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithLoginBlock:^(NSString * _Nonnull uid) {
        //TODO:
    }];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
