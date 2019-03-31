//
//  ImageReviewView.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ImageReviewView.h"
#import "Common.h"
#import "ImageReviewPopView.h"
#import "ZYPopView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZYSVPManager.h"

@interface ImageReviewView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSString *originImagePath;
@property (nonatomic,strong) ZYPopView *popView;
@property (nonatomic,assign) BOOL isOriginImage;
@property (nonatomic,assign) BOOL isLongPress;
@end

@implementation ImageReviewView

- (instancetype)initWithOriginFrame:(CGRect)frame image:(UIImage *)image originImage:(NSString *)originImage{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _originImagePath = originImage;
        [self checkImageCache];
        
        self.backgroundColor = [UIColor blackColor];
        self.layer.opacity = 0;
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
        
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        _imageView = [[UIImageView alloc]initWithFrame:frame];
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_imageView];
    }
    return self;
}

- (void)checkImageCache{
    __weak typeof(self) weakSelf = self;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:_originImagePath];
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache){
        if (isInCache) {
            weakSelf.isOriginImage = YES;
            UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:weakSelf.originImagePath];
            weakSelf.imageView.image = image;
        }
    }];
}

- (void)show{
    CGSize size = _imageView.image.size;
    CGFloat imageRatio = size.width/size.height;
    CGFloat screenRatio = Screen_Width/Screen_Height;
    
    CGSize imageViewSize;
    imageViewSize.width = imageRatio>=screenRatio  ? Screen_Width: Screen_Height * imageRatio;
    imageViewSize.height = imageRatio>=screenRatio ? Screen_Width / imageRatio : Screen_Height;
    
    CGRect frame;
    frame.origin.x = (Screen_Width - imageViewSize.width)/2;
    frame.origin.y = (Screen_Height - imageViewSize.height)/2;
    frame.size = imageViewSize;
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.layer.opacity = 1;
        weakSelf.imageView.frame = frame;
    }completion:^(BOOL finished) {
        UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        weakSelf.userInteractionEnabled = YES;
        [weakSelf addGestureRecognizer:tapBack];
        
        UILongPressGestureRecognizer *tapImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
        weakSelf.imageView.userInteractionEnabled = YES;
        [weakSelf.imageView addGestureRecognizer:tapImage];
    }];
}

- (void)longPress{
    if (_isLongPress) {
        return;
    }
    _isLongPress = YES;
    
    __weak typeof(self) weakSelf = self;
    [_imageView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.imageView removeGestureRecognizer:obj];
    }];
    
    ImageReviewPopView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"ImageReviewPopView" owner:nil options:nil]firstObject];
    [contentView addTarget:self download:@selector(download) originImage:@selector(originImage)];
    if (_isOriginImage) {
        [contentView RemoveOriginImageView];
    }
    
    _popView = [[ZYPopView alloc]initWithContentView:contentView type:ZYPopViewBlackType];
    _popView.popType = ZYPopBottomType;
    [_popView setDismissBlock:^{
        UILongPressGestureRecognizer *tapImage = [[UILongPressGestureRecognizer alloc]initWithTarget:weakSelf action:@selector(longPress)];
        weakSelf.imageView.userInteractionEnabled = YES;
        [weakSelf.imageView addGestureRecognizer:tapImage];
        weakSelf.isLongPress = NO;
    }];
    [_popView show];
}

- (void)download{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:_originImagePath];
    if (!url) {
        [_popView dismiss];
        return;
    }
    [manager diskImageExistsForURL:url  completion:^(BOOL isInCache) {
        UIImage *image;
        if (isInCache) {
            image =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        }else{
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data];
        }
        UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }];
}

- (void)originImage{
    _isOriginImage = YES;
    [_imageView sd_setImageWithURL:[NSURL URLWithString: _originImagePath] placeholderImage:_imageView.image];
    [_popView dismiss];
}

- (void)dismiss{
    self.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.layer.opacity = 0;
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL){
        [ZYSVPManager showText:@"Download Failed" autoClose:2];
    }else{
        [ZYSVPManager showText:@"Download Successed" autoClose:2];
    }
    [_popView dismiss];
}
#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}

@end
