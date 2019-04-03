//
//  HotLayout.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "HotLayout.h"
#import "Common.h"

@implementation HotLayout

- (void)awakeFromNib{
    [super awakeFromNib];
    self.minimumLineSpacing = 2;
    self.minimumInteritemSpacing = 2;
    CGFloat width = (Screen_Width - 40)/2 -20;
    self.itemSize = CGSizeMake(width, 28);
}

@end
