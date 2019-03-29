//
//  FavoriteViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "FavoriteViewController.h"
#import "LoginView.h"
#import "LoginViewController.h"

@interface FavoriteViewController ()
@property (weak, nonatomic) IBOutlet LoginView *loginView;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"My Favorite";
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
    LoginViewController *loginVC = [LoginViewController new];
    [self.navigationController pushViewController:loginVC animated:YES];
}
@end
