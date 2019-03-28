//
//  PopularCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "PopularCell.h"
#import "Common.h"

@implementation PopularModel

+ (instancetype)createWithImageURL:(NSString *)url moodID:(NSUInteger)mid{
    PopularModel *model = [PopularModel new];
    // model.image =
    model.moodID = mid;
    
    return model;
}

@end

@interface PopularCell ()

@property (nonatomic,strong) NSArray *populars;
@property (weak, nonatomic) IBOutlet UIImageView *all;

@end

@implementation PopularCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadSubviews];
}


- (void)loadSubviews{
    NSArray *colorArr = @[HEXCOLOR(0xFFF6B5),HEXCOLOR(0xB4DEFE),
                          HEXCOLOR(0xF9BADA),HEXCOLOR(0xB0EDCF)];
    NSMutableArray *populars = [NSMutableArray new];
    for (int i = 0;i < 4; i++) {
        UIImageView *imageView = [self viewWithTag:1010 +i];
        [populars addObject:imageView];
        imageView.image = [Common imageWithColor:colorArr[i]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
    }
    _populars = populars;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAll:)];
    [_all addGestureRecognizer:tap];
    _all.userInteractionEnabled = YES;
}

- (void)setModels:(NSArray<PopularModel *> *)models{
    _models = models;
    
    [_populars enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > models.count-1) {
            *stop = YES;
            return ;
        }
        UIImageView *imageView = obj;
        PopularModel *model = models[idx];
        imageView.image = model.image;
    }];
}

- (void)tapImageView:(UITapGestureRecognizer *)sender{
    UIImageView *view = (UIImageView *)sender.view;
    NSUInteger index = view.tag - 1010;
    if (_popularBlock && index <= _models.count -1) {
        _popularBlock(_models[index]);
    }
}

- (void)tapAll:(UITapGestureRecognizer *)sender{
    if (_allBlock) {
        _allBlock();
    }
}

@end
