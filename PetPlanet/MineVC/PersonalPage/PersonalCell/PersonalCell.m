//
//  PersonalCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "PersonalCell.h"
#import "Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "ZYUserManager.h"

@interface PersonalCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverHeight;

@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UIButton *follow;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *adobt;
@property (weak, nonatomic) IBOutlet UIButton *message;

@property (nonatomic,assign) BOOL isFollow;
@property (nonatomic,assign) BOOL networking;
@end

@implementation PersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (IS_IPX) {
        _coverHeight.constant += 44;
    }
}

- (void)configWithDic:(NSDictionary *)dic isSelf:(BOOL)isSelf{
    if (!dic) {
        return;
    }
    NSString *cover = dic[@"cover"];
    if ([cover isKindOfClass:[NSString class]]) {
        [_cover sd_setImageWithURL:[NSURL URLWithString:cover]];
    }
    
    NSString *head = dic[@"head"];
    if ([head isKindOfClass:[NSString class]]) {
        [_head sd_setImageWithURL:[NSURL URLWithString:head]];
    }
    _name.text = dic[@"name"]?:@"Loading";
    
    NSString *follow = [NSString stringWithFormat:@"Follow %@ ",dic[@"follows"]?:@""];
    NSString *like = [NSString stringWithFormat:@"like %@ ",dic[@"like"]?:@""];
    
    [_follow setTitle:follow forState:UIControlStateNormal];
    [_like setTitle:like forState:UIControlStateNormal];
    
    [_follow addTarget:self action:@selector(followPage) forControlEvents:UIControlEventTouchUpInside];
    [_like addTarget:self action:@selector(likePage) forControlEvents:UIControlEventTouchUpInside];
    
    if ([dic[@"sex"]isEqualToString:@"0"]) {
        [_sex setImage:[UIImage imageNamed:@"female"]];
    }else{
        [_sex setImage:[UIImage imageNamed:@"male"]];
    }

    _edit.hidden = NO;
    [_message removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [_edit removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    if (isSelf) {
        _message.hidden = YES;
        [_edit addTarget:self action:@selector(editEvent) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _message.hidden = NO;
        if ([dic[@"is_Follows"] isEqualToString:@"1"]) {
            _isFollow = YES;
            [_edit setImage:[UIImage imageNamed:@"unFollow"] forState:UIControlStateNormal];
        }else{
            _isFollow = NO;
            [_edit setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        }
        [_edit addTarget:self action:@selector(followEvent) forControlEvents:UIControlEventTouchUpInside];
        [_message addTarget:self action:@selector(messageEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    [_adobt addTarget:self action:@selector(adoptEvent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)followPage{
    if (_followPageBlock) {
        _followPageBlock();
    }
}

- (void)likePage{
    if (_likePageBlock) {
        _likePageBlock();
    }
}

- (void)messageEvent{
    if (_messageBlock) {
        _messageBlock();
    }
}

- (void)editEvent{
    if (_editBlock) {
        _editBlock();
    }
}

- (void)followEvent{
    if (_followBlock && !_networking) {
        _networking = YES;
        NSString *uid = _followBlock();
        
        NSString *url = @"http://106.14.174.39/pet/mine/set_follow.php";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 8;
        NSDictionary *param = @{@"uid":[ZYUserManager shareInstance].userID,
                                @"oid":uid,
                                @"isFollow":!_isFollow?@"1":@"0",
                                };
        __weak typeof(self) weakSelf = self;
        [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *error = responseObject[@"error"];
                if([error isEqualToString:@"10"]){
                    weakSelf.isFollow = !weakSelf.isFollow;
                    UIImage *image = [UIImage imageNamed:weakSelf.isFollow?@"unFollow":@"follow"];
                    [weakSelf.edit setImage:image forState:UIControlStateNormal];
                    weakSelf.networking = NO;
                    return;
                }
            }
            weakSelf.networking = NO;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            weakSelf.networking = NO;
        }];
    }
}

- (void)adoptEvent{
    if (_adoptBlock) {
        _adoptBlock();
    }
}
@end
