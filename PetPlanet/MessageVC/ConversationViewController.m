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
    PersonalViewController *personalVC = [[PersonalViewController alloc]initWithUserID:userId];
    [self.navigationController pushViewController:personalVC animated:YES];
}
@end
