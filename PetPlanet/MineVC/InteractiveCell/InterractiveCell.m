//
//  InterractiveCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "InterractiveCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageReviewView.h"

@interface InterractiveCell()
@property (weak, nonatomic) IBOutlet UILabel *interractiveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *reply;
@property (weak, nonatomic) IBOutlet UIButton *like;

@property (nonatomic,assign) BOOL isLike;
@property (nonatomic,assign) NSString * likeNumber;
@property (nonatomic,strong) InterractiveModel *model;
@end

@implementation InterractiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellWithModel:(InterractiveModel *)model{
    _model = model;
    _isLike = model.isLike;
    _likeNumber = model.like;
    
    _time.text = model.time;
    _summary.text = model.summary;
    
    [_image sd_setImageWithURL:[NSURL URLWithString:model.smallImage]];
    [_head sd_setImageWithURL:[NSURL URLWithString:model.head]];
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameOrHeadEvent)];
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageEvent:)];
    [_head addGestureRecognizer:tapHead];
    [_image addGestureRecognizer:tapImage];
    
    [_name setTitle:model.name forState:UIControlStateNormal];
    [_name addTarget:self action:@selector(nameOrHeadEvent) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isLike) {
        [_like setImage:[UIImage imageNamed:@"likeButton_selected"] forState:UIControlStateNormal];
    }else{
        [_like setImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
    }
    
    if (model.like.integerValue > 9999) {
        [_like setTitle:@"9999+" forState:UIControlStateNormal];
    }else{
        [_like setTitle:[NSString stringWithFormat:@"%@",model.like] forState:UIControlStateNormal];
    }
    [_like addTarget:self action:@selector(likeEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [_reply setTitle:[NSString stringWithFormat:@"%@",model.reply] forState:UIControlStateNormal];
    [_reply addTarget:self action:@selector(replyEvent) forControlEvents:UIControlEventTouchUpInside];
    
    if (_type == InterractiveLikeType) {
        _interractiveLabel.text = [NSString stringWithFormat:@"Liked %@",model.interractiveTime];
    }else{
        _interractiveLabel.text = [NSString stringWithFormat:@"Collected %@",model.interractiveTime];
    }
}

- (void)likeEvent{
    _isLike = !_isLike;
    NSUInteger number = _isLike?_likeNumber.integerValue + 1:_likeNumber.integerValue-1;
    [self configLikeWithIsLike:_isLike likeNumber:number];
    
    if ([_delegate respondsToSelector:@selector(cellDidTapLikeWithModel:isLike:)]) {
        [_delegate cellDidTapLikeWithModel:_model isLike:YES];
    }
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

- (void)replyEvent{
    if ([_delegate respondsToSelector:@selector(cellDidTapReplyWithModel:)]) {
        [_delegate cellDidTapReplyWithModel:_model];
    }
}

- (void)nameOrHeadEvent{
    if ([_delegate respondsToSelector:@selector(cellDidTapHeadOrNameWithModel:)]) {
        [_delegate cellDidTapHeadOrNameWithModel:_model];
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

