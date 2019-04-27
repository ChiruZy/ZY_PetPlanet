//
//  ZYUserManager.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYUserManager : NSObject

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *head;
@property (nonatomic,strong) NSString *cover;

@property (nonatomic,assign,readonly) BOOL isLogin;

- (void)LoginWithUserInfo:(NSDictionary *)info;

- (void)LoginOut;

- (void)refreshUserInfoWithInfo:(NSDictionary *)info;

- (void)refreshUserInfo;

- (void)updateUserInfo;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
