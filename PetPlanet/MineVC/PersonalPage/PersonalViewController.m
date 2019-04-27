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
#import "ConversationViewController.h"
#import "PhotoViewController.h"
#import "MyAdoptViewController.h"

typedef NS_ENUM(NSUInteger, CandyLoadState) {
    CandyLoadStateLoading,
    CandyLoadStateComplete,
    CandyLoadStateNoData,
    CandyLoadStateFail,
};

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource,CandyCellDelegate>
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

@end

@implementation PersonalViewController

- (instancetype)initWithUserID:(NSString *)userID{
    if (self = [super init]) {
        _userID = userID;
        if ([_userID isEqualToString:[ZYUserManager shareInstance].userID]) {
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
    _tableView.estimatedRowHeight = 0;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"UFO_0"];
    [header setImages:@[image] forState:MJRefreshStatePulling];
    [header setImages:[Common getUFOImage] forState:MJRefreshStateRefreshing];
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
        NSDictionary *dic = weakSelf.personalNetwork.personal;
        weakSelf.name.text = dic[@"name"];
        [weakSelf.tableView.mj_header endRefreshing];
    } fail:^(NSString * _Nonnull error) {
        if ([error isEqualToString:@"11"]||[error isEqualToString:@"12"]) {
            [ZYSVPManager showText:@"Load Failed" autoClose:2];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadCandyCells{
    __weak typeof(self) weakSelf = self;
    [self.network reloadPersonalWithUid:_userID Complete:^{
        weakSelf.state = CandyLoadStateComplete;
        [weakSelf.tableView reloadData];
    } fail:^(NSString *error) {
        // 已有列表不刷新
        if (weakSelf.network.models.count>0) {
            return;
        }
        // 没有列表显示不同提示
        if ([error isEqualToString:@"13"]||[error isEqualToString:@"14"]) {
            [ZYSVPManager showText:@"Load Failed" autoClose:2];
            weakSelf.state = CandyLoadStateFail;
        }else if ([error isEqualToString:@"15"]){
            weakSelf.state = CandyLoadStateNoData;
        }
        [weakSelf.tableView reloadData];
    }];
}

- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    [self.network loadMorePersonalWithUid:_userID WithComplete:^(BOOL noMore) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
        if (noMore) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } fail:^(NSString *error) {
        if ([error isEqualToString:@"15"]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [ZYSVPManager showText:@"Load Failed" autoClose:2];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Events

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh{
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
            return 280;
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
        __weak typeof(self) weakSelf = self;
        cell.messageBlock = ^{
            [weakSelf gotoConversationView];
        };
        cell.editBlock = ^{
            [weakSelf gotoEditView];
        };
        cell.followBlock = ^NSString * _Nullable{
            return weakSelf.userID;
        };
        cell.adoptBlock = ^{
            MyAdoptViewController *myAdoptVC = [[MyAdoptViewController alloc]initWithUid:weakSelf.userID];
            [weakSelf.navigationController pushViewController:myAdoptVC animated:YES];
        };
        return cell;
    }else if(indexPath.section == 1){
        PhotoCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
        if(self.personalNetwork.loadComplete){
            [cell setImagesWithImageModels:self.personalNetwork.photos];
        }
        __weak typeof(self) weakSelf = self;
        cell.tapBlock = ^{
            PhotoViewController *photoVC = [[PhotoViewController alloc]initWithUid:weakSelf.userID];
            [weakSelf.navigationController pushViewController:photoVC animated:YES];
        };
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
        cell.delegate = self;
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

#pragma mark - PersonalCell Event
- (void)gotoConversationView{
    __weak typeof(self) weakSelf = self;
    __block BOOL flag = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ConversationViewController class]]) {
            ConversationViewController *controller = obj;
            if (controller.targetId == weakSelf.userID) {
                [weakSelf.navigationController popToViewController:obj animated:YES];
                flag = YES;
                *stop = YES;
                return;
            }
        }
    }];
    if (!flag) {
        ConversationViewController *conversationVC = [[ConversationViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:_userID];
        conversationVC.title = _name.text;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

- (void)gotoEditView{
    
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

- (NSString *)uid{
    return _userID;
}

- (void)cellDidTapReplyWithModel:(CandyModel *)model{
    
}

- (void)cellDidTapHeadOrNameWithModel:(CandyModel *)model{
    
}

- (void)cellDidTapLikeWithModel:(CandyModel *)model isLike:(BOOL)isLike{
    
}
@end
