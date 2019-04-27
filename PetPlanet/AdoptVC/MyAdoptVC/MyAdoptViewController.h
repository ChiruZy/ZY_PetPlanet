//
//  MyAdoptViewController.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/25.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAdoptViewController : ZYBaseViewController

- (instancetype)initWithUid:(NSString *)uid;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
