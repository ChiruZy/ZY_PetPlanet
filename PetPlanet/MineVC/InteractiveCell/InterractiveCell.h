//
//  InterractiveCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CandyCell.h"
#import "InterractiveNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface InterractiveCell : UITableViewCell

@property (nonatomic,weak) id <CandyCellDelegate> delegate;

- (void)configCellWithModel:(InterractiveModel *)model;

@end

NS_ASSUME_NONNULL_END
