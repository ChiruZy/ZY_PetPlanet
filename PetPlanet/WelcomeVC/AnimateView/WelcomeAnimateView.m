//
//  WelcomeAnimateView.m
//  KidsPact
//
//  Created by Overloop on 2019/2/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "WelcomeAnimateView.h"

@interface WelcomeAnimateView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@end

@implementation WelcomeAnimateView
- (void)setImage:(UIImage *)image title:(NSString *)title summary:(NSString *)summary{
    _imageView.image = image;
    UILabel *_title = [_titleView viewWithTag:100];
    UILabel *_summary = [_titleView viewWithTag:101];
    _title.text = title;
    _summary.text = summary;
    _title.layer.opacity = 0;
    _summary.layer.opacity = 0;
}

- (void)startAnimateWithDirection:(WAViewDirection)direction Completion:(void(^)(void))completion{
    NSInteger flag = direction?1:-1;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint imagePosition = weakSelf.imageView.layer.position;
        imagePosition.x -= flag*50;
        weakSelf.imageView.layer.position = imagePosition;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGPoint imagePosition = weakSelf.imageView.layer.position;
            imagePosition.x += flag*50;
            weakSelf.imageView.layer.position = imagePosition;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }];
    [self labelAnimate];
    
}

- (void)labelAnimate{
    UILabel *_title = [_titleView viewWithTag:100];
    UILabel *_summary = [_titleView viewWithTag:101];
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint titlePostionY = _title.layer.position;
        titlePostionY.y -= 50;
        CGPoint summaryPostionY = _summary.layer.position;
        summaryPostionY.y -= 50;
        
        _title.layer.position = titlePostionY;
        _summary.layer.position = summaryPostionY;
        
        _title.layer.opacity = 1;
        _summary.layer.opacity = 1;
    } completion:nil];
}

- (void)refreshAnimate{
    UILabel *_title = [_titleView viewWithTag:100];
    UILabel *_summary = [_titleView viewWithTag:101];
    
    CGPoint titlePostionY = _title.layer.position;
    titlePostionY.y += 50;
    CGPoint summaryPostionY = _summary.layer.position;
    summaryPostionY.y += 50;
    _title.layer.position = titlePostionY;
    _summary.layer.position = summaryPostionY;
    _title.layer.opacity = 0;
    _summary.layer.opacity = 0;
}

@end
