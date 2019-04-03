//
//  StateCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "StateCell.h"
#import "HintView.h"

@interface StateCell()

@property (weak, nonatomic) IBOutlet HintView *hintView;

@end

@implementation StateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)isConnectionLost:(BOOL)flag{
    [_hintView setType:HintNoConnectType needButton:NO];
}

- (void)isNodata:(BOOL)flag{
    [_hintView setType:HintNoCandyType needButton:NO];
}
@end
