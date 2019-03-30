//
//  CandyTableViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CandyTableViewController.h"
#import "CandyCell.h"
#import <MJRefresh/MJRefresh.h>
#import "CandyNetworking.h"
#import "NotConnectView.h"
#import "LoginView.h"
#import "LoginViewController.h"

@interface CandyTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet LoginView *loginView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NotConnectView *notConnectView;
@property (nonatomic,strong) CandyNetworking *network;
@property (nonatomic,assign) CandyListType type;
@end

@implementation CandyTableViewController

- (instancetype)initWithCandyListType:(CandyListType)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [_notConnectView reloadButtonAddTarget:self action:@selector(reload)];
    [_loginView loginButtonAddTarget:self action:@selector(login)];
}

- (void)configTableView{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CandyCell" bundle:nil] forCellReuseIdentifier:@"CandyCell"];
    _tableView.hidden = YES;
    [self reload];
    [self configHeaderAndFooter];
}

- (void)configHeaderAndFooter{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerEvent)];
    _tableView.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerEvent)];
    _tableView.mj_footer = footer;
}

- (void)headerEvent{
    [self reload];
}

- (void)footerEvent{
    [self loadMoreData];
}

- (void)reload{
    __weak typeof(self) weakSelf = self;
    [self.network reloadModelsWithComplete:^{
        [weakSelf.tableView reloadData];
        weakSelf.tableView.hidden = NO;
        weakSelf.loginView.hidden = YES;
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
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)login{
    LoginViewController *lvc =[LoginViewController new];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (UIView *)listView{
    return self.view;
}

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
    
    CandyCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"CandyCell" forIndexPath:indexPath];
    return cell;
}

- (CandyNetworking *)network{
    if (!_network) {
        if (_type == CandyListFollowingType) {
            _network = [[CandyNetworking alloc]initWithNetWorkingType:
                       CandyNetworkingFollowingType];
        }else if (_type == CandyListRecommendType) {
            _network = [[CandyNetworking alloc]initWithNetWorkingType:
                        CandyNetworkingRecommendType];
        }else if (_type == CandyListNewsType) {
            _network = [[CandyNetworking alloc]initWithNetWorkingType:
                        CandyNetworkingNewsType];
        }
    }
    return _network;
}
@end
