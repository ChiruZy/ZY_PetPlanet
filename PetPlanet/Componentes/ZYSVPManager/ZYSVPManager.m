//
//  ZYSVPManager.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ZYSVPManager.h"
#import <SVProgressHUD.h>
#import "Common.h"

@implementation ZYSVPManager

+ (BOOL)isVisible{
    return [SVProgressHUD isVisible];
}

+ (void)configWithSVP{
    [SVProgressHUD setBackgroundColor: HEXCOLOR(0x8D8CC6)];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setMinimumSize:CGSizeMake(200, 60)];
    [SVProgressHUD setFont:[UIFont boldSystemFontOfSize:18]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

+ (void)showText:(NSString *)text autoClose:(NSTimeInterval)time{
    [self configWithSVP];
    [SVProgressHUD showImage:nil status:text];
    [SVProgressHUD dismissWithDelay:time];
}
@end
