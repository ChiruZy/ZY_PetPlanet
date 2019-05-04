//
//  InterractiveNetworking.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "CandyNetworking.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^Complete)(void);
typedef void(^Fail)(NSString *error);
typedef void(^LoadComplete)(BOOL noMore);

typedef NS_ENUM(NSUInteger, InterractiveType) {
    InterractiveLikeType,
    InterractiveCollectionType,
};

@interface InterractiveModel : CandyModel <YYModel>

@property NSString *interractiveTime;
@property NSString *interractiveTimeInterval;

@end

@interface InterractiveNetworking : NSObject

@property (nonatomic,strong,readonly) NSArray *models;

- (instancetype)initWithNetWorkingType:(InterractiveType)type;

- (void)reloadModelsWithUid:(NSString *)uid complete:(Complete)complete fail:(Fail)fail;

- (void)loadMoreWithUid:(NSString *)uid complete:(LoadComplete)complete fail:(Fail)fail;

@end

NS_ASSUME_NONNULL_END
