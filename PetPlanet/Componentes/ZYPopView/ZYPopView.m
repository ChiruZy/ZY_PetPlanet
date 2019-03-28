//
//  ZYPopView.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYPopView.h"
#import <FXBlurView/FXBlurView.h>
#import "Common.h"

@interface ZYPopView ()

@property (nonatomic,strong) FXBlurView *blurView;
@property (nonatomic,strong) UIView *contentView;
@end

@implementation ZYPopView

- (instancetype)initWithContentView:(UIView *)contentView{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = [self getWindowImage];
        [self addSubview:imageView];
        
        _blurView = [[FXBlurView alloc]initWithFrame:self.bounds];
        [self addSubview:_blurView];
        _blurView.blurRadius = 4;
        _blurView.tintColor = [UIColor clearColor];
        _blurView.layer.opacity = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmiss)];
        [_blurView addGestureRecognizer:tap];
        
        CGFloat width = CGRectGetWidth(contentView.bounds);
        CGFloat height = CGRectGetHeight(contentView.bounds);
        CGRect frame = CGRectMake((Screen_Width - width)/2, (Screen_Height - height)/2 + 200, width, height);
        _contentView = contentView;
        _contentView.frame = frame;
        _contentView.layer.opacity = 0;
        _contentView.userInteractionEnabled = NO;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)show{
    CGFloat width = CGRectGetWidth(_contentView.bounds);
    CGFloat height = CGRectGetHeight(_contentView.bounds);
    CGRect frame = CGRectMake((Screen_Width - width)/2, (Screen_Height - height)/2, width, height);
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.blurView.layer.opacity = 1;
        weakSelf.contentView.layer.opacity = 1;
        weakSelf.contentView.frame = frame;
    }completion:^(BOOL finished) {
        weakSelf.blurView.userInteractionEnabled = YES;
        weakSelf.contentView.userInteractionEnabled = YES;
    }];
}

- (void)dissmiss{
    _blurView.userInteractionEnabled = NO;
    _contentView.userInteractionEnabled = NO;
    
    CGFloat width = CGRectGetWidth(_contentView.bounds);
    CGFloat height = CGRectGetHeight(_contentView.bounds);
    CGRect frame = CGRectMake((Screen_Width - width)/2, (Screen_Height - height)/2 + 200, width, height);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.blurView.layer.opacity = 0;
        weakSelf.contentView.layer.opacity = 0;
        weakSelf.contentView.frame = frame;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];  
}

- (UIImage *)getWindowImage{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    return capturedScreen;
}

@end
