//
//  HotCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotCell : UICollectionViewCell

- (void)setTitle:(NSString *)title;

@property (nonatomic,strong,readonly) NSString *title;

@end

NS_ASSUME_NONNULL_END
