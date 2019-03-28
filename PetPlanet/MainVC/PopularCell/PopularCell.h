//
//  PopularCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopularModel : NSObject

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) NSUInteger moodID;

@end


typedef void(^AllEvent)(void);
typedef void(^PopularEvent)(PopularModel *model);


@interface PopularCell : UITableViewCell

@property (nonatomic,strong) AllEvent allBlock;
@property (nonatomic,strong) PopularEvent popularBlock;
@property (nonatomic,strong) NSArray<PopularModel *> *models;
@end

NS_ASSUME_NONNULL_END
