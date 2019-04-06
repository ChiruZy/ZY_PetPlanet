//
//  HistoryLayout.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "HistoryLayout.h"

@implementation HistoryLayout


- (void)awakeFromNib{
    [super awakeFromNib];
    self.minimumLineSpacing = 11;
    self.minimumInteritemSpacing = 13;
    self.estimatedItemSize = CGSizeMake(60, 24);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    if (answer.count == 1) {
        UICollectionViewLayoutAttributes *attribute = answer[0];
        CGRect frame = attribute.frame;
        frame.origin.x = 0;
        attribute.frame = frame;
        return answer;
    }
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        if([currentLayoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
            continue;
        }

        NSInteger preX = CGRectGetMaxX(prevLayoutAttributes.frame);
        NSInteger preY = CGRectGetMaxY(prevLayoutAttributes.frame);
        NSInteger curY = CGRectGetMaxY(currentLayoutAttributes.frame);
        NSInteger maximumSpacing = 13;
        if(preY == curY){
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = preX + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}

@end
