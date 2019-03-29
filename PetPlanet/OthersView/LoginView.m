//
//  LoginView.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic,strong) UIView *loginView;
@end

@implementation LoginView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _loginView = [[[NSBundle mainBundle]loadNibNamed:@"LoginView" owner:self options:nil]firstObject];
        [self addSubview:_loginView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _loginView.frame = self.bounds;
}

- (void)loginButtonAddTarget:(id)target action:(nullable SEL)action{
    [_loginButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [_loginButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end

