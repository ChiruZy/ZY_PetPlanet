//
//  CandyDetailCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/5/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CandyDetailModel.h"

typedef void(^LikeComplete)(void);

@protocol CandyDetailCellDelegate <NSObject>

- (void)didLoadImage:(CGFloat)imageHeight;

- (void)didTapImageOrNameWithUid:(NSString *)uid;

- (void)didTapWithIsLike:(BOOL)isLike complete:(LikeComplete)block;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CandyDetailCell : UITableViewCell

@property (nonatomic,weak) id <CandyDetailCellDelegate> delegate;

- (void)configWithModel:(CandyDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
