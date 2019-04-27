//
//  MyAdoptCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/4/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdoptViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAdoptCell : UITableViewCell

- (void)configWithAdoptModel:(AdoptModel *)model;

@end

NS_ASSUME_NONNULL_END
