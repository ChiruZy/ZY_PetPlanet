//
//  NewCandyController.m
//  PetPlanet
//
//  Created by Overloop on 2019/5/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "NewCandyController.h"
#import "ZYSVPManager.h"
#import "ZYBaseViewController+ImagePicker.h"
#import <AFNetworking.h>
#import "CandyDetailController.h"

@interface NewCandyController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;

@property (nonatomic,strong) NSData *imageData;
@property (nonatomic,strong) NSData *originData;

@end

@implementation NewCandyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"New";
    
    UIBarButtonItem *publish = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"publish"] style:UIBarButtonItemStylePlain target:self action:@selector(publishEvent:)];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[fix,publish];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    [_textView becomeFirstResponder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
    [_image addGestureRecognizer:tapImage];
    _image.userInteractionEnabled = YES;
}

- (void)tapImage{
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [self pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, NSData * _Nonnull originData, UIImage * _Nonnull image) {
        weakSelf.imageData = imageData;
        weakSelf.originData = originData;
        weakSelf.image.image = image;
    }];
}

- (void)tapBack{
    [self.view endEditing:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publishEvent:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    
    if (_textView.text.length == 0) {
        [ZYSVPManager showText:@"No Input" autoClose:1.5];
        return;
    }
    if (!(_image && _imageData)) {
        [ZYSVPManager showText:@"No Image" autoClose:1.5];
        return;
    }
    
    sender.enabled = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *url = @"http://106.14.174.39/pet/candy/publish_candy.php";
    NSData *contentData = [_textView.text dataUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:@{@"uid":[ZYUserManager shareInstance].userID} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:contentData name:@"content"];
        [formData appendPartWithFileData:weakSelf.imageData name:@"image" fileName:@"uploadImage" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:weakSelf.originData name:@"originImage" fileName:@"uploadImage" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                CandyModel *model = [CandyModel new];
                model.authorID = [ZYUserManager shareInstance].userID;
                model.candyID = responseObject[@"cid"];
                CandyDetailController *detail = [[CandyDetailController alloc]initWithCandyModel:model];
                [weakSelf.navigationController pushViewController:detail animated:YES];
                
                NSMutableArray *arr = weakSelf.navigationController.viewControllers.mutableCopy;
                [arr removeObject:self];
                [weakSelf.navigationController setValue:arr forKey:@"viewControllers"];
                return;
            }
        }
        sender.enabled = YES;
        [ZYSVPManager showText:@"Failed" autoClose:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        sender.enabled = YES;
        [ZYSVPManager showText:@"Failed" autoClose:1.5];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSMutableString *newStr = [NSMutableString stringWithString:textView.text];
    [newStr replaceCharactersInRange:range withString:text];
    _placeHolder.hidden = newStr.length!=0;
    if (newStr.length>200){
        return NO;
    }
    return YES;
}
@end
