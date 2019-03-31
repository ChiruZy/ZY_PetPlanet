//
//  MessageViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MessageViewController.h"
#import "LoginViewController.h"
#import "LoginView.h"

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet LoginView *loginView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"Message";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (IS_LOGIN) {
        _loginView.hidden = YES;
    }else{
        [_loginView loginButtonAddTarget:self action:@selector(login)];
    }
}

- (void)login{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithLoginBlock:^(NSString * _Nonnull uid) {
        //TODO:
    }];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
