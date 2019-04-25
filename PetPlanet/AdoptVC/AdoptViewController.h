//
//  AdoptViewController.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdoptModel : NSObject
@property NSString *aid;
@property NSString *uid;
@property NSString *name;
@property NSString *content;
@property NSString *image;
@property NSString *type;

@end

@interface AdoptViewController : ZYBaseViewController

@end

NS_ASSUME_NONNULL_END
