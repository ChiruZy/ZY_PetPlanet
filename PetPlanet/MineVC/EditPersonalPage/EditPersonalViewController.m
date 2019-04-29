//
//  EditPersonalViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "EditPersonalViewController.h"
#import "HintView.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "ZYBaseViewController+ImagePicker.h"
#import "EditNameViewController.h"
#import "ZYSVPManager.h"

@interface EditPersonalViewController ()
@property (weak, nonatomic) IBOutlet HintView *hintView;
@property (weak, nonatomic) IBOutlet UILabel *uid;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *sex;
@property (weak, nonatomic) IBOutlet UIImageView *head;

@property (nonatomic,assign) BOOL isMale;
@property (nonatomic,strong) NSData *headData;
@property (nonatomic,strong) complete block;
@end

@implementation EditPersonalViewController

- (instancetype)initWithCompleteBlock:(complete)block{
    if (self = [super init]) {
        _block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"Edit";
    [_hintView setType:HintWaitType needButton:NO];
    __weak typeof(self) weakSelf = self;
    _hintView.refresh = ^{
        [weakSelf getPersonalData];
    };
    [weakSelf.hintView moveY:-40];
    [self getPersonalData];
}

- (void)configWithDic:(NSDictionary *)dic{
    NSString *image = dic[@"head"];
    if (image.length>0) {
        [_head sd_setImageWithURL:[NSURL URLWithString:image]];
    }
    
    NSString *sex = dic[@"sex"];
    if ([sex isEqualToString:@"1"]) {
        [_sex setTitle:@"Male" forState:UIControlStateNormal];
        _isMale = YES;
    }else{
        [_sex setTitle:@"Female" forState:UIControlStateNormal];
        _isMale = NO;
    }
    
    _name.text = dic[@"name"];
    _uid.text = dic[@"uid"];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
    [_head addGestureRecognizer:tapImage];
    _head.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapName = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapName)];
    [_nameView addGestureRecognizer:tapName];
    _nameView.userInteractionEnabled = YES;
    
    [_sex addTarget:self action:@selector(tapSex) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapImage{
    __weak typeof(self) weakSelf = self;
    [self pickImageWithpickImageCutImageWithImageSize:CGSizeMake(500, 500) CompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
        weakSelf.head.image = image;
        weakSelf.headData = imageData;
    }];
}

- (void)tapName{
    EditNameViewController *editName = [[EditNameViewController alloc]initWithString:_name.text];
    __weak typeof(self) weakSelf = self;
    editName.block = ^(NSString * string){
        weakSelf.name.text = string;
    };
    [self.navigationController pushViewController:editName animated:YES];
}

- (void)tapSex{
    _isMale = !_isMale;
    [_sex setTitle:_isMale?@"Male":@"Female" forState:UIControlStateNormal];
}

- (void)getPersonalData{
    NSString *url = @"http://106.14.174.39/pet/user/get_personal_data.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:@{@"uid":[ZYUserManager shareInstance].userID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                [weakSelf configWithDic:responseObject[@"items"]];
                [weakSelf.hintView setType:HintHiddenType needButton:NO];
                return;
            }
        }
        [weakSelf.hintView setType:HintNoConnectType needButton:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.hintView setType:HintNoConnectType needButton:YES];
    }];
}
- (IBAction)save:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *url = @"http://106.14.174.39/pet/user/update_personal_data.php";
    
    __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:@{@"uid":[ZYUserManager shareInstance].userID,
                                   @"name":_name.text,
                                   @"sex":_isMale?@"1":@"0"}
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (weakSelf.headData) {
            [formData appendPartWithFileData:weakSelf.headData name:@"head" fileName:@"uploadImage" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                [[ZYUserManager shareInstance]updateUserInfo];
                if (weakSelf.block) {
                    weakSelf.block();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
        [ZYSVPManager showText:@"Failed" autoClose:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Failed" autoClose:1.5];
    }];
}
@end
