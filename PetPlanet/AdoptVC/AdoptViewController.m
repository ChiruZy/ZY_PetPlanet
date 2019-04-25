//
//  AdoptViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "AdoptViewController.h"
#import "CardView.h"
#import "CardItem.h"
#import "CreateAdoptViewController.h"
#import "ZYSVPManager.h"
#import <AFNetworking.h>
#import <YYModel.h>

typedef NS_ENUM(NSUInteger, AdoptPetType) {
    AdoptPetCatType,
    AdoptPetDogType,
    AdoptPetEtcType,
};

@implementation AdoptModel


@end

@interface AdoptViewController ()<CardViewDelegate,CardViewDataSource>
@property (weak, nonatomic) IBOutlet CardView *cardView;
@property (nonatomic,strong) NSMutableArray *models;
@property (nonatomic,assign) AdoptPetType type;
@property (nonatomic,assign) BOOL networking;
@end

@implementation AdoptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = AdoptPetCatType;
    _cardView.delegate = self;
    _cardView.dataSource = self;
    [self loadData];
}

- (void)refreshData{
    [_cardView reloadData];
}

#pragma mark - network
- (void)loadData{
    NSString *url = @"http://106.14.174.39/pet/adopt/get_adopt.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:@{@"type":[NSString stringWithFormat:@"%zd",_type]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                [weakSelf parserData:responseObject[@"items"]];
                [weakSelf refreshData];
                return;
            }
        }
        [ZYSVPManager showText:@"Load Failed" autoClose:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Connect Failed" autoClose:1.5];
    }];
}

- (void)parserData:(NSArray *)arr{
    for (NSDictionary *dic in arr) {
        AdoptModel *model = [AdoptModel yy_modelWithJSON:dic];
        [self.models addObject:model];
    }
}
#pragma mark - event
- (IBAction)changePetType:(UIButton *)sender {
    for (int i = 0; i<3; i++) {
        UIButton *button = [self.view viewWithTag:2000+i];
        
        if (sender == button) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:HEXCOLOR(0x545374)];
            _type = i;
        }else{
            [button setTitleColor:HEXCOLOR(0x545374) forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }
}
- (IBAction)createNewAdopt:(id)sender {
    if ([ZYUserManager shareInstance].isLogin) {
        CreateAdoptViewController *cavc = [CreateAdoptViewController new];
        [self.navigationController pushViewController:cavc animated:YES];
    }else{
        [ZYSVPManager showText:@"Login Please" autoClose:2];
    }
}

- (void)moreData{
    [self loadData];
}

#pragma mark - cardView
- (CardItemView *)cardView:(CardView *)cardView itemViewAtIndex:(NSInteger)index {
    static NSString *reuseIdentitfier = @"card";
    CardItem *itemView = (CardItem *)[cardView dequeueReusableCellWithIdentifier:reuseIdentitfier];
    if (itemView == nil) {
        itemView = [[CardItem alloc] initWithReuseIdentifier:reuseIdentitfier];
    }
    [itemView configWithAdoptModel: _models[index]];
    return itemView;
}

- (NSInteger)numberOfItemViewsInCardView:(CardView *)cardView {
    return _models.count;
}

- (void)cardViewNeedMoreData:(CardView *)cardView {
    [self performSelector:@selector(moreData) withObject:nil afterDelay:2];
}

- (void)cardView:(CardView *)cardView didClickItemAtIndex:(NSInteger)index{
    AdoptModel *model = _models[index];
    
    
}

#pragma mark - getter & setter
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray new];
    }
    return _models;
}

@end
