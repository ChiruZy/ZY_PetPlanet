//
//  SearchUserCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/6.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "SearchUserCell.h"
#import <UIImageView+WebCache.h>

@interface SearchUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *follow;

@property (nonatomic,assign) NSString *uid;
@property (nonatomic,assign) BOOL isFollow;
@end

@implementation SearchUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configWithModel:(SearchUserModel *)model{
    if ([model.head isKindOfClass:[NSString class]]) {
        [_head sd_setImageWithURL:[NSURL URLWithString:model.head]];
    }
    NSString *follow = model.follow?:@"";
    NSString *like = model.like?:@"";
    _uid = model.uid;
    
    if ([_uid isEqualToString:[ZYUserManager shareInstance].userID]) {
        _follow.hidden = YES;
    }else{
        _follow.hidden = NO;
    }
    
    _content.text = [NSString stringWithFormat:@"%@ Follow  %@ Like",follow,like];
    _name.text = model.name;
    
    NSString *isFollow = model.isFollow;
    if ([isFollow isEqualToString:@"1"]) {
        _isFollow = YES;
        [_follow setImage:[UIImage imageNamed:@"unFollow"] forState:UIControlStateNormal];
    }else{
        _isFollow = NO;
        [_follow setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
    }
    [_follow addTarget:self action:@selector(tapFollow) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapFollow{
    __weak typeof(self) weakSelf = self;
    if (_block) {
        self.block(_uid, !_isFollow, ^{
            weakSelf.isFollow = !weakSelf.isFollow;
            [weakSelf.follow setImage:[UIImage imageNamed:weakSelf.isFollow?@"unFollow":@"follow"] forState:UIControlStateNormal];
        });
    }
}


@end
