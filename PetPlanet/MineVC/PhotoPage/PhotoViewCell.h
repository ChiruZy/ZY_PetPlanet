//
//  PhotoViewCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/14.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^DidLongPressCell)(PhotoModel *model);

@interface PhotoViewCell : UICollectionViewCell

- (void)configWithModel:(PhotoModel *)model;

@property (nonatomic,strong) DidLongPressCell block;

@end

NS_ASSUME_NONNULL_END
