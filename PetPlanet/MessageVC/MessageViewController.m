//
//  MessageViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MessageViewController.h"
#import "LoginViewController.h"

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"Message";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (NO) {
        _loginView.hidden = YES;
    }
}

- (IBAction)login:(id)sender {
    LoginViewController *loginVC = [LoginViewController new];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
