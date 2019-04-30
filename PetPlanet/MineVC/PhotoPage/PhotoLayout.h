//
//  PhotoLayout.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/14.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

#define colMargin 8
#define colCount 2
#define rolMargin 8
#define topMargin 30

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath);

@interface PhotoLayout : UICollectionViewLayout

- (instancetype)initWithHeightBlock:(HeightBlock)heightBlock;

@end

NS_ASSUME_NONNULL_END
