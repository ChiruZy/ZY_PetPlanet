//
//  StateCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StateCell : UITableViewCell

- (void)isConnectionLost:(BOOL)flag;
- (void)isNodata:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END
