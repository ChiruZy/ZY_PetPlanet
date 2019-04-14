//
//  MessageViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/8.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MessageViewController.h"
#import "ConversationViewController.h"
#import "HintView.h"
#import "ZYUserManager.h"
#import "Common.h"
#import "LoginViewController.h"

@interface MessageViewController ()

@property (strong, nonatomic) HintView *hintView;

@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (![ZYUserManager shareInstance].isLogin) {
        self.hintView.hidden = NO;
        [self.hintView setType:HintLoginType needButton:YES];
    }else{
        self.hintView.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Message";
    self.isShowNetworkIndicatorView = NO;
    
    HintView *hintView = [[HintView alloc]initWithFrame:self.view.bounds];
    [hintView moveY:-50];
    [hintView setType:HintNoMessageType needButton:NO];
    self.emptyConversationView = hintView;
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
}



- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ConversationViewController *conversationVC = [[ConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (HintView *)hintView{
    if (!_hintView) {
        _hintView = [[HintView alloc]initWithFrame:self.view.bounds];
        _hintView.backgroundColor = HEXCOLOR(0xF9F9F9);
        __weak typeof(self) weakSelf = self;
        _hintView.login = ^{
            LoginViewController *loginVC = [[LoginViewController alloc]initWithLoginBlock:^(NSString * _Nonnull uid) {
            }];
            [weakSelf.navigationController pushViewController:loginVC animated:YES];
        };
        [self.view addSubview:_hintView];
    }
    return _hintView;
}

//- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.conversationListTableView reloadData];
//    });
//}
@end
