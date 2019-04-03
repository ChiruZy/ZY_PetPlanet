//
//  HistoryLayout.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "HistoryLayout.h"

@implementation HistoryLayout


- (void)awakeFromNib{
    [super awakeFromNib];
    self.minimumLineSpacing = 11;
    self.minimumInteritemSpacing = 13;
    self.estimatedItemSize = CGSizeMake(60, 24);
}
@end
