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

NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject

+ (BOOL)isIPX;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum;

+ (NSString *)getDateStringWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)getFullDateStringWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)getDateStringWithTimeString:(NSString *)timeString;

+ (NSString *)getFullDateStringWithTimeString:(NSString *)timeString;

+ (NSArray *)getUFOImage;

@end

NS_ASSUME_NONNULL_END
