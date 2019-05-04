//
//  CandyReplyCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/5/2.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CandyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^BlockWithUid)(NSString *uid);
typedef void(^BlockWithModel)(CandyReplyModel *model);

@interface CandyReplyCell : UITableViewCell

@property (nonatomic,strong) BlockWithUid nameOrHeadBlock;
@property (nonatomic,strong) BlockWithModel replyBlock;

- (void)configWithModel:(CandyReplyModel *)model;

@end

NS_ASSUME_NONNULL_END
