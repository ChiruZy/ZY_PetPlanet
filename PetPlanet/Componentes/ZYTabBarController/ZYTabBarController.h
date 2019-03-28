//
//  ZYTabBarController.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/26.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYTabBarController : UITabBarController

- (instancetype)initWithControllers:(NSArray<UIViewController *>*)controllers;

- (void)setItemsWithImageNameArray:(NSArray<NSString *> *)nameArray;

@end

NS_ASSUME_NONNULL_END
