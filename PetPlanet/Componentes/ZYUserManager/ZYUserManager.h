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

@property (nonatomic,strong,readonly) NSString *UserID;

@property (nonatomic,assign,readonly) BOOL isLogin;

- (void)LoginWithUserID:(NSString *)uid;

- (void)LoginOut;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
