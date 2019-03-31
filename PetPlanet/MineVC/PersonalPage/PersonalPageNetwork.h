//
//  PersonalPageNetwork.h
//  PetPlanet
//
//  Created by Overloop on 2019/3/31.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoCell.h"

NS_ASSUME_NONNULL_BEGIN

/* ERROR NUMBER
 10 Compelet
 11 Wrong Response
 12 Connect fail
 16 Candy Networking Buzy
 */

typedef void(^Complete)(void);
typedef void(^Fail)(NSString *error);

@interface PersonalPageNetwork : NSObject

@property (nonatomic,strong,readonly) NSDictionary *personal;

@property (nonatomic,strong,readonly) NSArray<PhotoModel *> *photos;

@property (nonatomic,assign,readonly) BOOL loadComplete;

- (void)loadWithUid:(NSString *)uid complete:(Complete)complete fail:(Fail)fail;

@end

NS_ASSUME_NONNULL_END
