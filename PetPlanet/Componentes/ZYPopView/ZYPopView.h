//
//  ZYPopView.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYPopView : UIView

- (instancetype)initWithContentView:(UIView *)contentView;
- (void)show;
- (void)dissmiss;
@end

NS_ASSUME_NONNULL_END
