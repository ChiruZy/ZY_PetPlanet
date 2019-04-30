//
//  ZYBaseViewController+ImagePicker.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/24.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYBaseViewController+ImagePicker.h"
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "ZYPopView.h"
#import "ChangeCoverView.h"

static void *kImagePickerCompletionHandlerKey = @"kImagePickerCompletionHandlerKey";
static void *kCameraPickerKey = @"kCameraPickerKey";
static void *kPhotoLibraryPickerKey = @"kPhotoLibraryPickerKey";
static void *kImageSizeKey = @"kimageSizeKey";
static void *isCut =  @"isCut"; //截取

@interface ZYBaseViewController()

@property (nonatomic, strong) UIImagePickerController *cameraPicker;
@property (nonatomic, strong) UIImagePickerController *photoLibraryPicker;
@property (nonatomic, copy) ImagePickerCompletionHandler completionHandler;

@property (nonatomic, assign) BOOL isCutImageBool;
@property (nonatomic, assign) CGSize imageSize;


@end

@implementation ZYBaseViewController (ImagePicker)

- (void)pickImageWithCompletionHandler:(ImagePickerCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    [self presentChoseActionSheet];
}


- (void)pickImageWithpickImageCutImageWithImageSize:(CGSize)imageSize CompletionHandler:(ImagePickerCompletionHandler)completionHandler
{
    self.completionHandler = completionHandler;
    self.isCutImageBool = YES;
    self.imageSize = imageSize;
    [self presentChoseActionSheet];
}

- (void)setUpCameraPickControllerIsEdit:(BOOL)isEdit {
    self.cameraPicker = [[UIImagePickerController alloc] init];
    self.cameraPicker.allowsEditing = isEdit; //拍照选去是否可以截取，和代理中的获取截取后的方法配合使用
    self.cameraPicker.delegate = self;
    self.cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
}

- (void)setUpPhotoPickControllerIsEdit:(BOOL)isEdit {
    self.photoLibraryPicker = [[UIImagePickerController alloc] init];
    self.photoLibraryPicker.allowsEditing = isEdit; // 相册选取是否截图
    self.photoLibraryPicker.delegate = self;
    //去掉毛玻璃效果 否则在ios11 下 全局设置了UIScrollViewContentInsetAdjustmentNever 导致导航栏遮住了内容视图
    self.photoLibraryPicker.navigationBar.translucent = NO;
    self.photoLibraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (void)presentChoseActionSheet {
    
    //先创建好 不然调用的时候 第一次创建很慢 有2秒的延迟
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //判断相机可用
        [self setUpCameraPickControllerIsEdit:self.isCutImageBool];
    }
    [self setUpPhotoPickControllerIsEdit:self.isCutImageBool];
    
    ChangeCoverView *coverView = [[[NSBundle mainBundle] loadNibNamed:@"ChangeCoverView" owner:nil options:nil]firstObject];
    ZYPopView *pop = [[ZYPopView alloc]initWithContentView:coverView type:ZYPopViewBlurType];
    __weak typeof(self) weakSelf = self;
    coverView.photo = ^{
        [pop dismiss];
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [weakSelf presentViewController:weakSelf.cameraPicker animated:YES completion:nil];
                }
                else {
                    UIAlertController * noticeAlertController = [UIAlertController alertControllerWithTitle:@"Camera permissions are not enabled. Please open it on the Settings screen" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    }];
                    [noticeAlertController addAction:cancelAction];
                    [noticeAlertController addAction:okAction];
                    [weakSelf presentViewController:noticeAlertController animated:YES completion:nil];
                }
            });
        }];
    };
    coverView.local = ^{
        [pop dismiss];
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
                    [self presentViewController:weakSelf.photoLibraryPicker animated:YES completion:nil];
                }
                else {
                    UIAlertController * noticeAlertController = [UIAlertController alertControllerWithTitle:@"The album permissions are not open. Please open it in the Settings screen" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                    
                    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    }];
                    [noticeAlertController addAction:cancelAction];
                    [noticeAlertController addAction:okAction];
                    [weakSelf presentViewController:noticeAlertController animated:YES completion:nil];
                }
            });
        }];
    };
    [pop show];
}

#pragma mark <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editedimage = [[UIImage alloc] init];
    if(self.isCutImageBool){
        //获取裁剪的图
        editedimage = info[@"UIImagePickerControllerEditedImage"]; //获取裁剪的图
        CGSize imageSize = CGSizeMake(413, 626);
        if (self.imageSize.height>0) {
            imageSize = self.imageSize;
        }
        editedimage = [self reSizeImage:editedimage toSize:imageSize];
    }
    else{
        editedimage = info[@"UIImagePickerControllerOriginalImage"];
    }
    NSData *imageData = UIImageJPEGRepresentation(editedimage, 0.0001);//首次进行压缩
    UIImage *image = [UIImage imageWithData:imageData];
    //图片限制大小不超过 1M     CGFloat  kb =   data.lenth / 1000;  计算kb方法 os 按照千进制计算
    while (imageData.length/1000 > 1024) {
        NSLog(@"图片超过1M 压缩");
        imageData = UIImageJPEGRepresentation(image, 0.5);
        image = [UIImage imageWithData:imageData];
    }
    NSData *originData = UIImageJPEGRepresentation(editedimage, 1);
    self.completionHandler(imageData,originData,image);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#pragma mark - setters & getters

- (void)setCompletionHandler:(ImagePickerCompletionHandler)completionHandler {
    objc_setAssociatedObject(self, kImagePickerCompletionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
}

- (ImagePickerCompletionHandler)completionHandler {
    return objc_getAssociatedObject(self, kImagePickerCompletionHandlerKey);
}

- (void)setCameraPicker:(UIImagePickerController *)cameraPicker {
    objc_setAssociatedObject(self, kCameraPickerKey, cameraPicker, OBJC_ASSOCIATION_RETAIN);
}

- (UIImagePickerController *)cameraPicker {
    return objc_getAssociatedObject(self, kCameraPickerKey);;
}

- (void)setPhotoLibraryPicker:(UIImagePickerController *)photoLibraryPicker {
    objc_setAssociatedObject(self, kPhotoLibraryPickerKey, photoLibraryPicker, OBJC_ASSOCIATION_RETAIN);
}

- (UIImagePickerController *)photoLibraryPicker {
    return objc_getAssociatedObject(self, kPhotoLibraryPickerKey);
}

- (void)setIsCutImageBool:(BOOL)isCutImageBool {
    return objc_setAssociatedObject(self, isCut, @(isCutImageBool), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isCutImageBool {
    return [objc_getAssociatedObject(self, isCut) boolValue];
}

- (void)setImageSize:(CGSize)imageSize {
    return objc_setAssociatedObject(self, kImageSizeKey, [NSValue valueWithCGSize:imageSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)imageSize {
    NSValue * value = objc_getAssociatedObject(self, kImageSizeKey);
    return  value.CGSizeValue;
}

@end
