//
//  FollowViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/5/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "FollowViewController.h"
#import "SearchUserCell.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <YYModel.h>
#import "ZYSVPManager.h"
#import "PersonalViewController.h"


@interface FollowViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSString *uid;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *model;
@property (nonatomic,assign) BOOL networking;
@property (nonatomic,assign) BOOL following;

@end

@implementation FollowViewController

- (instancetype)initWithUid:(NSString *)uid{
    if (self = [super init]) {
        _uid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"Follows";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"SearchUserCell" bundle:nil] forCellReuseIdentifier:@"SearchUserCell"];
    [self configHeaderAndFooter];
    [self reload];
}

- (void)configHeaderAndFooter{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"UFO_0"];
    [header setImages:@[image] forState:MJRefreshStatePulling];
    [header setImages:[Common getUFOImage] forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}


- (void)reload{
    if (_networking) {
        [_tableView.mj_header endRefreshing];
        return;
    }
    
    _networking = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    NSString *url = @"http://106.14.174.39/pet/candy/get_follow_list.php";
    NSDictionary *param = @{@"sid":[ZYUserManager shareInstance].userID,@"uid":_uid};
    
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [ZYSVPManager showText:@"Server Error" autoClose:2];
            return ;
        }
        NSString *error = responseObject[@"error"];
        if (![error isEqualToString:@"10"]) {
            [ZYSVPManager showText:@"Server Error" autoClose:2];
        }
        
        [weakSelf.model setArray:[self parserData:responseObject[@"items"]]];
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer resetNoMoreData];
        if (weakSelf.model.count<20) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        weakSelf.networking = NO;
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Connect Failed" autoClose:2];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (NSArray *)parserData:(NSArray *)arr{
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        SearchUserModel *model = [SearchUserModel yy_modelWithJSON:dic];
        [result addObject:model];
    }
    return result.copy;
}

- (void)loadMoreData{
    if (_networking) {
        [_tableView.mj_footer endRefreshing];
        return;
    }
    _networking = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    NSString *url = @"http://106.14.174.39/pet/candy/more_follow_list.php";
    SearchUserModel *model = _model.lastObject;
    NSDictionary *param = @{@"sid":[ZYUserManager shareInstance].userID,@"uid":_uid,@"last":model.uid};
    
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [ZYSVPManager showText:@"Server Error" autoClose:2];
            return ;
        }
        NSString *error = responseObject[@"error"];
        if ([error isEqualToString:@"16"]) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        
        if (![error isEqualToString:@"10"]) {
            [ZYSVPManager showText:@"Server Error" autoClose:2];
        }
        
        [weakSelf.model addObjectsFromArray:[self parserData:responseObject[@"back"]]];
        
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.model.count<20) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        weakSelf.networking = NO;
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Connect Failed" autoClose:2];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


- (void)followEventWithUid:(NSString *)uid isFollow:(BOOL)isFollow complete:(Complete)complete{
    if (_following) {
        return;
    }
    
    _following = YES;
    NSString *url = @"http://106.14.174.39/pet/mine/set_follow.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    NSDictionary *param = @{@"uid":[ZYUserManager shareInstance].userID,
                            @"oid":uid,
                            @"isFollow":isFollow?@"1":@"0",
                            };
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if([error isEqualToString:@"10"]){
                complete();
                weakSelf.following = NO;
                return;
            }
        }
        weakSelf.following = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.following = NO;
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchUserCell"];
    __weak typeof(self) weakSelf = self;
    cell.block = ^(NSString * _Nonnull uid, BOOL isFollow, Complete  _Nonnull complete) {
        if (![ZYUserManager shareInstance].isLogin) {
            [ZYSVPManager showText:@"Not Login" autoClose:2];
            return;
        }
        [weakSelf followEventWithUid:uid isFollow:isFollow complete:complete];
        return;
    };
    [cell configWithModel:_model[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchUserModel *model = _model[indexPath.row];
    PersonalViewController *personalVC = [[PersonalViewController alloc]initWithUserID:model.uid];
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (NSMutableArray *)model{
    if (!_model) {
        _model = [NSMutableArray new];
    }
    return _model;
}
@end
