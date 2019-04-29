//
//  HintView.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/2.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Event)(void);

typedef NS_ENUM(NSUInteger, HintType) {
    HintLoginType,
    HintNoCandyType,
    HintNoMessageType,
    HintNoConnectType,
    HintWaitType,
    HintHiddenType,
};

NS_ASSUME_NONNULL_BEGIN

@interface HintView : UIView

@property (nonatomic,strong) Event refresh;
@property (nonatomic,strong) Event login;

- (void)setType:(HintType)type needButton:(BOOL)need;

- (void)moveY:(CGFloat)space;
@end

NS_ASSUME_NONNULL_END
