//
//  PhotoCell.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapPoint)(void);

@interface PhotoModel : NSObject

@property NSString *image;
@property NSString *originImage;

+ (instancetype)createWithImage:(NSString *)image originImage:(NSString *)originImage;
@end

@interface PhotoCell : UITableViewCell

@property (nonatomic,strong)TapPoint tapBlock;

- (void)setImagesWithImageModels:(NSArray<PhotoModel *> *)models;

@end

NS_ASSUME_NONNULL_END
