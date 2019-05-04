//
//  ConversationViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/8.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ConversationViewController.h"
#import "Common.h"
#import "PersonalViewController.h"
#import "ZYUserManager.h"
#import <AFNetworking.h>

@interface ConversationViewController ()

@end

@implementation ConversationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled  = YES;
    self.enableUnreadMessageIcon = YES;
    //self.displayUserNameInCell = NO;
    
    if (self.navigationController.viewControllers.count>1) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemEvent)];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = @[backItem];
    }
    self.view.backgroundColor = HEXCOLOR(0xF9F9F9);
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    
    if (self.navigationItem.title.length == 0) {
        [self getName];
    }
}

- (void)getName{
    NSString *url = @"http://106.14.174.39/pet/user/get_name.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:@{@"uid":self.targetId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                weakSelf.navigationItem.title = responseObject[@"name"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)backItemEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL result = NO;
    if( gestureRecognizer == self.navigationController.interactivePopGestureRecognizer ){
        if(self.navigationController.viewControllers.count >= 2){
            result = YES;
        }
    }
    return result;
}

- (void)didTapCellPortrait:(NSString *)userId{
    __weak typeof(self) weakSelf = self;
    __block BOOL flag = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PersonalViewController class]]) {
            PersonalViewController *controller = obj;
            if ([controller.uid isEqualToString: userId]) {
                [weakSelf.navigationController popToViewController:obj animated:YES];
                flag = YES;
                *stop = YES;
                return;
            }
        }
    }];
    if (!flag) {
        PersonalViewController *personalVC = [[PersonalViewController alloc]initWithUserID:userId];
        [self.navigationController pushViewController:personalVC animated:YES];
    }  
}
@end
