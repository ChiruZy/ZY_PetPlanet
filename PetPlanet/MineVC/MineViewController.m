//
//  MineViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/26.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "ZYPopView.h"
#import "ChangeCoverView.h"
#import "LoginViewController.h"
#import "InterractiveViewController.h"
#import "PersonalViewController.h"
#import <AFNetworking.h>
#import "ZYSVPManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SettingPage/SettingViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *mineBG;
@property (weak, nonatomic) IBOutlet UIButton *image;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self judgeLogin];
}

- (void)judgeLogin{
    [self removeAllTarget];
    if ([ZYUserManager shareInstance].isLogin) {
        UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCover)];
        [_mineBG addGestureRecognizer:tapCover];
        
        [_name addTarget:self action:@selector(gotoPersonal) forControlEvents:UIControlEventTouchDown];
        [_image addTarget:self action:@selector(gotoPersonal) forControlEvents:UIControlEventTouchDown];
        [self getPersonal];
    }else{
        _mineBG.image = nil;
        [_name setTitle:@"Login" forState:UIControlStateNormal];
        [_image setImage:nil forState:UIControlStateNormal];
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUser)];
        [_image addGestureRecognizer:tapImage];
        [_name addTarget:self action:@selector(tapUser) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)getPersonal{
    ZYUserManager *manager = [ZYUserManager shareInstance];
    [_name setTitle:manager.name forState:UIControlStateNormal];
    if (manager.cover.length) {
        [_mineBG sd_setImageWithURL:[NSURL URLWithString: manager.cover]];
    }else{
        [_mineBG setImage:nil];
    }
    __weak typeof(self) weakSelf = self;
    if (manager.head.length) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:manager.head] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [weakSelf.image setImage:image forState:UIControlStateNormal];
        }];
    };
}


- (void)removeAllTarget{
    __weak typeof(self) weakSelf = self;
    [_mineBG.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.mineBG removeGestureRecognizer:obj];
    }];
    [_image removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [_name removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
}

#pragma mark - TapEvent

- (void)gotoPersonal{
    PersonalViewController *personalVC = [[PersonalViewController alloc]initWithUserID:[ZYUserManager shareInstance].userID];
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)tapUser{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithLoginBlock:^(NSString * _Nonnull uid) {
        
    }];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)changeCover{
    ChangeCoverView *coverView = [[[NSBundle mainBundle] loadNibNamed:@"ChangeCoverView" owner:nil options:nil]firstObject];
    ZYPopView *pop = [[ZYPopView alloc]initWithContentView:coverView type:ZYPopViewBlurType];
    [pop show];
}

#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (Screen_Height == 667) {
        return 16;
    }
    if (section == 0) {
        return 30;
    }
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
    NSArray *imageNameArr = @[@"personal",@"like",@"collections",@"history",@"cache",@"setting"];
    NSArray *titleArr =@[@"Personal Page",@"My Favorite",@"Collections",@"History",@"Clear Cache",@"Setting"];
    [cell configCellWithImage:[UIImage imageNamed:imageNameArr[indexPath.section]] title:titleArr[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (![ZYUserManager shareInstance].isLogin) {
            [self tapUser];
            return;
        }
        PersonalViewController *personalVC = [[PersonalViewController alloc]initWithUserID:[ZYUserManager shareInstance].userID];
        [self.navigationController pushViewController:personalVC animated:YES];
    }else if (indexPath.section == 1) {
        InterractiveViewController *favoriteVC = [[InterractiveViewController alloc]initWithInterractiveType:InterractiveVCLikeType];
        [self.navigationController pushViewController:favoriteVC animated:YES];
    }else if (indexPath.section == 2) {
        InterractiveViewController *collectionsVC = [[InterractiveViewController alloc]initWithInterractiveType:InterractiveVCCollectionType];
        [self.navigationController pushViewController:collectionsVC animated:YES];
    }else if (indexPath.section == 4) {
        [[SDWebImageManager sharedManager].imageCache clearMemory];
        [ZYSVPManager showText:@"Success" autoClose:1.5];
    }else if (indexPath.section == 5) {
        [self.navigationController pushViewController:[SettingViewController new] animated:YES] ;
        
    }
    
}

@end
