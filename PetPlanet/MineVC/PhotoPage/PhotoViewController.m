//
//  PhotoViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/14.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "PhotoViewController.h"
#import "HintView.h"
#import "PhotoCell.h"
#import "PhotoViewCell.h"
#import "Common.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <NSObject+YYModel.h>
#import "ZYSVPManager.h"

@interface PhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet HintView *hintView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic,strong)  NSMutableArray<PhotoModel *> *model;
@property (nonatomic,assign) BOOL networking;

@property (nonatomic,strong) NSString *uid;
@end

@implementation PhotoViewController

- (instancetype)initWithUid:(NSString *)uid{
    if (self =[super init]) {
        self.uid = uid;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"My Album";
    
    [self configCollectionView];
    [self reload];
}

- (void)configCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.estimatedItemSize = CGSizeMake(150, 200);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view insertSubview:_collectionView atIndex:0];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoViewCell"];
    [self configHeaderAndFooter];
}

- (void)configHeaderAndFooter{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"UFO_0"];
    [header setImages:@[image] forState:MJRefreshStatePulling];
    [header setImages:[Common getUFOImage] forState:MJRefreshStateRefreshing];
    _collectionView.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.stateLabel.hidden = YES;
    _collectionView.mj_footer = footer;
}

#pragma mark - Network

- (void)reload{
    if (_networking) {
        [_collectionView.mj_header endRefreshing];
        return;
    }
    _networking = YES;
    NSString *url = @"http://106.14.174.39/pet/mine/get_photos.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *param = @{@"uid":_uid};
    
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [weakSelf loadFail];
        }else{
            NSString *error = responseObject[@"error"];
            if (![error isEqualToString:@"10"]) {
                [weakSelf loadFail];
            }else{
                NSArray *arr = responseObject[@"items"];
                [weakSelf.collectionView.mj_footer resetNoMoreData];
                if (arr.count<10) {
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
                [weakSelf.model setArray:[weakSelf parserData:arr]];
                [weakSelf.collectionView reloadData];
            }
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        weakSelf.networking = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf loadFail];
        [weakSelf.collectionView.mj_header endRefreshing];
        weakSelf.networking = NO;
    }];
}

- (void)loadMore{
    if (_networking) {
        [_collectionView.mj_header endRefreshing];
        return;
    }
    _networking = YES;
    NSString *url = @"http://106.14.174.39/pet/mine/get_more_photos.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    PhotoModel *model = _model.lastObject;
    NSDictionary *param = @{@"uid":_uid,
                            @"last":model.pid,};
    
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [ZYSVPManager showText:@"Load Failed" autoClose:1.5];
        }else{
            NSString *error = responseObject[@"error"];
            if (![error isEqualToString:@"10"]) {
                [ZYSVPManager showText:@"Load Failed" autoClose:1.5];
            }else{
                NSArray *arr = responseObject[@"items"];
                if (arr.count<10) {
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
                [weakSelf.model addObjectsFromArray:[weakSelf parserData:arr]];
                [weakSelf.collectionView reloadData];
            }
        }
        weakSelf.networking = NO;
        [weakSelf.collectionView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Load Failed" autoClose:1.5];
        weakSelf.networking = NO;
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

- (NSArray *)parserData:(NSArray *)item{
    NSMutableArray *mutableArr = [NSMutableArray new];
    [item enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        PhotoModel *model = [PhotoModel yy_modelWithJSON:dic];
        [mutableArr addObject:model];
    }];
    
    return mutableArr.copy;
}

- (void)loadFail{
    [ZYSVPManager showText:@"Load Failed" autoClose:1.5];
    _hintView.hidden = NO;
    [_hintView setType:HintNoConnectType needButton:YES];
    __weak typeof(self) weakSelf = self;
    _hintView.refresh = ^{
        [weakSelf reload];
    };
}
#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoViewCell" forIndexPath:indexPath];
    PhotoModel *model = _model[indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

#pragma mark - getter & setter

- (NSMutableArray<PhotoModel *> *)model{
    if(!_model){
        _model = [NSMutableArray new];
    }
    return _model;
}
@end
