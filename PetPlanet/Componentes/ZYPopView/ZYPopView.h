//
//  ZYPopView.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZYPopViewType) {
    ZYPopViewBlurType,
    ZYPopViewBlackType,
};

typedef NS_ENUM(NSUInteger, ZYPopType) {
    ZYPopCenterType,
    ZYPopBottomType,
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^DismissBlock)(void);
@interface ZYPopView : UIView
@property (nonatomic,strong) DismissBlock dismissBlock;
@property (nonatomic,assign) ZYPopType popType;

- (instancetype)initWithContentView:(UIView *)contentView type:(ZYPopViewType)type;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
