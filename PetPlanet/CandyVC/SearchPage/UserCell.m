//
//  UserCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "UserCell.h"
#import <UIImageView+WebCache.h>

@interface UserCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configWithUserModel:(UsersModel *)model{
    if (model.head.length>0) {
        [_image sd_setImageWithURL:[NSURL URLWithString:model.head]];
    }else{
        [_image setImage:nil];
    }
    _label.text = model.name;
}

- (void)configWithName:(NSString *)name Image:(UIImage *)image{
    _label.text = name;
    _image.image = image;
}

@end
