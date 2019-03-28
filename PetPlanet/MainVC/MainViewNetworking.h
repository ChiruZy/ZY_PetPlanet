//
//  MainViewNetworking.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id responseObject);
typedef void(^failBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface MainViewNetworking : NSObject

+ (void)getBannerWithBlock:(successBlock)success fail:(failBlock)fail;

@end

NS_ASSUME_NONNULL_END
