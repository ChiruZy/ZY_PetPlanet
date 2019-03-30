//
//  ImageReviewView.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageReviewView : UIView

- (instancetype)initWithOriginFrame:(CGRect)frame image:(UIImage *)image originImage:(NSString *)originImage;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
