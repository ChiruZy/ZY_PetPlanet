//
//  CandyDetailModel.h
//  PetPlanet
//
//  Created by Overloop on 2019/5/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface CandyDetailModel : NSObject<YYModel>

@property NSString *uid;
@property NSString *name;
@property NSString *head;
@property NSString *smallImage;
@property NSString *image;
@property NSString *time;
@property NSString *content;
@property NSString *like;
@property NSString *isLike;
@property NSString *isCollection;
@property NSString *comments;

@end

@interface CandyReplyModel : NSObject<YYModel>

@property NSString *rid;
@property NSString *name;
@property NSString *head;
@property NSString *content;
@property NSString *time;
@property NSString *uid;

@end

NS_ASSUME_NONNULL_END
