//
//  HotDelegate.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^EventWithStr)(NSString * _Nullable content);

typedef void(^Event)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HotDelegate : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) EventWithStr block;

@property (nonatomic,strong) Event noData;

@property (nonatomic,strong) Event getDataComplete;

@end

NS_ASSUME_NONNULL_END
