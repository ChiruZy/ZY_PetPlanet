//
//  EditNameViewController.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"
typedef void (^StringBack)(NSString * _Nullable string);
NS_ASSUME_NONNULL_BEGIN

@interface EditNameViewController : ZYBaseViewController

@property (nonatomic,strong) StringBack block;

- (instancetype)initWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
