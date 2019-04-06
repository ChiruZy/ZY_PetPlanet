//
//  UserTableViewCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewNetwork.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EventBlock)(UsersModel *nullable);

@interface UserTableViewCell : UITableViewCell

@property (nonatomic,strong) EventBlock block;

- (void)configWithUserModels:(NSArray<UsersModel *> *)models;

@end

NS_ASSUME_NONNULL_END
