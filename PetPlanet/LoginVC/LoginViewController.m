//
//  LoginViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "LoginViewController.h"
#import <SVProgressHUD.h>
#import "ZYSVPManager.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic,assign) CGPoint position;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *verificationField;
@property (weak, nonatomic) IBOutlet UIView *verificationView;
@property (nonatomic,assign) BOOL showPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (nonatomic,assign) BOOL isSignUp;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBG)];
    [self.view addGestureRecognizer:tap];
    
    [_phoneField setValue:HEXCOLOR(0xA8A8A8) forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordField setValue:HEXCOLOR(0xA8A8A8) forKeyPath:@"_placeholderLabel.textColor"];
    [_verificationField setValue:HEXCOLOR(0xA8A8A8) forKeyPath:@"_placeholderLabel.textColor"];
    [_verificationField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [_phoneField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [_passwordField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}

- (void)tapBG{
    [self.view endEditing:YES];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillChangeFrame:(NSNotification*)sender{
    if (!CGPointEqualToPoint(_position, CGPointZero)) {
        return;
    }
    CGFloat duration = [sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    if (IS_IPX) {
        transformY += 104;
    }else{
        transformY += 60;
    }
    
    CGPoint position = self.view.layer.position;
    _position = position;
    position.y += transformY;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.view.layer.position = position;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardDidHide:(NSNotification *)notification{
    if (CGPointEqualToPoint(_position, CGPointZero)) {
        return;
    }
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.view.layer.position = weakSelf.position;
    }completion:^(BOOL finished) {
        weakSelf.position = CGPointZero;
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (IBAction)showPassword:(id)sender {
    _showPassword = !_showPassword;
    if (_showPassword) {
        [sender setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
    }
    _passwordField.secureTextEntry = !_showPassword;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *newStr = [NSMutableString stringWithString:textField.text];
    [newStr replaceCharactersInRange:range withString:string];
    if (textField == _phoneField) {
        if (newStr.length>11) {
            return NO;
        }
    }
    if (textField == _passwordField) {
        if (newStr.length>18) {
            return NO;
        }
    }
    return YES;
}
- (IBAction)signUp:(id)sender {
    [self.view endEditing:YES];
    if (_phoneField.text.length<11 || ![Common validateCellPhoneNumber:_phoneField.text]) {
        if ([ZYSVPManager isVisible]) {
            return;
        }
        [ZYSVPManager showText:@"Wrong number" autoClose:2];
        return;
    }
    
    if (_passwordField.text.length<8) {
        if ([ZYSVPManager isVisible]) {
            return;
        }
        [ZYSVPManager showText:@"Short password" autoClose:2];
        return;
    }
}
- (IBAction)register:(id)sender {
    UIButton *button = sender;
    button.userInteractionEnabled = NO;
    _isSignUp = !_isSignUp;
    __weak typeof(self) weakSelf = self;
    NSString *title = _isSignUp?@"Sign up":@"Login";
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.verificationView.layer.opacity = weakSelf.isSignUp?1:0;
        weakSelf.topSpace.constant = weakSelf.isSignUp?74:34;
        [button setTitle:title forState:UIControlStateNormal];
        [weakSelf.loginButton setTitle:!weakSelf.isSignUp?@"Sign up":@"Login" forState:UIControlStateNormal];
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        button.userInteractionEnabled = YES;
    }];
    
    
}

@end
