//
//  MainViewNetworking.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MainViewNetworking.h"
#import <AFNetworking.h>

@implementation MainViewNetworking

+ (void)getBannerWithBlock:(successBlock)success fail:(failBlock)fail{
    NSString *url = @"http://106.14.174.39/pet/banner/getBanner.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail();
    }];
}

@end
