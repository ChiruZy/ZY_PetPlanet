//
//  SearchViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "SearchViewController.h"
#import "HistoryDelegate.h"
#import "HotDelegate.h"
#import "JXCategoryView.h"
#import "CandyCell.h"
#import "SearchViewNetwork.h"
#import "UserTableViewCell.h"
#import "PersonalViewController.h"
#import "SearchUserViewController.h"
#import <MJRefresh.h>
#import "ZYSVPManager.h"
#import "CandyDetailController.h"
#import "CandyDetailNetwork.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CandyCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UICollectionView *history;
@property (weak, nonatomic) IBOutlet UICollectionView *hot;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) HistoryDelegate *historyDelegate;
@property (nonatomic,strong) HotDelegate *hotDelegate;
@property (nonatomic,strong) SearchViewNetwork *network;
@property (nonatomic,strong) CandyDetailNetwork *detailNetwork;
@property (nonatomic,assign) BOOL liking;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchField.delegate = self;
    [_cancel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UITapGestureRecognizer *tapSelf = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf)];
//    [self.view addGestureRecognizer:tapSelf];
    [self configHistory];
    [self configWithTableView];
}

#pragma mark - UIConfig
- (void)configHistory{
     __weak typeof(self) weakSelf = self;
    
    _historyDelegate = [[HistoryDelegate alloc]initWithNeedRefreshBlock:^(BOOL flag) {
        weakSelf.historyView.hidden = !flag;
        [weakSelf.history reloadData];
    }];
    _historyDelegate.block = ^(NSString * _Nullable content) {
        weakSelf.searchField.text = content;
        [weakSelf requestWithString:content];
    };
    _history.delegate = _historyDelegate;
    _history.dataSource = _historyDelegate;
    [_history registerNib:[UINib nibWithNibName:@"HistoryCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryCell"];
    
    _hotDelegate = [HotDelegate new];
    _hotDelegate.block = ^(NSString * _Nullable content) {
        weakSelf.searchField.text = content;
        weakSelf.historyView.hidden = NO;
        [weakSelf requestWithString:content];
    };
    _hotDelegate.getDataComplete = ^{
        weakSelf.hotView.hidden = NO;
    };
    _hot.delegate = _hotDelegate;
    _hot.dataSource = _hotDelegate;
    [_hot registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellWithReuseIdentifier:@"HotCell"];
}

- (void)configWithTableView{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CandyCell" bundle:nil] forCellReuseIdentifier:@"CandyCell"];
    [self configHeaderAndFooter];
}

- (void)configHeaderAndFooter{
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.mj_footer = footer;
}
#pragma mark - Events
- (void)back{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)clearHistory:(id)sender {
    [_historyDelegate removeHistory];
}


- (void)tapSelf{
    [_searchField resignFirstResponder];
}

#pragma mark - PrivateMethod
- (void)requestWithString:(NSString *)str{
    __weak typeof(self) weakSelf = self;
    self.hiddenView.hidden = NO;
    [self.network searchWithKeyword:str complete:^{
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer resetNoMoreData];
    } fail:^(NSString * _Nonnull error) {
        [ZYSVPManager showText:@"Connect Failed" autoClose:2];
    }];
}

- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    [_network searchMoreWithKeyword:_searchField.text complete:^(BOOL noMore){
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (noMore) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } fail:^(NSString * _Nonnull error) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.network.models.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0.01;
    }
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.network.users.count>0?100:0.01;
    }else{
        return 370;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell" forIndexPath:indexPath];
        [cell configWithUserModels:_network.users];
        __weak typeof(self) weakSelf = self;
        cell.block = ^(UsersModel * _Nonnull model) {
            if (!model) {
                NSString *keyword = weakSelf.searchField.text;
                SearchUserViewController *searchUserVC = [[SearchUserViewController alloc]initWithKeyword:keyword];
                [weakSelf.navigationController pushViewController:searchUserVC animated:YES];
                return;
            }
            PersonalViewController *personalVC = [[PersonalViewController alloc]initWithUserID:model.uid];
            [weakSelf.navigationController pushViewController:personalVC animated:YES];
        };
        return cell;
    }else{
        NSUInteger index = indexPath.section -1;
        CandyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandyCell" forIndexPath:indexPath];
        [cell configCellWithModel:_network.models[index]];
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_historyDelegate setObjectToHistory:_searchField.text];
    CandyModel *model = _network.models[indexPath.section-1];
    CandyDetailController *detailVC = [[CandyDetailController alloc]initWithCandyModel:model];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - CandyDelegate

- (void)cellDidTapReplyWithModel:(CandyModel *)model{
    [_historyDelegate setObjectToHistory:_searchField.text];
    CandyDetailController *detailVC = [[CandyDetailController alloc]initWithCandyModel:model];
    [detailVC edit];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)cellDidTapHeadOrNameWithModel:(CandyModel *)model{
    [_historyDelegate setObjectToHistory:_searchField.text];
    PersonalViewController *personalVC = [[PersonalViewController alloc]initWithUserID:model.authorID];
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)cellDidTapLikeWithModel:(CandyModel *)model isLike:(BOOL)isLike complete:(nonnull LikeComplete)block{
    [_historyDelegate setObjectToHistory:_searchField.text];
    if (![ZYUserManager shareInstance].isLogin) {
        [ZYSVPManager showText:@"Please Login" autoClose:1.5];
    }
    if (_liking) {
        return;
    }
    _liking = YES;
    __weak typeof(self) weakSelf = self;
    [self.detailNetwork likeWithCid:model.candyID isLike:isLike complete:^{
        block();
        weakSelf.liking = NO;
    } fail:^(NSString * _Nonnull error) {
        weakSelf.liking = NO;
        [ZYSVPManager showText:@"Like Failed" autoClose:1.5];
    }];
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *newStr = [NSMutableString stringWithString:textField.text];
    [newStr replaceCharactersInRange:range withString:string];

    _hiddenView.hidden = (newStr.length == 0);
    
    if (newStr.length>20) {
        return NO;
    }
    if (newStr.length == 0) {
        [_network removeRecord];
        [self.tableView reloadData];
        return YES;
    }
    [self requestWithString:newStr];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [_network removeRecord];
    _hiddenView.hidden = YES;
    [self.tableView reloadData];
    ;    return YES;
}
#pragma mark - Getter & Setter

- (SearchViewNetwork *)network{
    if (!_network) {
        _network = [SearchViewNetwork new];
    }
    return _network;
}

- (CandyDetailNetwork *)detailNetwork{
    if (!_detailNetwork) {
        _detailNetwork = [[CandyDetailNetwork alloc]init];
    }
    return _detailNetwork;
}
@end
