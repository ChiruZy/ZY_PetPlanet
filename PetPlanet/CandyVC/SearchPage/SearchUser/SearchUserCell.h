//
//  SearchUserCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/6.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchUserViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^FollowEvent)(NSString *uid,BOOL isFollow);

@interface SearchUserCell : UITableViewCell

@property (nonatomic,strong) FollowEvent _Nullable block;

- (void)configWithModel:(SearchUserModel *)model;

@end

NS_ASSUME_NONNULL_END