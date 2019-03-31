//
//  CollectionsViewController.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, InterractiveVCType) {
    InterractiveVCLikeType,
    InterractiveVCCollectionType,
};

@interface InterractiveViewController : ZYBaseViewController

- (instancetype)initWithInterractiveType:(InterractiveVCType)type;

@end

NS_ASSUME_NONNULL_END
