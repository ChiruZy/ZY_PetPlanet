//
//  ZYSVPManager.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYSVPManager : NSObject
+ (BOOL)isVisible;
+ (void)configWithSVP;
+ (void)showText:(NSString *)text autoClose:(NSTimeInterval)time;
@end

NS_ASSUME_NONNULL_END
