//
//  WelcomeAnimateView.h
//  KidsPact
//
//  Created by Overloop on 2019/2/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WAViewDirection){
    WAViewDirectionLeft,
    WAViewDirectionRight,
};

@interface WelcomeAnimateView : UIView

- (void)setImage:(UIImage *)image title:(NSString *)title summary:(NSString *)summary;
- (void)startAnimateWithDirection:(WAViewDirection)direction Completion:(void(^)(void))completion;
- (void)labelAnimate;
- (void)refreshAnimate;
@end

NS_ASSUME_NONNULL_END
