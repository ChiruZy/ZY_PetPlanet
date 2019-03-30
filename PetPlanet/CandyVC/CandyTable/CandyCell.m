//
//  CandyCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CandyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageReviewView.h"

@interface CandyCell ()
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *reply;

@property (nonatomic,assign) BOOL isLike;
@property (nonatomic,assign) NSUInteger likeNumber;
@property (nonatomic,strong) CandyModel *model;
@end

@implementation CandyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configCellWithModel:(CandyModel *)model{
    _model = model;
    _isLike = model.isLike;
    _likeNumber = model.like;
    
    _time.text = model.time;
    _summary.text = model.summary;
    
    [_image sd_setImageWithURL:[NSURL URLWithString:model.smallImage]];
    [_head sd_setImageWithURL:[NSURL URLWithString:model.header]];
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
    
    if (model.like > 9999) {
        [_like setTitle:@"9999+" forState:UIControlStateNormal];
    }else{
        [_like setTitle:[NSString stringWithFormat:@"%zd",model.like] forState:UIControlStateNormal];
    }
    [_like addTarget:self action:@selector(likeEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [_reply setTitle:[NSString stringWithFormat:@"%zd",model.reply] forState:UIControlStateNormal];
    [_reply addTarget:self action:@selector(replyEvent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)likeEvent{
    _isLike = !_isLike;
    NSUInteger number = _isLike?_likeNumber+1:_likeNumber-1;
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
    
    //ImageReviewView *imageReviewView = [[ImageReviewView alloc]initWithOriginFrame:rect image:imageView.image originImage:_model.image];
    ImageReviewView *imageReviewView = [[ImageReviewView alloc]initWithOriginFrame:rect image:[UIImage imageNamed:@"planet"] originImage:_model.image];
    [imageReviewView show];
}

@end
