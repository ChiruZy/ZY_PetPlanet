//
//  PhotoLayout.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/14.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "PhotoLayout.h"
#import "Common.h"



@interface PhotoLayout()
@property(nonatomic,strong)NSMutableArray* colsHeight;
@property(nonatomic,assign)CGFloat colWidth;
@property (nonatomic,strong) HeightBlock heightBlock;
@end

@implementation PhotoLayout

- (instancetype)initWithHeightBlock:(HeightBlock)heightBlock{
    if (self = [super init]) {
        _heightBlock = heightBlock;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.colWidth =( self.collectionView.frame.size.width - (colCount+1)*colMargin )/colCount;
    self.colsHeight = nil;
}

- (CGSize)collectionViewContentSize{
    NSNumber * longest = self.colsHeight[0];
    for (NSInteger i =0;i<self.colsHeight.count;i++) {
        NSNumber* rolHeight = self.colsHeight[i];
        if(longest.floatValue<rolHeight.floatValue){
            longest = rolHeight;
        }
    }
    CGSize size = CGSizeMake(self.collectionView.frame.size.width, longest.floatValue);
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber * shortest = self.colsHeight[0];
    
    if (indexPath.row == 0 && shortest.intValue != 40) {
        _colsHeight = nil;
        shortest = self.colsHeight[0];
    }
    
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger  shortCol = 0;
    for (NSInteger i =0;i<self.colsHeight.count;i++) {
        NSNumber* rolHeight = self.colsHeight[i];
        if(shortest.floatValue>rolHeight.floatValue){
            shortest = rolHeight;
            shortCol=i;
        }
    }
    
    CGFloat x = (shortCol+1)*colMargin+ shortCol * self.colWidth;
    CGFloat y = shortest.floatValue+colMargin;
    
    CGFloat height=0;
    if(_heightBlock){
        height = _heightBlock(indexPath);
    }
    attr.frame= CGRectMake(x, y, self.colWidth, height);
    self.colsHeight[shortCol]=@(shortest.floatValue+colMargin+height);
    
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* array = [NSMutableArray array];
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<items;i++) {
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attr];
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(NSMutableArray *)colsHeight{
    if(!_colsHeight){
        NSMutableArray * array = [NSMutableArray array];
        for(int i =0;i<colCount;i++){
            [array addObject:@(topMargin)];
        }
        _colsHeight = [array mutableCopy];
    }
    return _colsHeight;
}

@end
