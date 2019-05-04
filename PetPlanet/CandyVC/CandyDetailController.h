//
//  CandyDetailController.h
//  PetPlanet
//
//  Created by Overloop on 2019/5/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"
#import "CandyNetworking/CandyNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CandyDetailController : ZYBaseViewController

- (instancetype)initWithCandyModel:(CandyModel *)model;

- (void)edit;
@end

NS_ASSUME_NONNULL_END
