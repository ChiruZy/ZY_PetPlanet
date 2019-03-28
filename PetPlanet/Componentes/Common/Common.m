//
//  Common.m
//  KidsPact
//
//  Created by Overloop on 2019/2/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (BOOL)isIPX{
    if(@available(iOS 11.0,*)){
        CGFloat bottom = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        if (bottom > 0) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

+(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
