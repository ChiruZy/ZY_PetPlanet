//
//  ZYUserManager.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYUserManager.h"

static ZYUserManager *manager = nil;

@implementation ZYUserManager

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
    
}

- (void)LoginWithUserID:(NSString *)uid{
    
    
}
- (NSString *)UserID{
    return @"13735006499";
}
@end
