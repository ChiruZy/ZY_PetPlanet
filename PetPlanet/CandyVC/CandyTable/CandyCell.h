//
//  CandyCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CandyNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CandyCellDelegate <NSObject>

- (void)cellDidTapLikeWithModel:(CandyModel *)model isLike:(BOOL)isLike;

- (void)cellDidTapReplyWithModel:(CandyModel *)model;

- (void)cellDidTapHeadOrNameWithModel:(CandyModel *)model;

- (void)cellDidTapImageWithModel:(CandyModel *)model;

@end

@interface CandyCell : UITableViewCell

@property (nonatomic,weak) id <CandyCellDelegate> delegate;

- (void)configCellWithModel:(CandyModel *)model;

@end

NS_ASSUME_NONNULL_END
