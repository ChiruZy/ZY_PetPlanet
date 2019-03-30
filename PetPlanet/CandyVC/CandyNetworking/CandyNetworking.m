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

@implementation CandyModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    _time = [Common getDateStringWithTimeString:_time];
    return YES;
}

@end



@interface CandyNetworking ()

@property (nonatomic,assign) CandyNetworkingType networkingType;
@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation CandyNetworking

- (instancetype)initWithNetWorkingType:(CandyNetworkingType)type{
    if (self = [super init]) {
        self.networkingType = type;
    }
    return self;
}


- (void)reloadModelsWithComplete:(Complete)complete fail:(Fail)fail{
    NSString *url = @"http://106.14.174.39/pet/candy/get_candy_list.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (_networkingType == CandyNetworkingFollowingType) {
        [param setObject:@"0" forKey:@"type"];
        [param setObject:UID forKey:@"user_id"];
    }else if(_networkingType == CandyNetworkingRecommendType){
        [param setObject:@"1" forKey:@"type"];
    }else if (_networkingType == CandyNetworkingNewsType){
        [param setObject:@"2" forKey:@"type"];
    }
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isMemberOfClass:[NSDictionary class]]) {
            fail(@"13");
            return;
        }
        
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        if(![error isEqualToString:@"10"]){
            fail(error);
            return;
        }
        
        NSArray *models = [weakSelf paserData:dic[@"items"]];
        if (models.count > 0) {
            [weakSelf.array setArray:models];
        }
        complete();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"14");
    }];
}

- (void)loadMoreWithComplete:(LoadComplete)complete fail:(Fail)fail{
    NSString *url = @"http://106.14.174.39/pet/candy/more_candy_list.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSDictionary *dic = self.array.lastObject;
    if (_networkingType == CandyNetworkingFollowingType) {
        [param setObject:@"0" forKey:@"type"];
        [param setObject:UID forKey:@"user_id"];
        if (dic) {
            [param setObject:dic[@"time"] forKey:@"time"];
        }
    }else if(_networkingType == CandyNetworkingRecommendType){
        [param setObject:@"1" forKey:@"type"];
        
    }else if (_networkingType == CandyNetworkingNewsType){
        [param setObject:@"2" forKey:@"type"];
        if (dic) {
            [param setObject:dic[@"time"] forKey:@"time"];
        }
    }
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isMemberOfClass:[NSDictionary class]]) {
            fail(@"13");
            return;
        }
        
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        if(![error isEqualToString:@"10"]){
            fail(error);
            return;
        }
        
        NSArray *models = [weakSelf paserData:dic[@"items"]];
        if (models.count > 0) {
            [weakSelf.array addObjectsFromArray:models];
        }
        BOOL flag = models.count<20;
        complete(flag);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
