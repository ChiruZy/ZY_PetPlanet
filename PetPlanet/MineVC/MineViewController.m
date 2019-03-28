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


@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *mineBG;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
}

- (void)configSubviews{
    _mineBG.image = [Common imageWithColor:HEXCOLOR(0xA19FEC)];
    UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCover)];
    _mineBG.userInteractionEnabled = YES;
    [_mineBG addGestureRecognizer:tapCover];
    
    _photo.image = [Common imageWithColor:HEXCOLOR(0xD7FEF1)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
}

- (void)changeCover{
    ChangeCoverView *coverView = [[[NSBundle mainBundle] loadNibNamed:@"ChangeCoverView" owner:nil options:nil]firstObject];
    ZYPopView *pop = [[ZYPopView alloc]initWithContentView:coverView];
    [pop show];
}


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
