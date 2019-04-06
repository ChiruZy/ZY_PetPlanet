//
//  HistoryDelegate.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "HistoryDelegate.h"
#import "HistoryCell.h"

#define HistoryKey @"search_history"

@interface HistoryDelegate()

@property (nonatomic,strong) NSMutableArray *model;

@property (nonatomic,strong) EventWithBool needRefresh;

@end

@implementation HistoryDelegate

- (instancetype)initWithNeedRefreshBlock:(EventWithBool)needRefresh{
    if (self = [super init]) {
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:HistoryKey];
        _model = arr.mutableCopy;
        if (!_model) {
            _model = [NSMutableArray new];
        }
        
        _needRefresh = needRefresh;
        if (_needRefresh) {
            _needRefresh(arr.count>0);
        }
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCell" forIndexPath:indexPath];
    [cell setTitle:_model[indexPath.row]];
    return cell;
}

- (void)setObjectToHistory:(NSString *)str{
    __weak typeof(self) weakSelf = self;
    [_model insertObject:str atIndex:0];
    [_model enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *history = obj;
        if (idx == 0) {
            return;
        }
        if ([str isEqualToString:history]) {
            [weakSelf.model removeObjectAtIndex:idx];
        }
    }];
    
    if (_model.count>10) {
        _model = [_model subarrayWithRange:NSMakeRange(0, 10)].mutableCopy;
    }
    [[NSUserDefaults standardUserDefaults] setObject:_model.copy forKey:HistoryKey];
    
    if (_needRefresh) {
        _needRefresh(_model.count>0);
    }
}

- (void)removeHistory{
    _model = [NSMutableArray new];
    [[NSUserDefaults standardUserDefaults] setObject:_model.copy forKey:HistoryKey];
    if (_needRefresh) {
        _needRefresh(NO);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HistoryCell *cell = (HistoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self setObjectToHistory:cell.title];
    if (_block) {
        _block(cell.title);
    }
}
@end
