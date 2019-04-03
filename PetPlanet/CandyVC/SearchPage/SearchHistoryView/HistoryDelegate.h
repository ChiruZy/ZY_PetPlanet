//
//  HistoryDelegate.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EventWithStr)(NSString * _Nullable content);

typedef void(^EventWithBool)(BOOL flag);

@interface HistoryDelegate : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>

- (instancetype)initWithNeedRefreshBlock:(EventWithBool)needRefresh;

@property (nonatomic,strong) EventWithStr block;

- (void)setObjectToHistory:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
