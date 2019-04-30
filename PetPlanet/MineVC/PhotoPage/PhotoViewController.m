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
#import "PhotoLayout.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <NSObject+YYModel.h>
#import "ZYSVPManager.h"
#import <UIImageView+WebCache.h>
#import "ChooseView.h"
#import "ZYPopView.h"
#import "ZYBaseViewController+ImagePicker.h"

@interface PhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet HintView *hintView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic,strong)  NSMutableArray<PhotoModel *> *model;
@property (nonatomic,assign) BOOL networking;
@property (nonatomic,strong) PhotoLayout *layout;

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
    
    if ([_uid isEqualToString: [ZYUserManager shareInstance].userID]) {
        UIBarButtonItem *publish = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addPhoto)];
        UIBarButtonItem *fix = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        self.navigationItem.rightBarButtonItems = @[fix,publish];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = @[backItem];
    }
    
    [self configCollectionView];
    [self reload];
}

- (void)addPhoto{
    __weak typeof(self) weakSelf = self;
    [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, NSData * _Nonnull originData, UIImage * _Nonnull image) {
        
        NSString *ratio = [NSString stringWithFormat:@"%.03f",image.size.height/image.size.width];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 8;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
        NSString *url = @"http://106.14.174.39/pet/mine/add_photo.php";
        
        [manager POST:url parameters:@{@"uid":weakSelf.uid,@"ratio":ratio} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"uploadImage" mimeType:@"image/jpeg"];
            [formData appendPartWithFileData:originData name:@"originImage" fileName:@"uploadImage" mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *error = responseObject[@"error"];
                if ([error isEqualToString:@"10"]) {
                    [weakSelf reload];
                    return;
                }
            }
            [ZYSVPManager showText:@"Upload Failed" autoClose:1.5];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ZYSVPManager showText:@"Upload Failed" autoClose:1.5];
        }];
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configCollectionView{
    __weak typeof(self) weakSelf = self;
    _layout = [[PhotoLayout alloc]initWithHeightBlock:^CGFloat(NSIndexPath * _Nonnull indexPath) {
        if(indexPath.row>weakSelf.model.count-1 || weakSelf.model.count == 0){
            return 0;
        }
        PhotoModel *model = weakSelf.model[indexPath.row];
        CGFloat width = (Screen_Width - (colCount + 1) * colMargin) / colCount;
        return width * model.ratio.floatValue;
    }];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= topMargin;
    _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
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
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
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
    manager.requestSerializer.timeoutInterval = 8;
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
    manager.requestSerializer.timeoutInterval = 8;
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

- (void)deleteWithPid:(NSString *)pid{
    NSString *url = @"http://106.14.174.39/pet/mine/delete_photos.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    [manager GET:url parameters:@{@"pid":pid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [ZYSVPManager showText:@"Delete Failed" autoClose:1.5];
        }else{
            NSString *error = responseObject[@"error"];
            if (![error isEqualToString:@"10"]) {
                [ZYSVPManager showText:@"Load Failed" autoClose:1.5];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Delete Failed" autoClose:1.5];
    }];
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoViewCell" forIndexPath:indexPath];
    PhotoModel *model = _model[indexPath.row];
    [cell configWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.block = ^(PhotoModel * _Nonnull model) {
        ChooseView *chooseView = [[[NSBundle mainBundle] loadNibNamed:@"ChooseView" owner:nil options:nil]firstObject];
        ZYPopView *popView = [[ZYPopView alloc]initWithContentView:chooseView type:ZYPopViewBlurType];
        chooseView.yesEvent = ^{
            
            [weakSelf.collectionView performBatchUpdates:^{
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[weakSelf.model indexOfObject:model] inSection:0] ;
                [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
                [weakSelf.model removeObject:model];
            } completion:^(BOOL finished) {
                [weakSelf deleteWithPid:model.pid];
            }];
            [popView dismiss];
        };
        chooseView.cancelEvent = ^{
            [popView dismiss];
        };
        [popView show];
    };
    
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
