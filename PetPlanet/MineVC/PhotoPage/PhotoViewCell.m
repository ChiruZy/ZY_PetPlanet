//
//  PhotoViewCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/14.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "PhotoViewCell.h"
#import "ImageReviewView.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface PhotoViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) PhotoModel *model;
@end

@implementation PhotoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configWithModel:(PhotoModel *)model{
    _model = model;
    NSURL *url = [NSURL URLWithString:model.image?:@""];
    if (url) {
        [_imageView sd_setImageWithURL:url];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageEvent:)];
        [_imageView addGestureRecognizer:tap];
    }
}



- (void)imageEvent:(UITapGestureRecognizer *)gesture{
    CGPoint point = [_imageView convertPoint:_imageView.frame.origin toView:[UIApplication sharedApplication].windows.lastObject];
    CGRect rect = CGRectMake(point.x, point.y, _imageView.frame.size.width, _imageView.frame.size.height);
    
    ImageReviewView *imageReviewView = [[ImageReviewView alloc]initWithOriginFrame:rect image:_imageView.image originImage:_model.originImage];
    [imageReviewView show];
}
@end
