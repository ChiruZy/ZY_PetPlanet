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

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *mineBG;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (IS_LOGIN) {
        
    }else{
        [self configSubviews];
    }
}



- (void)configSubviews{
    UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCover)];
    [_mineBG addGestureRecognizer:tapCover];
    
    UITapGestureRecognizer *tapUser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUser)];
    [_name addGestureRecognizer:tapUser];
    [_photo addGestureRecognizer:tapUser];
}

- (void)tapUser{
    LoginViewController *loginVC = [LoginViewController new];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)changeCover{
    ChangeCoverView *coverView = [[[NSBundle mainBundle] loadNibNamed:@"ChangeCoverView" owner:nil options:nil]firstObject];
    ZYPopView *pop = [[ZYPopView alloc]initWithContentView:coverView];
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
    
}
@end
