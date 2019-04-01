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

@property (nonatomic,strong) UIView *underView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,assign) ZYPopViewType type;
@end

@implementation ZYPopView

- (instancetype)initWithContentView:(UIView *)contentView type:(ZYPopViewType)type{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _type = type;
        _contentView = contentView;
        [self addUnderView];
    }
    return self;
}

- (void)addUnderView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    if (_type == ZYPopViewBlurType || _type == ZYPopNoCancelType) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = [ZYPopView getWindowImage];
        [self addSubview:imageView];
        
        FXBlurView *blurView = [[FXBlurView alloc]initWithFrame:self.bounds];
        [self addSubview:blurView];
        blurView.blurRadius = 4;
        blurView.tintColor = [UIColor clearColor];
        blurView.layer.opacity = 0;
        if (_type == ZYPopViewBlurType) {
            [blurView addGestureRecognizer:tap];
        }
        _underView = blurView;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        view.layer.opacity = 0;
        [self addSubview:view];
        [view addGestureRecognizer:tap];
        _underView = view;
    }
}

- (void)configContentView{
    if (_popType == ZYPopCenterType) {
        CGFloat width = CGRectGetWidth(_contentView.bounds);
        CGFloat height = CGRectGetHeight(_contentView.bounds);
        CGRect frame = CGRectMake((Screen_Width - width)/2, (Screen_Height - height)/2 + 200, width, height);
        _contentView.frame = frame;
    }else{
        CGFloat width = CGRectGetWidth(_contentView.bounds);
        CGFloat height = CGRectGetHeight(_contentView.bounds);
        CGRect frame = CGRectMake((Screen_Width - width)/2, Screen_Height, width, height);
        _contentView.frame = frame;
    }
    
    _contentView.layer.opacity = 0;
    _contentView.userInteractionEnabled = NO;
    [self addSubview:_contentView];
}

+ (void)addBlurToView:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
    imageView.image = [self getWindowImage];
    [view addSubview:imageView];
    
    FXBlurView *blurView = [[FXBlurView alloc]initWithFrame:view.bounds];
    blurView.blurRadius = 4;
    blurView.tintColor = [UIColor clearColor];
    blurView.layer.opacity = 0;
    [view addSubview:blurView];
}

- (void)show{
    [self configContentView];
    CGFloat width = CGRectGetWidth(_contentView.bounds);
    CGFloat height = CGRectGetHeight(_contentView.bounds);
    
    CGRect frame;
    if (_popType == ZYPopCenterType) {
        frame = CGRectMake((Screen_Width - width)/2, (Screen_Height - height)/2, width, height);
    }else{
        frame = CGRectMake((Screen_Width - width)/2, Screen_Height - height, width, height);
    }
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.underView.layer.opacity = 1;
        weakSelf.contentView.layer.opacity = 1;
        weakSelf.contentView.frame = frame;
    }completion:^(BOOL finished) {
        weakSelf.underView.userInteractionEnabled = YES;
        weakSelf.contentView.userInteractionEnabled = YES;
    }];
}

- (void)dismiss{
    _underView.userInteractionEnabled = NO;
    _contentView.userInteractionEnabled = NO;
    
    CGFloat width = CGRectGetWidth(_contentView.bounds);
    CGFloat height = CGRectGetHeight(_contentView.bounds);
    
    CGRect frame;
    if (_popType == ZYPopCenterType) {
        frame = CGRectMake((Screen_Width - width)/2, (Screen_Height - height)/2 + 200, width, height);
    }else{
        frame = CGRectMake((Screen_Width - width)/2, Screen_Height, width, height);
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.underView.layer.opacity = 0;
        weakSelf.contentView.layer.opacity = 0;
        weakSelf.contentView.frame = frame;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (weakSelf.dismissBlock) {
            weakSelf.dismissBlock();
        }
    }];  
}

+ (UIImage *)getWindowImage{
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
