//
//  PersonalPageNetwork.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "PersonalPageNetwork.h"
#import <AFNetworking.h>

@interface PersonalPageNetwork()
@property (nonatomic,assign) BOOL networking;
@property (nonatomic,strong) NSArray *photoArr;
@property (nonatomic,strong) NSDictionary *personalDic;
@end

@implementation PersonalPageNetwork

- (void)loadWithUid:(NSString *)uid complete:(Complete)complete fail:(Fail)fail{
    if (_networking) {
        fail(@"16");
    }
    _networking = YES;
    NSString *url = @"http://106.14.174.39/pet/mine/get_mine_list.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSDictionary *param = @{@"uid":uid};
    
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isMemberOfClass:[NSDictionary class]]) {
            weakSelf.networking = NO;
            fail(@"11");
            return;
        }
        
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        if(![error isEqualToString:@"10"]){
            weakSelf.networking = NO;
            fail(error);
            return;
        }
        
        [self parserData:dic[@"items"]];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.networking = NO;
        fail(@"12");
    }];
}

- (void)parserData:(NSDictionary *)data{
    _personalDic = data[@"personal"];
    NSArray *images = data[@"images"];
    NSMutableArray *mutaArr = [NSMutableArray new];
    for (NSDictionary *dic in images) {
        PhotoModel *model = [PhotoModel createWithImage:dic[@"image"] originImage:dic[@"originImage"]];
        [mutaArr addObject:model];
    }
    _photoArr = mutaArr.copy;
    _loadComplete = YES;
}

- (NSDictionary *)personal{
    return _personalDic;
}

- (NSArray<PhotoModel *> *)photos{
    return _photoArr;
}
@end
