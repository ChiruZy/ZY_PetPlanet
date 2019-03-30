//
//  NotConnectView.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "NotConnectView.h"

@interface NotConnectView ()
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (nonatomic,strong) UIView *connectView;
@end

@implementation NotConnectView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _connectView = [[[NSBundle mainBundle]loadNibNamed:@"NotConnectView" owner:self options:nil]firstObject];
        [self addSubview:_connectView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _connectView.frame = self.bounds;
}

- (void)reloadButtonAddTarget:(id)target action:(nullable SEL)action{
    [_reloadButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [_reloadButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end

