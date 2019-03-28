//
//  KolCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface KolModel : NSObject

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSUInteger userID;

@end


typedef void(^AllEvent)(void);
typedef void(^KolEvent)(KolModel *model);


@interface KolCell : UITableViewCell

@property (nonatomic,strong) AllEvent allBlock;
@property (nonatomic,strong) KolEvent kolBlock;
@property (nonatomic,strong) NSArray<KolModel *> *models;

@end


NS_ASSUME_NONNULL_END
