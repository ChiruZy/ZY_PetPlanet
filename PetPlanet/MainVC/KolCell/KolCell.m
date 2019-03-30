//
//  KolCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "KolCell.h"
#import "KolView.h"
#import "Common.h"

@implementation KolModel

+ (instancetype)createWithImageURL:(NSString *)url name:(NSString *)name userID:(NSUInteger)userID{
    KolModel *model = [KolModel new];
    // model.image =
    model.name = name;
    model.userID = userID;
    
    return model;
}

@end


@interface KolCell()

@property (nonatomic,strong) NSArray *kolArray;
@property (weak, nonatomic) IBOutlet UIImageView *allButton;

@end

@implementation KolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self loadSubviews];
}

- (void)loadSubviews{
    NSArray *colorArr = @[HEXCOLOR(0xFFF6B5),HEXCOLOR(0xB4DEFE),HEXCOLOR(0xF9BADA),HEXCOLOR(0xB0EDCF)];
    NSMutableArray *kols = [NSMutableArray new];
    for (int i = 0;i < 4; i++) {
        KolView *kol = [self viewWithTag:1000 +i];
        [kols addObject:kol];
        kol.imageView.image = [Common imageWithColor:colorArr[i]];
        kol.label.text = @"wait";
        kol.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapKolView:)];
        [kol addGestureRecognizer:tap];
    }
    _kolArray = kols.copy;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAll:)];
    [_allButton addGestureRecognizer:tap];
    _allButton.userInteractionEnabled = YES;
}

- (void)setModels:(NSArray<KolModel *> *)models{
    _models = models;
    
    [_kolArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > models.count-1) {
            *stop = YES;
            return ;
        }
        KolView *view = obj;
        KolModel *model = models[idx];
        view.label.text = model.name;
        view.imageView.image = model.image;
    }];
}

- (void)tapKolView:(UITapGestureRecognizer *)sender{
    KolView *view = (KolView *)sender.view;
    NSUInteger index = view.tag - 1000;
    if (_kolBlock && index <= _models.count -1) {
        _kolBlock(_models[index]);
    }
}

- (void)tapAll:(UITapGestureRecognizer *)sender{
    if (_allBlock) {
        _allBlock();
    }
}
@end
