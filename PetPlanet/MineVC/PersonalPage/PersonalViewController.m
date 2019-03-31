//
//  PersonalViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalCell.h"
#import <MJRefresh/MJRefresh.h>
#import "PhotoCell.h"
#import "CandyNetworking.h"
#import "CandyCell.h"
#import "StateCell.h"
#import "PersonalPageNetwork.h"
#import "ZYSVPManager.h"

typedef NS_ENUM(NSUInteger, CandyLoadState) {
    CandyLoadStateLoading,
    CandyLoadStateComplete,
    CandyLoadStateNoData,
    CandyLoadStateFail,
};

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) CandyNetworking *network;
@property (nonatomic,strong) PersonalPageNetwork *personalNetwork;

@property (nonatomic,assign) CandyLoadState state;
@property (nonatomic,assign) NSString *userID;
@property (nonatomic,assign) CGFloat threshold;
@property (nonatomic,assign) CGFloat marginTop;

@property (nonatomic,assign) BOOL isSelf;
@property (nonatomic,assign) BOOL footerLoading;
@property (nonatomic,assign) NSUInteger loadingStep;

@end

@implementation PersonalViewController

- (instancetype)initWithUserID:(NSString *)userID{
    if (self = [super init]) {
        _userID = userID;
        _loadingStep = 0;
        _footerLoading = NO;
        if ([_userID isEqualToString:UID]) {
            _isSelf = YES;
        }
        _marginTop = -80;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = NO;
    [self configTableView];
}

#pragma mark - Private Method

- (void)configTableView{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"UFO_0"];
    [header setImages:@[image] forState:MJRefreshStatePulling];
    [header setImages:[Common getUFOImage] forState:MJRefreshStateRefreshing];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.stateLabel.hidden = YES;
    _tableView.mj_footer = footer;
    
    _tableView.mj_header = header;
    [_tableView registerNib:[UINib nibWithNibName:@"PersonalCell" bundle:nil] forCellReuseIdentifier:@"PersonalCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellReuseIdentifier:@"PhotoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CandyCell" bundle:nil] forCellReuseIdentifier:@"CandyCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"StateCell" bundle:nil] forCellReuseIdentifier:@"StateCell"];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self refresh];
}


- (void)loadPersonalPage{
    __weak typeof(self) weakSelf = self;
    [self.personalNetwork loadWithUid:_userID complete:^{
        [weakSelf.tableView reloadData];
        weakSelf.loadingStep -= 1;
        weakSelf.name.text = weakSelf.personalNetwork.personal[@"name"];
    } fail:^(NSString * _Nonnull error) {
        if ([error isEqualToString:@"11"]||[error isEqualToString:@"12"]) {
            [ZYSVPManager showText:@"Load Failed" autoClose:2];
            weakSelf.loadingStep -= 1;
            return;
        }
        weakSelf.loadingStep -= 1;
    }];
}

- (void)loadCandyCells{
    __weak typeof(self) weakSelf = self;
    [self.network reloadModelsWithComplete:^{
        weakSelf.state = CandyLoadStateComplete;
        weakSelf.loadingStep -= 1;
        [weakSelf.tableView reloadData];
    } fail:^(NSString *error) {
        if ([error isEqualToString:@"13"]||[error isEqualToString:@"14"]) {
            [ZYSVPManager showText:@"Load Failed" autoClose:2];
            weakSelf.state = CandyLoadStateFail;
        }else if ([error isEqualToString:@"15"]){
            weakSelf.state = CandyLoadStateNoData;
        }else if ([error isEqualToString:@"16"]){
            weakSelf.loadingStep -= 1;
            return;
        }
        self.loadingStep -= 1;
        [weakSelf.tableView reloadData];
    }];
}

- (void)loadMoreData{
    if (_loadingStep > 0) {
        [_tableView.mj_footer endRefreshing];
        return;
    }
    _footerLoading = YES;
    __weak typeof(self) weakSelf = self;
    [self.network loadMoreWithComplete:^(BOOL noMore) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
        if (noMore) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        weakSelf.footerLoading = NO;
    } fail:^(NSString *error) {
        [ZYSVPManager showText:@"Load Failed" autoClose:2];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.footerLoading = NO;
    }];
}

#pragma mark - Events

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh{
    if (_loadingStep > 0 || _footerLoading) {
        return;
    }
    _loadingStep = 2;
    [self loadPersonalPage];
    [self loadCandyCells];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return IS_IPX? 272 : 228;
    }else if (indexPath.section == 1){
        return Screen_Width == 414?110:100;
    }else if (indexPath.section == 2){
        if (_state == CandyLoadStateFail || _state == CandyLoadStateNoData) {
            return 270;
        }else{
            return 0.01;
        }
    }
    return 370;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 3) {
        return 0.01;
    }
    return 12.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSUInteger number = 3 + self.network.models.count;
    return number;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3 + self.network.models.count - 1 && section != 2) {
        return 40;
    }else{
        return 0.01;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PersonalCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"PersonalCell" forIndexPath:indexPath];
        [cell configWithDic:self.personalNetwork.personal isSelf:_isSelf];
        return cell;
    }else if(indexPath.section == 1){
        PhotoCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
        if(self.personalNetwork.loadComplete){
            [cell setImagesWithImageModels:self.personalNetwork.photos];
        }
        return cell;
    }else if(indexPath.section == 2){
        StateCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"StateCell" forIndexPath:indexPath];
        if (_state == CandyLoadStateFail) {
            [cell isConnectionLost:YES];
        }else if (_state == CandyLoadStateNoData){
            [cell isNodata:YES];
        }
        return cell;
    }else if (indexPath.section > 2){
        NSUInteger index = indexPath.section - 3;
        CandyCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"CandyCell" forIndexPath:indexPath];
        CandyModel *model = _network.models[index];
        [cell configCellWithModel:model];
        return cell;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_marginTop != scrollView.contentInset.top) {
        _marginTop = scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    if (newoffsetY >= 0 && newoffsetY <= 150) {
        _topView.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:159.0/255.0 blue:236.0/255.0 alpha:newoffsetY/150];
        _name.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:newoffsetY/150];
    }else if (newoffsetY > 150){
        _topView.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:159.0/255.0 blue:236.0/255.0 alpha:1];
        _name.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }else{
        _topView.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:159.0/255.0 blue:236.0/255.0 alpha:0];
        _name.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    }
}

#pragma mark - getter &setter
- (CandyNetworking *)network{
    if (!_network) {
        _network = [[CandyNetworking alloc]initWithNetWorkingType:CandyNetworkingUserType];
    }
    return _network;
}

- (PersonalPageNetwork *)personalNetwork{
    if (!_personalNetwork) {
        _personalNetwork = [PersonalPageNetwork new];
    }
    return _personalNetwork;
}

- (void)setLoadingStep:(NSUInteger)loadingStep{
    _loadingStep = loadingStep;
    if (_loadingStep == 0) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}
@end
