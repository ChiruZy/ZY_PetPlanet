//
//  InterractiveNetworking.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "InterractiveNetworking.h"
#import <AFNetworking.h>
#import "Common.h"
#import "ZYUserManager.h"

@implementation InterractiveModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    [super modelCustomTransformFromDictionary:dic];
    _interractiveTimeInterval = [Common getDateStringWithTimeString:dic[@"interractiveTime"]];
    return YES;
}

@end

@interface InterractiveNetworking ()

@property (nonatomic,assign) InterractiveType type;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,assign) BOOL networking;

@end

@implementation InterractiveNetworking

- (instancetype)initWithNetWorkingType:(InterractiveType)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}


- (void)reloadModelsWithComplete:(Complete)complete fail:(Fail)fail{
    if (_networking) {
        fail(@"16");
    }
    _networking = YES;
    
    NSString *url = @"http://106.14.174.39/pet/mine/get_interractive_list.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (_type == InterractiveLikeType) {
        [param setObject:@"1" forKey:@"type"];
    }else {
        [param setObject:@"2" forKey:@"type"];
    }
    [param setObject:[ZYUserManager shareInstance].userID forKey:@"uid"];
    
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
            [weakSelf.array setArray:models];
        }
        weakSelf.networking = NO;
        complete();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.networking = NO;
        fail(@"14");
    }];
}

- (NSArray<InterractiveModel *> *)paserData:(NSArray *)data{
    NSMutableArray *arr = [NSMutableArray new];
    for (NSDictionary *dic in data) {
        InterractiveModel *model = [InterractiveModel yy_modelWithJSON:dic];
        [arr addObject:model];
    }
    return arr.copy;
}

- (void)loadMoreWithComplete:(LoadComplete)complete fail:(Fail)fail{
    if (_networking) {
        fail(@"16");
    }
    _networking = YES;
    NSString *url = @"http://106.14.174.39/pet/mine/more_interractive_list.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    InterractiveModel *model = self.array.lastObject;
    
    if (_type == InterractiveLikeType) {
        [param setObject:@"1" forKey:@"type"];
    }else {
        [param setObject:@"2" forKey:@"type"];
    }
    [param setObject:[ZYUserManager shareInstance].userID forKey:@"uid"];
    if (model) {
        [param setObject:model.interractiveTime forKey:@"interractiveTime"];
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
