//
//  ChangeCoverView.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Event)(void);

@interface ChangeCoverView : UIView
@property (nonatomic,strong) Event photo;
@property (nonatomic,strong) Event local;
@end

NS_ASSUME_NONNULL_END
