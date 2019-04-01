//
//  CandyNetworking.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CandyNetworking.h"
#import <AFNetworking.h>
#import "Common.h"
#import "ZYUserManager.h"

@implementation CandyModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    _timeInterval = [Common getDateStringWithTimeString:dic[@"time"]];
    return YES;
}

@end



@interface CandyNetworking ()

@property (nonatomic,assign) CandyNetworkingType networkingType;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,assign) BOOL networking;

@end

@implementation CandyNetworking

- (instancetype)initWithNetWorkingType:(CandyNetworkingType)type{
    if (self = [super init]) {
        self.networkingType = type;
    }
    return self;
}

- (void)reloadModelsWithComplete:(Complete)complete fail:(Fail)fail{
    [self reloadWithUid:nil Complete:complete fail:fail];
}

- (void)reloadPersonalWithUid:(NSString *)uid Complete:(Complete)complete fail:(Fail)fail{
    [self reloadWithUid:uid Complete:complete fail:fail];
}

- (void)reloadWithUid:(NSString *)uid Complete:(Complete)complete fail:(Fail)fail{

    if (_networking) {
        fail(@"16");
    }
    _networking = YES;
    
    NSString *url = @"http://106.14.174.39/pet/candy/get_candy_list.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (_networkingType == CandyNetworkingFollowingType) {
        [param setObject:@"0" forKey:@"type"];
        [param setObject:[ZYUserManager shareInstance].UserID forKey:@"uid"];
    }else if(_networkingType == CandyNetworkingRecommendType){
        [param setObject:@"1" forKey:@"type"];
    }else if (_networkingType == CandyNetworkingNewsType){
        [param setObject:@"2" forKey:@"type"];
    }else if (_networkingType == CandyNetworkingUserType){
        [param setObject:@"3" forKey:@"type"];
        [param setObject:uid forKey:@"uid"];
    }
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if (![dic isKindOfClass:[NSDictionary class]]) {
            weakSelf.networking = NO;
            fail(@"13");
            return;
        }

        NSString *error = dic[@"error"];
        if(![error isEqualToString:@"10"]){
            weakSelf.networking = NO;
            fail(error);
            return;
        }
        
        NSArray *models = [weakSelf paserData:dic[@"items"]];
        if (models.count > 0) {
            [weakSelf.array setArray:models];
        }
        weakSelf.networking = NO;
        complete();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.networking = NO;
        fail(@"14");
    }];
}

- (void)loadMoreWithComplete:(LoadComplete)complete fail:(Fail)fail{
    [self loadMoreWithUid:nil Complete:complete fail:fail];
}

- (void)loadMorePersonalWithUid:(NSString *)uid WithComplete:(LoadComplete)complete fail:(Fail)fail{
    [self loadMoreWithUid:uid Complete:complete fail:fail];
    
}

- (void)loadMoreWithUid:(NSString *)uid Complete:(LoadComplete)complete fail:(Fail)fail{
    if (_networking) {
        fail(@"16");
    }
    _networking = YES;
    NSString *url = @"http://106.14.174.39/pet/candy/more_candy_list.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    CandyModel *model = self.array.lastObject;
    if (_networkingType == CandyNetworkingFollowingType) {
        [param setObject:@"0" forKey:@"type"];
        [param setObject:[ZYUserManager shareInstance].UserID forKey:@"uid"];
        if (model) {
            [param setObject:model.time forKey:@"time"];
        }
    }else if(_networkingType == CandyNetworkingRecommendType){
        [param setObject:@"1" forKey:@"type"];
        if (model) {
            [param setObject:model.hot forKey:@"hot"];
        }
    }else if (_networkingType == CandyNetworkingNewsType){
        [param setObject:@"2" forKey:@"type"];
        if (model) {
            [param setObject:model.time forKey:@"time"];
        }
    }else if (_networkingType == CandyNetworkingUserType) {
        [param setObject:@"3" forKey:@"type"];
        [param setObject:uid forKey:@"uid"];
        if (model) {
            [param setObject:model.time forKey:@"time"];
        }
    }
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            weakSelf.networking = NO;
            fail(@"13");
            return;
        }
        
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        if(![error isEqualToString:@"10"]){
            weakSelf.networking = NO;
            fail(error);
            return;
        }
        
        NSArray *models = [weakSelf paserData:dic[@"items"]];
        if (models.count > 0) {
            [weakSelf.array addObjectsFromArray:models];
        }
        BOOL flag = models.count<20;
        weakSelf.networking = NO;
        complete(flag);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.networking = NO;
        fail(@"14");
    }];
}

- (NSArray<CandyModel *> *)paserData:(NSArray *)data{
    NSMutableArray *arr = [NSMutableArray new];
    for (NSDictionary *dic in data) {
        CandyModel *model = [CandyModel yy_modelWithJSON:dic];
        [arr addObject:model];
    }
    return arr.copy;
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray new];
    }
    return _array;
}

- (NSArray *)models{
    return self.array;
}
@end
