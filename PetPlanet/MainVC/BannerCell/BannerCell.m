//
//  BannerCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "BannerCell.h"
#import "Common.h"

@interface BannerCell()

@property (nonatomic,strong) NSArray<UIImageView *> *imageViews;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews{
    [self reloadBanner];
}

- (void)reloadBanner{
    _imageViews = nil;
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self configScrollView];
}

- (void)setImages:(NSArray<UIImage *> *)images{
    _images = images;
    [self reloadBanner];
}

- (void)configScrollView{
    CGSize contentSize = self.bounds.size;
    if (_images.count > 0) {
        contentSize.width *= _images.count;
    }
    _scrollView.contentSize = contentSize;
    __weak typeof(_scrollView) weakScrollView = _scrollView;
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakScrollView addSubview:obj];
    }];
}

- (NSArray<UIImageView *> *)imageViews{
    if (!_imageViews) {
        NSMutableArray *arr = [NSMutableArray new];
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        [_images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = CGRectMake(idx * width, 0, width, height);
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
            imageView.layer.cornerRadius = 15;
            imageView.image = obj;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
            [arr addObject:imageView];
        }];
        
        if (arr.count == 0) {
            CGRect frame = CGRectMake(0 , 0, width, height);
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
            imageView.image = [Common imageWithColor:HEXCOLOR(0xB0EDCF)];
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 15;
            
            [arr addObject:imageView];
        }
        _imageViews = arr.copy;
    }
    return _imageViews;
}

- (void)tapImageView:(UITapGestureRecognizer *)sender{
    __weak typeof(self) weakSelf = self;
    [_imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sender.view == obj && weakSelf.block) {
            weakSelf.block(idx);
            *stop = YES;
            return;
        }
    }];
}
@end
