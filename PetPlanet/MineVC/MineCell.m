//
//  MineCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "MineCell.h"

@interface MineCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation MineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellWithImage:(UIImage *)image title:(NSString *)title{
    
    _image.image = image;
    _title.text = title;
    
}
@end
