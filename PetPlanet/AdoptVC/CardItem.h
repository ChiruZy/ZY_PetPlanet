//
//  CardItem.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/21.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CardItemView.h"
#import "AdoptViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardItem : CardItemView
- (void)configWithAdoptModel:(AdoptModel *)model;
@end

NS_ASSUME_NONNULL_END
