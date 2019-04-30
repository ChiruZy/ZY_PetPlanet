//
//  ChooseView.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Event)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ChooseView : UIView

@property (nonatomic,strong) Event yesEvent;
@property (nonatomic,strong) Event cancelEvent;

@end

NS_ASSUME_NONNULL_END
