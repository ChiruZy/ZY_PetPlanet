//
//  CandyNetworking.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

/* ERROR NUMBER
    10 Compelet
    11 No Follows (Following Only)
    12 Not Login (Following Only)
    13 Wrong Response
    14 Connect fail
    15 No List
*/
typedef void(^Complete)(void);
typedef void(^LoadComplete)(BOOL noMore);
typedef void(^Fail)(NSString *error);
typedef NS_ENUM(NSUInteger, CandyNetworkingType) {
    CandyNetworkingFollowingType,
    CandyNetworkingRecommendType,
    CandyNetworkingNewsType,
};

NS_ASSUME_NONNULL_BEGIN

@interface CandyModel : NSObject<YYModel>

@property NSString *header;
@property NSString *name;
@property NSString *summary;
@property NSString *image;
@property NSString *time;
@property NSUInteger reply;
@property NSUInteger like;
@property BOOL isLike;

@end


@interface CandyNetworking : NSObject

@property (nonatomic,strong,readonly) NSArray *models;

- (instancetype)initWithNetWorkingType:(CandyNetworkingType)type;

- (void)reloadModelsWithComplete:(Complete)complete fail:(Fail)fail;

- (void)loadMoreWithComplete:(LoadComplete)complete fail:(Fail)fail;

@end

NS_ASSUME_NONNULL_END
