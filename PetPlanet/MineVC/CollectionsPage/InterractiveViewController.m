//
//  CollectionsViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "InterractiveViewController.h"
#import "LoginView.h"
#import "LoginViewController.h"
#import "InterractiveCell.h"
#import "InterractiveNetworking.h"
#import <MJRefresh.h>
#import "NotConnectView.h"
#import "PersonalViewController.h"

@interface InterractiveViewController ()<UITableViewDelegate,UITableViewDataSource,CandyCellDelegate>
@property (weak, nonatomic) IBOutlet LoginView *loginView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NotConnectView *notConnectView;

@property (nonatomic,strong) InterractiveNetworking *network;
@property (nonatomic,assign) InterractiveVCType type;
@end

@implementation InterractiveViewController

- (instancetype)initWithInterractiveType:(InterractiveVCType)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    if (_type == InterractiveVCLikeType) {
        self.navigationItem.title = @"My Favorite";
    }else{
        self.navigationItem.title = @"Collections";
    }
    [self judgeIsLogin];
    
}

- (void)judgeIsLogin{
    [self configWithTableView];
    if ([ZYUserManager shareInstance].isLogin) {
        [self configWithTableView];
    }else{
        _loginView.hidden = NO;
        [_loginView loginButtonAddTarget:self action:@selector(login)];
    }
}

- (void)login{
    __weak typeof(self) weakSelf = self;
    LoginViewController *loginVC = [[LoginViewController alloc]initWithLoginBlock:^(NSString * _Nonnull uid) {
        [weakSelf judgeIsLogin];
    }];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)configWithTableView{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"InterractiveCell" bundle:nil] forCellReuseIdentifier:@"InterractiveCell"];
    [self configHeaderAndFooter];
}

- (void)configHeaderAndFooter{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header setImages:[Common getUFOImage] forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.stateLabel.hidden = YES;
    _tableView.mj_footer = footer;
}


- (void)reload{
    __weak typeof(self) weakSelf = self;
    [self.network reloadModelsWithComplete:^{
        [weakSelf.tableView reloadData];
        weakSelf.notConnectView.hidden = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer resetNoMoreData];
    } fail:^(NSString *error) {
        if ([error isEqualToString:@"13"]||[error isEqualToString:@"14"]) {
            weakSelf.notConnectView.hidden = NO;
            weakSelf.loginView.hidden = YES;
        }if ([error isEqualToString:@"12"]) {
            weakSelf.loginView.hidden = NO;
            weakSelf.notConnectView.hidden = YES;
        }if ([error isEqualToString:@"16"]){
            
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    [self.network loadMoreWithComplete:^(BOOL noMore) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
        if (noMore) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } fail:^(NSString *error) {
        if ([error isEqualToString:@"16"]){
            
        }
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.network.models.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 370;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 20;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InterractiveCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"InterractiveCell" forIndexPath:indexPath];
    [cell configCellWithModel:_network.models[indexPath.section]];
    cell.delegate = self;
    return cell;
}

#pragma getter & setter
- (InterractiveNetworking *)network{
    if (!_network) {
        if (_type == InterractiveVCLikeType) {
            _network = [[InterractiveNetworking alloc]initWithNetWorkingType:InterractiveLikeType];
        }else{
            _network = [[InterractiveNetworking alloc]initWithNetWorkingType:InterractiveCollectionType];
        }
    }
    return _network;
}

- (void)cellDidTapReplyWithModel:(CandyModel *)model{
    
}

- (void)cellDidTapHeadOrNameWithModel:(CandyModel *)model{
    PersonalViewController *personalVC =[[PersonalViewController alloc]initWithUserID:model.authorID];
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)cellDidTapLikeWithModel:(CandyModel *)model isLike:(BOOL)isLike{
    
}


@end
