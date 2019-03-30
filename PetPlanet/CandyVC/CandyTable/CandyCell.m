//
//  CandyCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CandyCell.h"

@interface CandyCell ()
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIButton *head;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *reply;

@end

@implementation CandyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
