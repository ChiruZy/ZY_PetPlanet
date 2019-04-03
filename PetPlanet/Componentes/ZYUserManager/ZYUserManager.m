//
//  ZYUserManager.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYUserManager.h"

@interface ZYUserManager ()

@end

static ZYUserManager *manager = nil;

@implementation ZYUserManager

@synthesize userID = _uid;

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:nil] init];
    }) ;
    return manager ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self shareInstance] ;
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return [ZYUserManager shareInstance];
}

- (void)LoginOut{
    _isLogin = NO;
    _uid = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStateChange" object:nil];
}

- (void)LoginWithUserID:(NSString *)uid{
    _isLogin = YES;
    _uid = uid;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStateChange" object:nil];
}

- (NSString *)userID{
    if (!_uid) {
        return @"";
    }
    return _uid;
}

@end
