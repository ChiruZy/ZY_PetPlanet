//
//  CardItem.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/21.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CardItem.h"
#import <UIImageView+WebCache.h>

@interface CardItem ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation CardItem

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CardItem" owner:nil options:nil] firstObject];
    [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    [self initView];
    [self configImageView];
    return self;
}


- (void)configImageView{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_image.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _image.bounds;
    maskLayer.path = maskPath.CGPath;
    _image.layer.mask = maskLayer;
}

- (void)configWithAdoptModel:(AdoptModel *)model{
    _name.text = model.name;
    _content.text = model.content;
    NSURL *url = [NSURL URLWithString:model.image];
    if (url) {
        [_image sd_setImageWithURL:url];
    }
    
    
}
@end
