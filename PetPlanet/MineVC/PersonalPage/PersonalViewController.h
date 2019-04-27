//
//  PersonalViewController.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalViewController : ZYBaseViewController

- (instancetype)initWithUserID:(NSString *)userID;

@property (nonatomic,strong,readonly) NSString *uid;

@end

NS_ASSUME_NONNULL_END
