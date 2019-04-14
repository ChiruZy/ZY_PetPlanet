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
#import <AFNetworking.h>
#import <JKCountDownButton.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *sender;
@property (weak, nonatomic) IBOutlet UITextField *verificationField;
@property (weak, nonatomic) IBOutlet UIView *verificationView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (nonatomic,assign) BOOL isSignUp;
@property (nonatomic,assign) BOOL showPassword;
@property (nonatomic,assign) CGFloat moveDistance;
@property (nonatomic,strong) Login loginBlock;
@end

@implementation LoginViewController

#pragma mark - LifeCycle

- (instancetype)initWithLoginBlock:(Login)block{
    if (self = [super init]) {
        self.loginBlock = block;
    }
    return self;
}


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
    
    [self configSendButton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - PrivateMethod

- (void)configSendButton{
    [_sender countDownChanging:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        return [NSString stringWithFormat:@"%zd s",second];
    }];
    [_sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        return @"Send";
    }];
    __weak typeof(self) weakSelf = self;
    [_sender countDownButtonHandler:^(JKCountDownButton *countDownButton, NSInteger tag) {
        [weakSelf sendCode];
    }];
}

- (void)sendCode{
    if (![Common validateCellPhoneNumber:_phoneField.text]) {
        [ZYSVPManager showText:@"Wrong Number" autoClose:2];
        return;
    }
    [_sender startCountDownWithSecond:60];
    _sender.enabled = NO;
    
    NSString *url = @"http://106.14.174.39/pet/user/post_code.php";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *param = @{@"mobile":_phoneField.text};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [ZYSVPManager showText:@"Server Error" autoClose:2];
            return;
        }
        NSString *error = responseObject[@"error"];
        if ([@"10" isEqualToString:error]) {

        }else if ([error isEqualToString:@"11"]){
            [ZYSVPManager showText:@"Already Registered" autoClose:2];
        }else if ([error isEqualToString:@"12"]){
            [ZYSVPManager showText:@"Send Failed" autoClose:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Time Out" autoClose:2];
    }];
}

- (void)signUpEvent{
    if (_verificationField.text.length<6) {
        [ZYSVPManager showText:@"Short Verification" autoClose:2];
        return;
    }
    NSString *url = @"http://106.14.174.39/pet/user/sign_up.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *param = @{@"number":_phoneField.text,
                            @"password":_passwordField.text,
                            @"code":_verificationField.text,
                            };
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [ZYSVPManager showText:@"Server Error" autoClose:2];
            return;
        }
        NSString *error = responseObject[@"error"];
        if ([@"10" isEqualToString:error]) {
            [ZYSVPManager showText:@"Success" autoClose:2];
            [weakSelf loginSuccessWithInfo:responseObject[@"items"]];
        }else if ([error isEqualToString:@"18"]){
            [ZYSVPManager showText:@"Wrong Code" autoClose:2];
        }else if ([error isEqualToString:@"17"]){
            [ZYSVPManager showText:@"Server Error" autoClose:2];
        }else if ([error isEqualToString:@"16"]){
            [ZYSVPManager showText:@"Expired Code" autoClose:2];
        }else if ([error isEqualToString:@"15"]){
            [ZYSVPManager showText:@"No Record" autoClose:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Time Out" autoClose:2];
    }];
}

- (void)loginEvent{
    NSString *url = @"http://106.14.174.39/pet/user/login.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *param = @{@"uid":_phoneField.text,
                            @"password":_passwordField.text,
                            };
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [ZYSVPManager showText:@"Server Error" autoClose:2];
            return;
        }
        NSString *error = responseObject[@"error"];
        if ([@"10" isEqualToString:error]) {
            [ZYSVPManager showText:@"Success" autoClose:2];
            [weakSelf loginSuccessWithInfo:responseObject[@"item"]];
        }else if ([error isEqualToString:@"17"]){
            [ZYSVPManager showText:@"Server Error" autoClose:2];
        }else if ([error isEqualToString:@"16"]){
            [ZYSVPManager showText:@"Wrong Password" autoClose:2];
        }else if ([error isEqualToString:@"15"]){
            [ZYSVPManager showText:@"UnRegistered" autoClose:2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Time Out" autoClose:2];
    }];
}

- (void)loginSuccessWithInfo:(NSDictionary *)info{
    [[ZYUserManager shareInstance] LoginWithUserInfo:info];
    [self.navigationController popViewControllerAnimated:YES];
    if (_loginBlock) {
        _loginBlock(info[@"uid"]);
    }
}

#pragma mark - UIControl Event
- (void)tapBG{
    [self.view endEditing:YES];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)signUp:(id)sender {
    [self.view endEditing:YES];
    if (_phoneField.text.length<11 || ![Common validateCellPhoneNumber:_phoneField.text]) {
        [ZYSVPManager showText:@"Wrong Number" autoClose:2];
        return;
    }
    
    if (_passwordField.text.length<8) {
        [ZYSVPManager showText:@"Short Password" autoClose:2];
        return;
    }
    
    if(_isSignUp){
        [self signUpEvent];
    }else{
        [self loginEvent];
    }

    if (_loginBlock) {
        _loginBlock(@"");
    }
}

- (IBAction)register:(id)sender {
    UIButton *button = sender;
    button.userInteractionEnabled = NO;
    _isSignUp = !_isSignUp;
    __weak typeof(self) weakSelf = self;
    NSString *title = !_isSignUp?@"Sign up":@"Login";
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.verificationView.layer.opacity = weakSelf.isSignUp?1:0;
        weakSelf.topSpace.constant = weakSelf.isSignUp?74:34;
        [button setTitle:title forState:UIControlStateNormal];
        [weakSelf.loginButton setTitle:weakSelf.isSignUp?@"Sign up":@"Login" forState:UIControlStateNormal];
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        button.userInteractionEnabled = YES;
    }];
}
#pragma mark - KeyboardEvent
- (void)keyboardWillChangeFrame:(NSNotification*)sender{
    CGFloat duration = [sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    CGFloat value = transformY - _moveDistance;
    _moveDistance = transformY;

    CGPoint position = self.view.layer.position;
    position.y += value;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.view.layer.position = position;
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __weak typeof(self) weakSelf = self;
    
    CGPoint position = self.view.layer.position;
    position.y -= _moveDistance;
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.view.layer.position = position;
    }completion:^(BOOL finished) {
        weakSelf.moveDistance = 0;
    }];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *newStr = [NSMutableString stringWithString:textField.text];
    [newStr replaceCharactersInRange:range withString:string];
    if (textField == _phoneField) {
        if (newStr.length>11) {
            return NO;
        }
        if (newStr.length<11) {
            _sender.enabled = NO;
            _loginButton.enabled = NO;
        }else{
            _sender.enabled = YES;
            _loginButton.enabled = YES;
        }
    }
    if (textField == _passwordField) {
        if (newStr.length>18) {
            return NO;
        }
    }if (textField == _verificationField){
        if (newStr.length>6) {
            return NO;
        }
    }
    
    return YES;
}
@end
