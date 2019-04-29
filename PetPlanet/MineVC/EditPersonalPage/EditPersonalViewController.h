//
//  EditPersonalViewController.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^complete)(void);

@interface EditPersonalViewController : ZYBaseViewController

- (instancetype)initWithCompleteBlock:(complete)block;

@end

NS_ASSUME_NONNULL_END
