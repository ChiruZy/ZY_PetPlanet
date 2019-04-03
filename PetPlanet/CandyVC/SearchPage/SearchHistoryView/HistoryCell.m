//
//  HistoryCell.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/4.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "HistoryCell.h"

@interface HistoryCell()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (NSString *)title{
    return _label.text;
}

- (void)setTitle:(NSString *)title{
    _label.text = title;
}

- (UICollectionViewLayoutAttributes *)
        preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes =
                                    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    NSDictionary *attrs = @{NSFontAttributeName :_label.font};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    CGRect frame = [_label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 24) options:options attributes:attrs context:nil];
    
    frame.size.width +=24;
    frame.size.height = 24;
    attributes.frame = frame;
    return attributes;
}


@end
