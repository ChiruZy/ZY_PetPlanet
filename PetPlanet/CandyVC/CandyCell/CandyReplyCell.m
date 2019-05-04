//
//  CandyReplyCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/5/2.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CandyReplyCell.h"
#import <UIImageView+WebCache.h>
#import "Common.h"

@interface CandyReplyCell()
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *replyView;

@property (nonatomic,strong) CandyReplyModel *model;

@end

@implementation CandyReplyCell

- (void)configWithModel:(CandyReplyModel *)model{
    _model = model;
    
    [_name setTitle:model.name forState:UIControlStateNormal];
    _content.text = model.content;
    _time.text = [Common getDateStringWithTimeString:model.time];
    
    if (model.head.length) {
        [_head sd_setImageWithURL:[NSURL URLWithString:model.head]];
    }
    
    [_name addTarget:self action:@selector(didTapNameOrHead) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapNameOrHead)];
    [_head addGestureRecognizer:tapImage];
    
    UITapGestureRecognizer *tapReply = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapReplyView)];
    [_replyView addGestureRecognizer:tapReply];
    
    _head.userInteractionEnabled = YES;
    _replyView.userInteractionEnabled = YES;
}

- (void)didTapNameOrHead{
    if (_nameOrHeadBlock) {
        _nameOrHeadBlock(_model.uid);
    }
}

- (void)didTapReplyView{
    if (_replyBlock) {
        _replyBlock(_model);
    }
}
@end
