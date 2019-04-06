//
//  SearchViewNetwork.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "SearchViewNetwork.h"
#import <AFNetworking.h>
#import <NSObject+YYModel.h>

@implementation UsersModel


@end


@interface SearchViewNetwork ()

@property (nonatomic,strong) NSMutableArray *usr;
@property (nonatomic,strong) NSMutableArray *candys;

@end

@implementation SearchViewNetwork

- (void)searchWithKeyword:(NSString *)keyword complete:(nonnull Complete)complete fail:(nonnull Fail)fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"http://106.14.174.39/pet/search/search_candy.php";
    NSDictionary *param = @{@"keyword":keyword};
    
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            fail(@"17");
        }
        
        NSString *error = responseObject[@"error"];
        if (![error isEqualToString:@"10"]) {
            fail(error);
        }
        
        NSArray *user = responseObject[@"user"];
        NSMutableArray *userArr = [NSMutableArray new];
        for (NSDictionary *dic in user) {
            UsersModel *model = [UsersModel yy_modelWithJSON:dic];
            [userArr addObject:model];
        }
        [weakSelf.usr setArray:userArr];
        
        NSArray *candy = responseObject[@"candy"];
        NSMutableArray *candyArr = [NSMutableArray new];
        for (NSDictionary *dic in candy) {
            CandyModel *model = [CandyModel yy_modelWithJSON:dic];
            [candyArr addObject:model];
        }
        [weakSelf.candys setArray:candyArr];
        complete();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"11");
    }];
}

- (void)searchMoreWithKeyword:(NSString *)keyword complete:(nonnull LoadComplete)complete fail:(nonnull Fail)fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"http://106.14.174.39/pet/search/search_more_candy.php";
    CandyModel *model = _candys.lastObject;
    NSDictionary *param = @{@"keyword":keyword,@"last":model.time};
    
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            fail(@"17");
        }
        
        NSString *error = responseObject[@"error"];
        if (![error isEqualToString:@"10"]) {
            fail(error);
        }
        
        NSArray *user = responseObject[@"user"];
        NSMutableArray *userArr = [NSMutableArray new];
        for (NSDictionary *dic in user) {
            UsersModel *model = [UsersModel yy_modelWithJSON:dic];
            [userArr addObject:model];
        }
        [weakSelf.usr setArray:userArr];
        
        NSArray *candy = responseObject[@"candy"];
        NSMutableArray *candyArr = [NSMutableArray new];
        for (NSDictionary *dic in candy) {
            CandyModel *model = [CandyModel yy_modelWithJSON:dic];
            [candyArr addObject:model];
        }
        [weakSelf.candys addObjectsFromArray:candyArr];
        BOOL isNoMore = candyArr.count < 20;
        complete(isNoMore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"11");
    }];
}


- (void)removeRecord{
    _candys = [NSMutableArray new];
    _usr = [NSMutableArray new];
}

- (NSArray<UsersModel *> *)users{
    return _usr.copy;
}

- (NSArray<CandyModel *> *)models{
    return _candys.copy;
}

- (NSMutableArray *)usr{
    if (!_usr) {
        _usr = [NSMutableArray new];
    }
    return _usr;
}

- (NSMutableArray *)candys{
    if (!_candys) {
        _candys = [NSMutableArray new];
    }
    return _candys;
}
@end
