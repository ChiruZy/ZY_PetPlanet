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

+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|7[56]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if(([regextestmobile evaluateWithObject:cellNum] == YES)
       || ([regextestcm evaluateWithObject:cellNum] == YES)
       || ([regextestct evaluateWithObject:cellNum] == YES)
       || ([regextestcu evaluateWithObject:cellNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)getDataStringWithTimeInterval:(NSTimeInterval)timeInterval{
    NSTimeInterval currentTime = [[NSDate date]timeIntervalSince1970];
    NSUInteger realTime = timeInterval/1000;
    NSUInteger time = currentTime - realTime;
    
    if (time < 60) {
        return @"just now";
    }
    time /= 60;
    if (time<60) {
        NSString *minute = time==1?@"minute ago":@"minutes ago";
        return [NSString stringWithFormat:@"%ld %@",time,minute];
    }
    time /= 60;
    if (time<24) {
        NSString *hour = time==1?@"hour ago":@"hours ago";
        return [NSString stringWithFormat:@"%ld %@",time,hour];
    }
    time /= 24;
    if (time<4) {
        NSString *day = time==1?@"day ago":@"days ago";
        return [NSString stringWithFormat:@"%ld %@",time,day];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSString *fullTimeString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:realTime]];
    return fullTimeString;
}

+ (NSString *)getFullDataStringWithTimeInterval:(NSTimeInterval)timeInterval{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
@end
