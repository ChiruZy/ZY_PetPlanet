//
//  BannerCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BannerEvent)(NSUInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface BannerCell : UITableViewCell

@property (nonatomic,strong) NSArray<UIImage *> *images;

@property (nonatomic,strong) BannerEvent block;

@end

NS_ASSUME_NONNULL_END
