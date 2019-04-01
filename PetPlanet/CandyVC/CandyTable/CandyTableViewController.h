//
//  CandyTableViewController.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CandyListType) {
    CandyListFollowingType,
    CandyListRecommendType,
    CandyListNewsType,
};

@interface CandyTableViewController : UIViewController<JXCategoryListContentViewDelegate>

- (instancetype)initWithCandyListType:(CandyListType)type superView:(UIViewController *)superView;

@end

NS_ASSUME_NONNULL_END
