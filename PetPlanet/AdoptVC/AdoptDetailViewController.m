//
//  AdoptDetailViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/25.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "AdoptDetailViewController.h"
#import <UIImageView+WebCache.h>
#import "ConversationViewController.h"
#import <AFNetworking.h>
#import "ZYSVPManager.h"
#import "CreateAdoptViewController.h"
#import "MyAdoptViewController.h"

@interface AdoptDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *message;
@property (weak, nonatomic) IBOutlet UIButton *delete;

@property (nonatomic,strong) AdoptModel *model;
@end

@implementation AdoptDetailViewController

- (instancetype)initWithModel:(AdoptModel *)model{
    if (!model) {
        return nil;
    }
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:_model.image];
    if (url) {
        [_image sd_setImageWithURL:url];
    }
    _name.text = _model.name;
    _content.text = _model.content;
    
    if ([_model.uid isEqualToString:[ZYUserManager shareInstance].userID]) {
        [_message addTarget:self action:@selector(editEvent) forControlEvents:UIControlEventTouchUpInside];
        [_message setImage:[UIImage imageNamed:@"adopt_edit"] forState:UIControlStateNormal];
        _delete.hidden = NO;
        [_delete addTarget:self action:@selector(deleteEvent) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_message addTarget:self action:@selector(messageEvent) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)editEvent{
    CreateAdoptViewController *editVC = [[CreateAdoptViewController alloc]initWithAdoptModel:_model];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)messageEvent{
    __weak typeof(self) weakSelf = self;
    __block BOOL flag = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ConversationViewController class]]) {
            ConversationViewController *controller = obj;
            if ([controller.targetId isEqualToString: weakSelf.model.uid]) {
                [weakSelf.navigationController popToViewController:obj animated:YES];
                flag = YES;
                *stop = YES;
                return;
            }
        }
    }];
    if (!flag) {
        ConversationViewController *conversationVC = [[ConversationViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:weakSelf.model.uid];
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

- (void)deleteEvent{
    NSString *url = @"http://106.14.174.39/pet/adopt/delete_adopt.php";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 8;
    manager.requestSerializer.timeoutInterval = 8;
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:@{@"aid":_model.aid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            if ([error isEqualToString:@"10"]) {
                [weakSelf popToList];
                return;
            }
        }
        [ZYSVPManager showText:@"Delete Failed" autoClose:1.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZYSVPManager showText:@"Delete Failed" autoClose:1.5];
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
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
