//
//  CandyDetailCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/5/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CandyDetailCell.h"
#import <UIImageView+WebCache.h>
#import "Common.h"
#import "ImageReviewView.h"

@interface CandyDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UILabel *comments;

@property (nonatomic,assign) BOOL isLike;
@property (nonatomic,assign) NSUInteger likeNumber;
@property (nonatomic,strong) CandyDetailModel *model;
@end

@implementation CandyDetailCell

- (void)configWithModel:(CandyDetailModel *)model{
    _model = model;
    
    [_name setTitle:model.name forState:UIControlStateNormal];
    [_name addTarget:self action:@selector(tapName) forControlEvents:UIControlEventTouchUpInside];
    
    _likeNumber = model.like.integerValue;
    _isLike = model.isLike.boolValue;
    _content.text = model.content;
    _time.text = [Common getDateStringWithTimeString:model.time];
    _comments.text = [NSString stringWithFormat:@"comments %@",model.comments];
    
    if (model.like.integerValue > 9999) {
        [_like setTitle:@"9999+" forState:UIControlStateNormal];
    }else{
        [_like setTitle:model.like forState:UIControlStateNormal];
    }
    
    if (_isLike) {
        [_like setImage:[UIImage imageNamed:@"likeButton_selected"] forState:UIControlStateNormal];
    }else{
        [_like setImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
    }
    [_like addTarget:self action:@selector(likeEvent) forControlEvents:UIControlEventTouchUpInside];
    
    if (model.head.length>0) {
        [_head sd_setImageWithURL:[NSURL URLWithString:model.head]];
        UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHead)];
        [_head addGestureRecognizer:tapHead];
    }
    
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:model.smallImage] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        [weakSelf.image setImage:image];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:weakSelf action:@selector(imageEvent:)];
        [weakSelf.image addGestureRecognizer:tap];
        weakSelf.image.userInteractionEnabled = YES;
        if ([weakSelf.delegate respondsToSelector:@selector(didLoadImage:)]) {
            CGFloat imageHeight = image.size.height/image.size.width * (Screen_Width - 20*2);
            CGFloat height = 153 + imageHeight + weakSelf.content.frame.size.height;
            [weakSelf.delegate didLoadImage:height];
        }
    }];
}

- (void)configLikeWithIsLike:(BOOL)isLike likeNumber:(NSUInteger)number{
    if (isLike) {
        [_like setImage:[UIImage imageNamed:@"likeButton_selected"] forState:UIControlStateNormal];
    }else{
        [_like setImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
    }
    if (number > 9999) {
        [_like setTitle:@"9999+" forState:UIControlStateNormal];
    }else{
        [_like setTitle:[NSString stringWithFormat:@"%zd",number] forState:UIControlStateNormal];
    }
}

- (void)likeEvent{
    BOOL isLike = !_isLike;
    __weak typeof(self) weakSelf = self;
    if ([_delegate respondsToSelector:@selector(didTapWithIsLike:complete:)]) {
        [_delegate didTapWithIsLike:isLike complete:^{
            weakSelf.isLike = isLike;
            weakSelf.likeNumber = weakSelf.isLike?weakSelf.likeNumber+1:weakSelf.likeNumber-1;
            [self configLikeWithIsLike:weakSelf.isLike likeNumber:weakSelf.likeNumber];
        }];
    }
}

- (void)tapName{
    if ([self.delegate respondsToSelector:@selector(didTapImageOrNameWithUid:)]) {
        [self.delegate didTapImageOrNameWithUid:_model.uid];
    }
}

- (void)tapHead{
    if ([self.delegate respondsToSelector:@selector(didTapImageOrNameWithUid:)]) {
        [self.delegate didTapImageOrNameWithUid:_model.uid];
    }
}

- (void)imageEvent:(UITapGestureRecognizer *)gesture{
    UIImageView *imageView = (UIImageView *)gesture.view;
    CGPoint point = [imageView convertPoint:imageView.frame.origin toView:[UIApplication sharedApplication].windows.lastObject];
    CGRect rect = CGRectMake(point.x, point.y, imageView.frame.size.width, imageView.frame.size.height);
    
    ImageReviewView *imageReviewView = [[ImageReviewView alloc]initWithOriginFrame:rect image:imageView.image originImage:_model.image];
    [imageReviewView show];
}
@end
