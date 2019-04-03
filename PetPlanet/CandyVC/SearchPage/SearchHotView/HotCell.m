//
//  HotCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "HotCell.h"

@interface HotCell()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation HotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (NSString *)title{
    return _label.text;
}

- (void)setTitle:(NSString *)title{
    _label.text = title;
}
@end
