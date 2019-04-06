//
//  SearchUserViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/6.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "SearchUserViewController.h"
#import "SearchUserCell.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <YYModel.h>
#import "ZYSVPManager.h"
#import "PersonalViewController.h"

@implementation SearchUserModel

@end

@interface SearchUserViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSString *keyword;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *model;
@property (nonatomic,assign) BOOL networking;

@end

@implementation SearchUserViewController


- (instancetype)initWithKeyword:(NSString *)keyword{
    if (self = [super init]) {
        _keyword = keyword;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needNavBar = YES;
    self.navigationItem.title = _keyword;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview registerNib:[UINib nibWithNibName:@"SearchUserCell" bundle:nil] forCellReuseIdentifier:@"SearchUserCell"];
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
    _tableview.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.stateLabel.hidden = YES;
    _tableview.mj_footer = footer;
}

- (void)reload{
    if (_networking) {
        [_tableview.mj_header endRefreshing];
        return;
    }
    
    _networking = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"http://106.14.174.39/pet/search/search_user.php";
    NSDictionary *param = @{@"keyword":_keyword,@"uid":[ZYUserManager shareInstance].userID};
    
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
        
        [weakSelf.tableview refreshControl];
        if (weakSelf.model.count<20) {
            [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        weakSelf.networking = NO;
        [weakSelf.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Connect Failed" autoClose:2];
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    if (_networking) {
        [_tableview.mj_footer endRefreshing];
        return;
    }
    _networking = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"http://106.14.174.39/pet/search/search_more_user.php";
    SearchUserModel *model = _model.lastObject;
    NSDictionary *param = @{@"keyword":_keyword,@"uid":[ZYUserManager shareInstance].userID,@"last":model.uid};
    
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
        
        [weakSelf.model addObjectsFromArray:[self parserData:responseObject[@"back"]]];
        
        [weakSelf.tableview.mj_footer endRefreshing];
        if (weakSelf.model.count<20) {
            [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        weakSelf.networking = NO;
        [weakSelf.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Connect Failed" autoClose:2];
        [weakSelf.tableview.mj_footer endRefreshing];
    }];

    
    
}

- (void)followEventWithUid:(NSString *)uid isFollow:(BOOL)isFollow{
    
    
    
    
}

- (NSArray *)parserData:(NSArray *)arr{
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        SearchUserModel *model = [SearchUserModel yy_modelWithJSON:dic];
        [result addObject:model];
    }
    return result.copy;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchUserCell"];
    __weak typeof(self) weakSelf = self;
    cell.block = ^BOOL(NSString * _Nonnull uid, BOOL isFollow) {
        if (![ZYUserManager shareInstance].isLogin) {
            [ZYSVPManager showText:@"Not Login" autoClose:2];
            return NO;
        }
        [weakSelf followEventWithUid:uid isFollow:isFollow];
        return YES;
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
