//
//  SearchViewNetwork.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CandyNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface UsersModel : NSObject

@property NSString *uid;
@property NSString *name;
@property NSString *head;

@end

typedef void(^Complete)(void);
typedef void(^Fail)(NSString *error);
typedef void(^LoadComplete)(BOOL noMore);

@interface SearchViewNetwork : NSObject

@property (nonatomic,strong,readonly) NSArray<UsersModel *> *users;
@property (nonatomic,strong,readonly) NSArray<CandyModel *> *models;

- (void)searchWithKeyword:(NSString *)keyword complete:(Complete)complete fail:(Fail)fail;
- (void)searchMoreWithKeyword:(NSString *)keyword complete:(LoadComplete)complete fail:(Fail)fail;

- (void)removeRecord;
@end

NS_ASSUME_NONNULL_END
