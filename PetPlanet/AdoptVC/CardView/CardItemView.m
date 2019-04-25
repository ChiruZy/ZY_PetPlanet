//
//  CardItemView.m
//  CardListView
//
//  Created by Johnny on 2017/4/26.
//  Copyright © 2017年 Johnny. All rights reserved.
//

#import "CardItemView.h"

@interface CardItemView ()

@property (assign, nonatomic) CGPoint originalCenter;
@property (assign, nonatomic) CGFloat currentAngle;
@property (assign, nonatomic) BOOL isLeft;

@end

@implementation CardItemView

#pragma mark - Inital

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [self init];
    [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.originalCenter = CGPointMake(frame.origin.x + frame.size.width / 2.0, frame.origin.y + frame.size.height / 2.0);
}

- (void)initView {
    [self addPanGest];
    [self configLayer];
}

- (void)addPanGest {
    self.userInteractionEnabled = NO;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestHandle:)];
    [self addGestureRecognizer:pan];
}

- (void)configLayer {
    self.layer.cornerRadius = 15.0;
    self.layer.masksToBounds = YES;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.clipsToBounds = NO;
    self.layer.shadowOpacity = 0.1;
}

#pragma mark - UIPanGestureRecognizer

- (void)panGestHandle:(UIPanGestureRecognizer *)panGest {
    if (panGest.state == UIGestureRecognizerStateChanged) {
        CGPoint movePoint = [panGest translationInView:self];
        _isLeft = (movePoint.x < 0);

        CGPoint finalPoint = CGPointMake(self.center.x + movePoint.x, self.center.y + movePoint.y);
        finalPoint.y =_originalCenter.y;
        self.center = finalPoint;        
        CGFloat angle = (self.center.x - self.frame.size.width / 2.0) / self.frame.size.width / 4.0;
        _currentAngle = angle;
        self.transform = CGAffineTransformMakeRotation(-angle);
        
        [panGest setTranslation:CGPointZero inView:self];
        if ([self.delegate respondsToSelector:@selector(cardItemViewDidMoveRate:anmate:)]) {
            CGFloat rate = fabs(angle)/0.15>1 ? 1 : fabs(angle)/0.15;
            [self.delegate cardItemViewDidMoveRate:rate anmate:NO];
        }
        
    } else if (panGest.state == UIGestureRecognizerStateEnded) {
        CGPoint vel = [panGest velocityInView:self];
        if (vel.x < -500 || vel.x > 500) {
            [self remove];
            return ;
        }
        __weak typeof(self) weakSelf = self;
        float ratio = fabs((self.center.x - _originalCenter.x)/80.0);
        if (ratio < 1.0) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.center = weakSelf.originalCenter;
                weakSelf.transform = CGAffineTransformMakeRotation(0);
                if ([weakSelf.delegate respondsToSelector:@selector(cardItemViewDidMoveRate:anmate:)]) {
                    [weakSelf.delegate cardItemViewDidMoveRate:0 anmate:YES];
                }
            }];
        } else {
            [self remove];
        }
    }
}

#pragma mark - Remove

- (void)remove {
    [self removeWithLeft:_isLeft];
}

- (void)removeWithLeft:(BOOL)left {
    if ([self.delegate respondsToSelector:@selector(cardItemViewDidMoveRate:anmate:)]) {
        [self.delegate cardItemViewDidMoveRate:1 anmate:YES];
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        if (!left) {
            weakSelf.center = CGPointMake([UIScreen mainScreen].bounds.size.width+weakSelf.frame.size.width, weakSelf.center.y + weakSelf.currentAngle * weakSelf.frame.size.height + (weakSelf.currentAngle == 0 ? 100 : 0));
        } else {
            weakSelf.center = CGPointMake(-weakSelf.frame.size.width, weakSelf.center.y - weakSelf.currentAngle * weakSelf.frame.size.height + (weakSelf.currentAngle == 0 ? 100 : 0));
        }
    } completion:^(BOOL finished) {
        if (finished) {
            if ([weakSelf.delegate respondsToSelector:@selector(cardItemViewDidRemoveFromSuperView:)]) {
                [weakSelf.delegate cardItemViewDidRemoveFromSuperView:weakSelf];
            }
        }
    }];
}

@end
