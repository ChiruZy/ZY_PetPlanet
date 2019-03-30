//
//  Common.h
//  KidsPact
//
//  Created by Overloop on 2019/2/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define IS_IPX [Common isIPX]
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)objectAtIndex:0]

#pragma mark - test

#define IS_LOGIN NO
#define UID @"123456"

NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject

+ (BOOL)isIPX;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum;

+ (NSString *)getDataStringWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)getFullDataStringWithTimeInterval:(NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END
