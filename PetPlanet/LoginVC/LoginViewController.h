//
//  LoginViewController.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^Login)(NSString *uid);

@interface LoginViewController : ZYBaseViewController

- (instancetype)initWithLoginBlock:(Login)block;

@end

NS_ASSUME_NONNULL_END
