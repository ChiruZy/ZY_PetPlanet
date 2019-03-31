//
//  PersonalCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "PersonalCell.h"
#import "Common.h"

@interface PersonalCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverHeight;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UIButton *follow;
@property (weak, nonatomic) IBOutlet UIButton *like;


@end

@implementation PersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (IS_IPX) {
        _coverHeight.constant += 44;
    }
}

@end
