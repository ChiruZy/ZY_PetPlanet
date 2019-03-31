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


@end

@implementation PersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (IS_IPX) {
        _coverHeight.constant += 44;
    }
}

- (void)configWithDic:(NSDictionary *)dic isSelf:(BOOL)isSelf{
    [_cover sd_setImageWithURL:dic[@"cover"]];
    [_head sd_setImageWithURL:dic[@"head"]];

    _name.text = dic[@"name"]?:@"Loading";
    
    NSString *follow = [NSString stringWithFormat:@"Follow %@ ",dic[@"follow"]?:@""];
    NSString *like = [NSString stringWithFormat:@"like %@ ",dic[@"like"]?:@""];
    
    [_follow setTitle:follow forState:UIControlStateNormal];
    [_like setTitle:like forState:UIControlStateNormal];
    
    if ([dic[@"isMale"]isEqualToString:@"0"]) {
        [_sex setImage:[UIImage imageNamed:@"female"]];
    }
    if (isSelf) {
        _edit.hidden = NO;
    }
}
@end
