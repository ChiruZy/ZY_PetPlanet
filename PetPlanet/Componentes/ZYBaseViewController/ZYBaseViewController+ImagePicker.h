//
//  ZYBaseViewController+ImagePicker.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/24.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImagePickerCompletionHandler)(NSData *imageData,NSData *originData,UIImage *image);

@interface ZYBaseViewController (ImagePicker)

- (void)pickImageWithCompletionHandler:(ImagePickerCompletionHandler)completionHandler;

- (void)pickImageWithpickImageCutImageWithImageSize:(CGSize)imageSize CompletionHandler:(ImagePickerCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
