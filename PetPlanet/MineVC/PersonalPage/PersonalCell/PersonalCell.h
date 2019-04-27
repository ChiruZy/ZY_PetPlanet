//
//  PersonalCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EventBlock)(void);
typedef NSString *_Nullable(^FollowBlock)(void);

@interface PersonalCell : UITableViewCell

@property (nonatomic,strong) EventBlock messageBlock;
@property (nonatomic,strong) EventBlock editBlock;
@property (nonatomic,strong) EventBlock adoptBlock;
@property (nonatomic,strong) FollowBlock followBlock;


- (void)configWithDic:(NSDictionary *)dic isSelf:(BOOL)isSelf;

@end

NS_ASSUME_NONNULL_END
