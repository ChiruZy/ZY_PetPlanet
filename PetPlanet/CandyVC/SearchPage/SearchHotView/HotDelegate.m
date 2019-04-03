//
//  HotDelegate.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "HotDelegate.h"
#import "HotCell.h"
#import <AFNetworking.h>

@interface HotDelegate ()

@property (nonatomic,strong) NSArray *model;

@end

@implementation HotDelegate

- (instancetype)init{
    if (self = [super init]) {
        [self requestHot];
    }
    return self;
}

- (void)requestHot{
    NSString *url = @"http://106.14.174.39/pet/search/get_hot.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary new];
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [weakSelf requestFailOrNoData];
            return;
        }
        NSString *error = responseObject[@"error"];
        if (![error isEqualToString:@"10"]) {
            [weakSelf requestFailOrNoData];
            return;
        }
        NSArray *arr = responseObject[@"items"];
        if (arr.count == 0 ) {
            [weakSelf requestFailOrNoData];
        }else{
            weakSelf.model = arr.copy;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf requestFailOrNoData];
    }];
}

- (void)requestFailOrNoData{
    if (_noData) {
        _noData();
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCell" forIndexPath:indexPath];
    
    [cell setTitle:_model[indexPath.row]];
    return cell;
}

- (NSArray *)model{
    if (!_model) {
        _model = @"".copy;
    }
    return _model;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCell *cell = (HotCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_block) {
        _block(cell.title);
    }
}
@end
