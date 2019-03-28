//
//  WelcomeViewController.h
//  KidsPact
//
//  Created by Overloop on 2019/2/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completedBlock)(void);

NS_ASSUME_NONNULL_BEGIN
@interface WelcomeViewController : UIViewController

@property (nonatomic,strong) completedBlock block;

@end

NS_ASSUME_NONNULL_END
