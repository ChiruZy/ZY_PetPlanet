//
//  StateCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "StateCell.h"
@interface StateCell()
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIView *connectionView;


@end

@implementation StateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)isConnectionLost:(BOOL)flag{
    _noDataView.hidden = flag;
    _connectionView.hidden = !flag;
}

- (void)isNodata:(BOOL)flag{
    _noDataView.hidden = !flag;
    _connectionView.hidden = flag;
}
@end
