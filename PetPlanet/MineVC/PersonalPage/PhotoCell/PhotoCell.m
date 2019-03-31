//
//  PhotoCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "PhotoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageReviewView.h"

@implementation PhotoModel

+ (instancetype)createWithImage:(NSString *)image originImage:(NSString *)originImage{
    PhotoModel *model = [PhotoModel new];
    model.image = image;
    model.originImage = image;
    return model;
}
@end

@interface PhotoCell()

@property (nonatomic,strong) NSArray *imageArr;

@property (nonatomic,strong) NSArray *models;
@end

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImagesWithImageModels:(NSArray<PhotoModel *> *)models{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *arr = [NSMutableArray new];
    [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 4) {
            *stop = YES;
            return ;
        }
        PhotoModel *model = obj;
        [arr addObject:model];
        
        UIImageView *imageView = weakSelf.imageArr[idx];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        imageView.userInteractionEnabled = YES;
        imageView.layer.opacity = 1;
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tapImage];
    }];
    _models = arr.copy;
    
    if (models.count == 0) {
        [self configImageViewAtIndex:0];
    }else if (models.count < 5) {
        [self configImageViewAtIndex:models.count];
    }else{
        [self configImageViewAtIndex:4];
    }
}

- (void)configImageViewAtIndex:(NSUInteger)index{
    UIImageView *imageView = self.imageArr[index];
    imageView.layer.opacity = 1;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"point"];
    
    UITapGestureRecognizer *tapPoint = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPoint)];
    [imageView addGestureRecognizer:tapPoint];
}

- (void)tapPoint{
    if (_tapBlock) {
        _tapBlock();
    }
}

- (void)tapImage:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    CGPoint point = [imageView convertPoint:imageView.frame.origin toView:[UIApplication sharedApplication].windows.lastObject];
    CGRect rect = CGRectMake(point.x, point.y, imageView.frame.size.width, imageView.frame.size.height);
    
    NSUInteger index = imageView.tag - 1030;
    PhotoModel *model = _models[index];
    ImageReviewView *imageReviewView = [[ImageReviewView alloc]initWithOriginFrame:rect image:imageView.image originImage:model.originImage];
    [imageReviewView show];
}

- (NSArray *)imageArr{
    if (!_imageArr) {
        NSMutableArray *arr = [NSMutableArray new];
        for (int i = 0; i<5; i++) {
            UIImageView *imageView = [self.contentView viewWithTag:1030+i];
            [arr addObject:imageView];
        }
        _imageArr = arr.copy;
    }
    return _imageArr;
}
@end
