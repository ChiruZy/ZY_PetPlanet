//
//  CandyDetailNetwork.h
//  PetPlanet
//
//  Created by Overloop on 2019/5/2.
//  Copyright © 2019 Chiru. All rights reserved.
//

/* ERROR NUMBER
 10 Compelet
 11 No Follows (Following Only)
 12 Not Login (Following Only)
 13 Wrong Response
 14 Connect fail
 15 No List
 16 Candy Networking Buzy
 */

#import <Foundation/Foundation.h>
#import "CandyCell/CandyDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^Complete)(void);
typedef void(^Fail)(NSString *error);
typedef void(^LoadComplete)(BOOL noMore);

@interface CandyDetailNetwork : NSObject

@property (nonatomic,strong,readonly) CandyDetailModel *detailModel;
@property (nonatomic,strong,readonly) NSArray<CandyReplyModel *> *replyModels;

- (void)reloadDataWithAid:(NSString *)cid complete:(Complete)complete fail:(Fail)fail;

- (void)replyWithContent:(NSString *)content cid:(NSString *)cid complete:(Complete)complete fail:(Fail)fail;

- (void)deleteCandyWithCid:(NSString *)cid complete:(Complete)complete fail:(Fail)fail;

- (void)collectionWithCid:(NSString *)cid isCollection:(BOOL)isCollection complete:(Complete)complete fail:(Fail)fail;

- (void)likeWithCid:(NSString *)cid isLike:(BOOL)isLike complete:(Complete)complete fail:(Fail)fail;
@end

NS_ASSUME_NONNULL_END
