//
//  CreateAdoptViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/22.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CreateAdoptViewController.h"
#import "ZYBaseViewController+ImagePicker.h"
#import "ImageClassifier.h"
#import <Vision/Vision.h>
#import "ZYSVPManager.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "MyAdoptViewController.h"
#import "AdoptDetailViewController.h"

typedef NS_ENUM(NSUInteger, AdoptPetType) {
    AdoptPetCatType,
    AdoptPetDogType,
    AdoptPetEtcType,
};

@interface CreateAdoptViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (nonatomic,strong) NSData *imageData;
@property (nonatomic,assign) AdoptPetType type;
@property (nonatomic,strong) AdoptModel *model;
@property (nonatomic,assign) CGFloat moveDistance;
@property (nonatomic,strong) VNImageRequestHandler *imageRequest;
@end

@implementation CreateAdoptViewController

- (instancetype)initWithAdoptModel:(AdoptModel *)model{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    if (_model) {
        self.navigationItem.title = @"Edit Adopt";
    }else{
        self.navigationItem.title = @"New Adopt";
    }
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
    _image.userInteractionEnabled = YES;
    [_image addGestureRecognizer:tapImage];
    
    _name.delegate = self;
    _content.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapBG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss)];
    [self.view addGestureRecognizer:tapBG];
    
    UIBarButtonItem *publish = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"publish"] style:UIBarButtonItemStylePlain target:self action:@selector(publishEvent)];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[fix,publish];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    if (_model) {
        if (_model.image.length>0) {
            [_image sd_setImageWithURL:[NSURL URLWithString:_model.image]];
        }
        NSString *name = [_model.type isEqualToString:@"0"]?@"Cat":[_model.type isEqualToString:@"1"]?@"Dog":@"Etc";
        [self setPetTypeWithName:name];
        _content.text = _model.content;
        _name.text = _model.name;
        _placeHolder.hidden = YES;
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePetType:(UIButton *)sender {
    for (int i = 0; i<3; i++) {
        UIButton *button = [self.view viewWithTag:2010+i];
        
        if (sender == button) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:HEXCOLOR(0xA3A1F7)];
            _type = i;
        }else{
            [button setTitleColor:HEXCOLOR(0xA3A1F7) forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

- (void)tapImage{
    __weak typeof(self) weakSelf = self;
    [self pickImageWithpickImageCutImageWithImageSize:CGSizeMake(Screen_Width, Screen_Width) CompletionHandler:^(NSData * _Nonnull imageData, NSData * _Nonnull originData, UIImage * _Nonnull image) {
        weakSelf.imageData = imageData;
        weakSelf.image.image = image;
        if (@available(iOS 11.0, *)) {
            [weakSelf chargePhoto:image];
        }
    }];
}

- (void)publishEvent{
    if (_model) {
        [self editEvnet];
        return;
    }
    
    if (!_imageData) {
        [ZYSVPManager showText:@"No Image" autoClose:1.5];
        return;
    }
    if (_name.text.length == 0) {
        [ZYSVPManager showText:@"No Name" autoClose:1.5];
        return;
    }
    if (_content.text.length == 0) {
        [ZYSVPManager showText:@"No Content" autoClose:1.5];
        return;
    }
    
    NSData *nameData = [_name.text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *contentData = [_content.text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *uidData = [[ZYUserManager shareInstance].userID dataUsingEncoding:NSUTF8StringEncoding];
    NSData *typeData = [[NSString stringWithFormat:@"%zd",_type] dataUsingEncoding:NSUTF8StringEncoding];
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *url = @"http://106.14.174.39/pet/adopt/publish_adopt.php";

    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:contentData name:@"content"];
        [formData appendPartWithFormData:nameData name:@"name"];
        [formData appendPartWithFormData:uidData name:@"uid"];
        [formData appendPartWithFormData:typeData name:@"type"];
        [formData appendPartWithFileData:weakSelf.imageData name:@"image" fileName:@"uploadImage" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf popToList];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Failed" autoClose:1.5];
    }];
}

- (void)editEvnet{
    if (_name.text.length == 0) {
        [ZYSVPManager showText:@"No Name" autoClose:1.5];
        return;
    }
    if (_content.text.length == 0) {
        [ZYSVPManager showText:@"No Content" autoClose:1.5];
        return;
    }
    
    NSData *nameData = [_name.text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *contentData = [_content.text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *typeData = [[NSString stringWithFormat:@"%zd",_type] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aidData = [_model.aid dataUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *url = @"http://106.14.174.39/pet/adopt/edit_adopt.php";
    
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:contentData name:@"content"];
        [formData appendPartWithFormData:nameData name:@"name"];
        [formData appendPartWithFormData:typeData name:@"type"];
        [formData appendPartWithFormData:aidData name:@"aid"];
        if (weakSelf.imageData) {
            [formData appendPartWithFileData:weakSelf.imageData name:@"image" fileName:@"uploadImage" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf popToList];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Failed" autoClose:1.5];
    }];
}

- (void)popToList{
    __block BOOL flag = YES;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MyAdoptViewController class]]) {
            MyAdoptViewController *vc = obj;
            [vc reloadData];
            [self.navigationController popToViewController:vc animated:YES];
            flag = NO;
            *stop = YES;
            return;
        }
    }];
    if (flag) {
        MyAdoptViewController *vc = [[MyAdoptViewController alloc]initWithUid:[ZYUserManager shareInstance].userID];
        [self.navigationController pushViewController:vc animated:YES];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [arr removeObject:self];
        [self.navigationController setValue:arr forKey:@"viewControllers"];
    }
}

- (void)keyboardDismiss{
    [self.name resignFirstResponder];
    [self.content resignFirstResponder];
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

#pragma mark - TextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSMutableString *newStr = [NSMutableString stringWithString:textView.text];
    [newStr replaceCharactersInRange:range withString:text];
    if (newStr.length>0) {
        _placeHolder.hidden = YES;
    }else{
        _placeHolder.hidden = NO;
    }
    
    if (newStr.length>200){
        return NO;
    }
    return YES;
}


#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *newStr = [NSMutableString stringWithString:textField.text];
    [newStr replaceCharactersInRange:range withString:string];
    if (newStr.length>30){
        return NO;
    }
    return YES;
}

- (void)chargePhoto:(UIImage *)image{
    ImageClassifier *imageClass = [ImageClassifier new];
    __weak typeof(self) weakSelf = self;
    VNCoreMLModel *vnc = [VNCoreMLModel modelForMLModel:imageClass.model error:nil];
    VNCoreMLRequest *vnCoreMlRequest = [[VNCoreMLRequest alloc] initWithModel:vnc completionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        CGFloat confidence = 0.0f;
        VNClassificationObservation *tempClassification = nil;
        for (VNClassificationObservation *classification in request.results) {
            if (classification.confidence > confidence) {
                confidence = classification.confidence;
                tempClassification = classification;
            }
        }
        [weakSelf setPetTypeWithName:tempClassification.identifier];
    }];
    
    VNImageRequestHandler *vnImageRequestHandler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage options:nil];
    
    NSError *error = nil;
    [vnImageRequestHandler performRequests:@[vnCoreMlRequest] error:&error];
    
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
}

- (void)setPetTypeWithName:(NSString *)name{
    for (int i = 0; i<3; i++) {
        UIButton *button = [self.view viewWithTag:2010+i];
        
        if ([button.currentTitle isEqualToString:name]) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:HEXCOLOR(0xA3A1F7)];
            _type = i;
        }else{
            [button setTitleColor:HEXCOLOR(0xA3A1F7) forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }
}
@end
