//
//  MainViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/26.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MainViewController.h"
#import "BannerCell/BannerCell.h"
#import "KolCell/KolCell.h"
#import "AdoptCell/AdoptCell.h"
#import "PopularCell/PopularCell.h"
#import "MainViewNetworking.h"
#import <MJRefresh/MJRefresh.h>

#define SCROLL_SPACE 14

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"PetPlanet";
    [self configTableView];
}

#pragma mark - praviteMethod

- (void)configTableView{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib: [UINib nibWithNibName:@"BannerCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    [_tableView registerNib: [UINib nibWithNibName:@"KolCell" bundle:nil] forCellReuseIdentifier:@"KolCell"];
    [_tableView registerNib: [UINib nibWithNibName:@"AdoptCell" bundle:nil] forCellReuseIdentifier:@"AdoptCell"];
    [_tableView registerNib: [UINib nibWithNibName:@"PopularCell" bundle:nil] forCellReuseIdentifier:@"PopularCell"];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMain)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"UFO_0"];
    [header setImages:@[image] forState:MJRefreshStatePulling];
    [header setImages:[self getUFOImage] forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
}

- (NSArray *)getUFOImage {
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i<50 ; i+=4) {
        NSString *name = [NSString stringWithFormat:@"UFO_%d",i];
        [arr addObject:[UIImage imageNamed:name]];
    }
    return arr;
}

- (void)refreshMain{
    
}
#pragma mark - events
- (void)tapBannerWithIndex:(NSUInteger)index{
    
}

- (void)tapKolWithModel:(KolModel*)model{
    if (!model) {
        return;
    }
    NSUInteger uid = model.userID;
    
    // TODO : 根据id跳转
}

- (void)gotoKolPage{
    // TODO : 跳转到kol页面
}

- (void)gotoMoodPage{
    // TODO : 跳转到mood页面
}

- (void)tapPopularWithModel:(PopularModel*)model{
    if (!model) {
        return;
    }
    NSUInteger mid = model.moodID;
    // TODO : 根据id跳转
}
#pragma mark - tableView dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }else{
        return 14;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 40;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return Screen_Width / 2.15;
    }else if (indexPath.section == 1){
        return 146;
    }else if (indexPath.section == 2){
        return 153;
    }else if (indexPath.section == 3){
        return 132;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 0) {
        BannerCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"BannerCell" forIndexPath:indexPath];
        [MainViewNetworking getBannerWithBlock:^(id responseObject) {
            
        } fail:^{
            
        }];
        
        cell.block = ^(NSUInteger index) {
            [weakSelf tapBannerWithIndex:index];
        };
        return cell;
    }else if (indexPath.section == 1) {
        KolCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"KolCell" forIndexPath:indexPath];
        cell.allBlock = ^{
            [weakSelf gotoKolPage];
        };
        cell.kolBlock = ^(KolModel * _Nonnull model) {
            [weakSelf tapKolWithModel:model];
        };
        return cell;
    }else if (indexPath.section == 2){
        AdoptCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"AdoptCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 3) {
        PopularCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"PopularCell" forIndexPath:indexPath];
        cell.allBlock = ^{
            [weakSelf gotoMoodPage];
        };
        cell.popularBlock = ^(PopularModel * _Nonnull model) {
            [weakSelf tapPopularWithModel:model];
        };
        return cell;
    }
    
    
    return [UITableViewCell new];
}
@end
