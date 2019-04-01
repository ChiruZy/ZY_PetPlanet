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
    16 Candy Networking Buzy
*/
typedef void(^Complete)(void);
typedef void(^Fail)(NSString *error);
typedef void(^LoadComplete)(BOOL noMore);

typedef NS_ENUM(NSUInteger, CandyNetworkingType) {
    CandyNetworkingFollowingType,
    CandyNetworkingRecommendType,
    CandyNetworkingNewsType,
    CandyNetworkingUserType,
};

NS_ASSUME_NONNULL_BEGIN

@interface CandyModel : NSObject<YYModel>

@property NSString *head;
@property NSString *name;
@property NSString *summary;
@property NSString *image;
@property NSString *smallImage;
@property NSString *time;
@property NSString *timeInterval;
@property NSString *reply;
@property NSString *hot;
@property NSString *like;
@property NSString *authorID;
@property NSString *candyID;

@property BOOL isLike;

@end


@interface CandyNetworking : NSObject

@property (nonatomic,strong,readonly) NSArray *models;

- (instancetype)initWithNetWorkingType:(CandyNetworkingType)type;

- (void)reloadPersonalWithUid:(NSString *)uid Complete:(Complete)complete fail:(Fail)fail;

- (void)reloadModelsWithComplete:(Complete)complete fail:(Fail)fail;

- (void)loadMoreWithComplete:(LoadComplete)complete fail:(Fail)fail;

- (void)loadMorePersonalWithUid:(NSString *)uid WithComplete:(LoadComplete)complete fail:(Fail)fail;
@end

NS_ASSUME_NONNULL_END
