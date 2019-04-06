//
//  SearchUserViewController.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/6.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchUserModel : NSObject

@property NSString *isFollow;
@property NSString *name;
@property NSString *head;
@property NSString *uid;
@property NSString *like;
@property NSString *follow;


@end


@interface SearchUserViewController : ZYBaseViewController

- (instancetype)initWithKeyword:(NSString *)keyword;

@end

NS_ASSUME_NONNULL_END
