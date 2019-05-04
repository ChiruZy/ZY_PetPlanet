//
//  CandyDetailNetwork.m
//  PetPlanet
//
//  Created by Overloop on 2019/5/2.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CandyDetailNetwork.h"
#import "ZYUserManager.h"
#import <AFNetworking.h>
#import <YYModel.h>

@interface CandyDetailNetwork()

@property (nonatomic,assign) BOOL networking;
@property (nonatomic,strong) CandyDetailModel *cdModel;
@property (nonatomic,strong) NSMutableArray *replyModel;

@end

@implementation CandyDetailNetwork

- (void)likeWithCid:(NSString *)cid isLike:(BOOL)isLike complete:(Complete)complete fail:(Fail)fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    NSString *url = @"http://106.14.174.39/pet/candy/like_candy.php";
    [manager GET:url parameters:@{@"cid":cid,
                                  @"uid":[ZYUserManager shareInstance].userID,
                                  @"isLike":isLike?@"1":@"0"
                                  } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                complete();
            }else{
                fail(error);
            }
        }else{
            fail(@"13");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"14");
    }];
}

- (void)collectionWithCid:(NSString *)cid isCollection:(BOOL)isCollection complete:(Complete)complete fail:(Fail)fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    NSString *url = @"http://106.14.174.39/pet/candy/collection_candy.php";
    [manager GET:url parameters:@{@"cid":cid,
                                  @"uid":[ZYUserManager shareInstance].userID,
                                  @"isCollection":isCollection?@"1":@"0"
                                  } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                          NSString *error = responseObject[@"error"];
                                          if ([error isEqualToString:@"10"]) {
                                              complete();
                                          }else{
                                              fail(error);
                                          }
                                      }else{
                                          fail(@"13");
                                      }
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      fail(@"14");
                                  }];
}


- (void)deleteCandyWithCid:(NSString *)cid complete:(Complete)complete fail:(Fail)fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    NSString *url = @"http://106.14.174.39/pet/candy/delete_candy.php";
    [manager GET:url parameters:@{@"cid":cid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                complete();
            }else{
                fail(error);
            }
        }else{
            fail(@"13");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"14");
    }];
}

- (void)replyWithContent:(NSString *)content cid:(NSString *)cid complete:(Complete)complete fail:(Fail)fail{
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *url = @"http://106.14.174.39/pet/candy/add_reply.php";
    [manager POST:url parameters:@{@"cid":cid,@"uid":[ZYUserManager shareInstance].userID} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:contentData name:@"content"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                complete();
            }else{
                fail(error);
            }
        }else{
            fail(@"13");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"14");
    }];
}

- (void)reloadDataWithAid:(NSString *)cid complete:(Complete)complete fail:(Fail)fail{
    if (_networking) {
        fail(@"16");
        return;
    }
    _networking = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    
    NSString *url = @"http://106.14.174.39/pet/candy/get_candy_detail.php";
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:@{@"cid":cid,@"uid":[ZYUserManager shareInstance].userID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            fail(@"13");
        }else{
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                [weakSelf parserReloadData:responseObject[@"items"]];
                complete();
            }else{
                fail(error);
            }
        }
        weakSelf.networking = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"14");
        weakSelf.networking = NO;
    }];
}

- (void)moreReplyWithAid:(NSString *)cid complete:(LoadComplete)complete fail:(Fail)fail{
    if (_networking) {
        fail(@"16");
        return;
    }
    _networking = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    
    NSString *url = @"http://106.14.174.39/pet/candy/get_more_reply.php";
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:cid forKey:@"cid"];
    [param setObject:[ZYUserManager shareInstance].userID forKey:@"uid"];
    if (_replyModel.count >0) {
        CandyReplyModel *model = [_replyModel lastObject];
        [param setObject:model.rid forKey:@"last"];
    }
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            fail(@"13");
        }else{
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                NSArray *arr = [weakSelf parserReplyWithData:responseObject[@"items"]];
                [weakSelf.replyModel addObjectsFromArray:arr];
                complete(arr.count<10);
            }else{
                fail(error);
            }
        }
        weakSelf.networking = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(@"14");
        weakSelf.networking = NO;
    }];
}

- (NSArray *)parserReplyWithData:(NSArray *)data{
    NSMutableArray *arr = [NSMutableArray new];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CandyReplyModel *model = [CandyReplyModel yy_modelWithJSON:obj];
        [arr addObject:model];
    }];
    return arr.copy;
}

- (void)parserReloadData:(NSDictionary *)data{
    _cdModel = [CandyDetailModel yy_modelWithJSON:data[@"detail"]];
    NSArray *reply = data[@"replys"];
    NSMutableArray *arr = [NSMutableArray new];
    [reply enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CandyReplyModel *model = [CandyReplyModel yy_modelWithJSON:obj];
        [arr addObject:model];
    }];
    [self.replyModel setArray:arr];
}

- (CandyDetailModel *)detailModel{
    return _cdModel;
}

- (NSMutableArray *)replyModels{
    return _replyModel.copy;
}

- (NSMutableArray *)replyModel{
    if (!_replyModel) {
        _replyModel = [NSMutableArray new];
    }
    return _replyModel;
}
@end
