//
//  MyAdoptCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MyAdoptCell.h"
#import <UIImageView+WebCache.h>

@interface MyAdoptCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation MyAdoptCell

- (void)configWithAdoptModel:(AdoptModel *)model{
    if (model.image.length>0) {
        [_image sd_setImageWithURL:[NSURL URLWithString:model.image]];
    }
    _name.text = model.name;
    _content.text = model.content;
}

@end
