//
//  ZYUserManager.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYUserManager.h"
#import <RongIMKit/RongIMKit.h>
#import "ZYSVPManager.h"
#import <AFNetworking.h>

@interface ZYUserManager ()<RCIMUserInfoDataSource>

@end

static ZYUserManager *manager = nil;

@implementation ZYUserManager

#pragma mark - init
+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:nil] init];
        
        NSDictionary *info = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserInfo"];
        manager.userID = info[@"uid"]?:@"";
        manager.token = info[@"token"]?:@"";
        manager.name = info[@"name"]?:@"";
        manager.head = info[@"head"]?:@"";
    
    }) ;
    return manager ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareInstance] ;
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return [ZYUserManager shareInstance];
}

#pragma mark - RCIM
- (void)connectWithRCIM{
    if ([self isLogin]) {
        
        [[RCIM sharedRCIM]connectWithToken:_token success:^(NSString *userId) {
            
        } error:^(RCConnectErrorCode status) {
            [ZYSVPManager showText:@"Connnect Failed" autoClose:2];
        } tokenIncorrect:^{
            [ZYSVPManager showText:@"Wrong Token" autoClose:2];
        }];
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
    }
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    NSString *url = @"http://106.14.174.39/pet/user/get_user_info.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    [manager GET:url parameters:@{@"uid":userId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                NSDictionary *dic = responseObject[@"items"];
                
                RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:userId name:dic[@"name"] portrait:dic[@"head"]];
                completion(info);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Load Failed" autoClose:2];
    }];
}


#pragma Public Method
- (void)LoginOut{
    _userID = @"";
    _token = @"";
    _head = @"";
    _name = @"";
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserInfo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStateChange" object:nil];
    
    [[RCIM sharedRCIM] logout];
}

- (void)LoginWithUserInfo:(NSDictionary *)info{
    _userID = info[@"uid"];
    _token = info[@"token"];
    _name = info[@"name"];
    _head = info[@"head"];
    _cover = info[@"cover"];
    
    [self connectWithRCIM];
    
    [[NSUserDefaults standardUserDefaults]setObject:info forKey:@"UserInfo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStateChange" object:nil];
}

- (void)refreshUserInfo{
    if ([self isLogin]) {
        NSString *url = @"http://106.14.174.39/pet/user/get_user_info.php";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 8;
        NSDictionary *param = @{@"uid":_userID};
        
        __weak typeof(self) weakSelf = self;
        [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [weakSelf refreshUserInfoWithInfo:responseObject[@"items"]];
                [weakSelf connectWithRCIM];
            }else{
                [weakSelf LoginOut];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ZYSVPManager showText:@"Load Failed" autoClose:2];
            [weakSelf LoginOut];
        }];
    }
}

- (void)updateUserInfo{
    if ([self isLogin]) {
        NSString *url = @"http://106.14.174.39/pet/user/get_user_info.php";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 8;
        NSDictionary *param = @{@"uid":_userID};
        
        __weak typeof(self) weakSelf = self;
        [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [weakSelf refreshUserInfoWithInfo:responseObject[@"items"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
        }];
    }
}

- (void)refreshUserInfoWithInfo:(NSDictionary *)info{
    _name = info[@"name"];
    _head = info[@"head"];
    _cover = info[@"cover"];
    _token = info[@"token"];
    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:_userID name:_name portrait:_head];
    [[RCIM sharedRCIM] setCurrentUserInfo:userInfo];
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:_userID];
}

- (BOOL)isLogin{
    if (_userID.length>0  && _token.length>0) {
        return YES;
    }
    return NO;
}
@end
