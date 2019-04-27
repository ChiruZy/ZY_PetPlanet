//
//  MyAdoptViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/25.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MyAdoptViewController.h"
#import "MyAdoptCell.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "ZYSVPManager.h"
#import <YYModel.h>
#import "AdoptDetailViewController.h"
#import "HintView.h"

@interface MyAdoptViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HintView *hintView;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSMutableArray *models;
@property (nonatomic,assign) BOOL networking;
@end

@implementation MyAdoptViewController

- (instancetype)initWithUid:(NSString *)uid{
    if (self = [super init]) {
        _uid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"Adopt List";
    [_tableView registerNib:[UINib nibWithNibName:@"MyAdoptCell" bundle:nil] forCellReuseIdentifier:@"MyAdoptCell"];
    __weak typeof(self) weakSelf = self;
    _hintView.refresh = ^{
        [weakSelf reloadData];
    };
    [_hintView moveY:-40];
    [self configHeaderAndFooter];
    [self reloadData];
}

- (void)configHeaderAndFooter{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"UFO_0"];
    [header setImages:@[image] forState:MJRefreshStatePulling];
    [header setImages:[Common getUFOImage] forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    _tableView.mj_footer = footer;
}

#pragma mark - network
- (void)reloadData{
    if (_networking) {
        [_tableView.mj_header endRefreshing];
        return;
    }
    _networking = YES;
    NSString *url = @"http://106.14.174.39/pet/adopt/get_my_adopt.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"uid":_uid};
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                [weakSelf.hintView setType:HintHiddenType needButton:NO];
                [weakSelf.tableView.mj_footer resetNoMoreData];
                [weakSelf.tableView.mj_header endRefreshing];
                NSArray *arr = responseObject[@"items"];
                if (arr.count == 0) {
                    [weakSelf.hintView setType:HintNoCandyType needButton:YES];
                    weakSelf.networking = NO;
                    return;
                }
                [weakSelf.models setArray:[weakSelf parserData:arr]];
                [weakSelf.tableView reloadData];
                weakSelf.networking = NO;
                return;
            }
        }
        [weakSelf.hintView setType:HintNoConnectType needButton:YES];
        [ZYSVPManager showText:@"Load Failed" autoClose:1.5];
        weakSelf.networking = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.hintView setType:HintNoConnectType needButton:YES];
        [ZYSVPManager showText:@"Connect Failed" autoClose:1.5];
        weakSelf.networking = NO;
    }];
}

- (void)moreData{
    if (_networking) {
        [_tableView.mj_footer endRefreshing];
        return;
    }
    _networking = YES;
    NSString *url = @"http://106.14.174.39/pet/adopt/more_my_adopt.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    __weak typeof(self) weakSelf = self;
    AdoptModel *model = _models.lastObject;
    NSDictionary *param = @{@"uid":_uid,
                            @"last":model.aid
                            };
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.models addObjectsFromArray:[weakSelf parserData:responseObject[@"items"]]];
                [weakSelf.tableView reloadData];
                weakSelf.networking = NO;
                return;
            }
        }
        weakSelf.networking = NO;
        [ZYSVPManager showText:@"Load Failed" autoClose:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.networking = NO;
        [ZYSVPManager showText:@"Connect Failed" autoClose:1.5];
    }];
}

- (NSArray *)parserData:(NSArray *)arr{
    if (arr.count<10) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    NSMutableArray *newArr = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        AdoptModel *model = [AdoptModel yy_modelWithJSON:dic];
        [newArr addObject:model];
    }
    return newArr.copy;
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _models.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAdoptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAdoptCell" forIndexPath:indexPath];
    [cell configWithAdoptModel:_models[indexPath.section]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray new];
    }
    return _models;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AdoptModel *model = _models[indexPath.section];
    AdoptDetailViewController *adoptDVC = [[AdoptDetailViewController alloc]initWithModel:model];
    [self.navigationController pushViewController:adoptDVC animated:YES];
}
@end
