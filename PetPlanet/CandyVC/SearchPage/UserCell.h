//
//  UserCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UICollectionViewCell

- (void)configWithUserModel:(UsersModel *)model;

- (void)configWithName:(NSString *)name Image:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
