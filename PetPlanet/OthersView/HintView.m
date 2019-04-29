//
//  HintView.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/2.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "HintView.h"

@interface HintView ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *hint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yPoint;
@property (weak, nonatomic) IBOutlet UIImageView *planet;
@property (nonatomic,strong) UIView *hintView;
@end

@implementation HintView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _hintView = [[[NSBundle mainBundle]loadNibNamed:@"HintView" owner:self options:nil]firstObject];
        [self addSubview:_hintView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _hintView = [[[NSBundle mainBundle]loadNibNamed:@"HintView" owner:self options:nil]firstObject];
        _hintView.frame = self.bounds;
        [self addSubview:_hintView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _hintView.frame = self.bounds;
}

- (void)moveY:(CGFloat)space{
    _yPoint.constant = -30 + space;
}

- (void)setType:(HintType)type needButton:(BOOL)need{
    _button.hidden = !need;
    [_button removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    
    _planet.hidden = (type != HintLoginType && type != HintWaitType);
    _image.hidden = (type == HintLoginType || type == HintWaitType);
    
    
    if (type == HintLoginType) {
        self.hidden = NO;
        _hint.hidden = YES;
        [_button setTitle:@"Login Now" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
    }else if(type == HintNoCandyType){
        self.hidden = NO;
        _image.image = [UIImage imageNamed:@"noCandy"];
        _hint.hidden = NO;
        _hint.text = @"There Is Nothing";
        [_button setTitle:@"Refresh" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(refreshEvent) forControlEvents:UIControlEventTouchUpInside];
    }else if(type == HintNoConnectType){
        self.hidden = NO;
        _image.image = [UIImage imageNamed:@"noConnect"];
        _hint.hidden = NO;
        _hint.text = @"Connection Lost";
        [_button setTitle:@"Refresh" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(refreshEvent) forControlEvents:UIControlEventTouchUpInside];
    }else if(type == HintNoMessageType){
        self.hidden = NO;
        _image.image = [UIImage imageNamed:@"noMessage"];
        _hint.hidden = NO;
        _hint.text = @"No Message";
        [_button setTitle:@"Refresh" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(refreshEvent) forControlEvents:UIControlEventTouchUpInside];
    }else if(type == HintWaitType){
        self.hidden = NO;
        _hint.hidden = NO;
        _hint.text = @"Please Wait";
    }else{
        self.hidden = YES;
    }
}

- (void)loginEvent{
    if (_login) {
        _login();
    }
}

- (void)refreshEvent{
    if (_refresh) {
        _refresh();
    }
}

@end
