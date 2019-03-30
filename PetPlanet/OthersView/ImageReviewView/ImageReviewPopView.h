//
//  ImageReviewPopView.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageReviewPopView : UIView

- (void)addTarget:(id)target download:(nullable SEL)download originImage:(nullable SEL)originImage;

- (void)RemoveOriginImageView;

@end

NS_ASSUME_NONNULL_END
