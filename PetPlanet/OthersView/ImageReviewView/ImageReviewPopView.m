//
//  ImageReviewPopView.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ImageReviewPopView.h"
#import "Common.h"

@interface ImageReviewPopView ()
@property (weak, nonatomic) IBOutlet UIView *downloadView;
@property (weak, nonatomic) IBOutlet UIView *originImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originImageViewHeight;

@end

@implementation ImageReviewPopView

- (void)awakeFromNib{
    [super awakeFromNib];
    CGRect frame = self.frame;
    if (IS_IPX) {
        frame.size.height += 44;
    }else{
        frame.size.height += 8;
    }
    self.frame = frame;
}

- (void)addTarget:(id)target download:(nullable SEL)download originImage:(nullable SEL)originImage{
    
    UITapGestureRecognizer *tapDownload = [[UITapGestureRecognizer alloc]initWithTarget:target action:download];
    UITapGestureRecognizer *tapOriginImage = [[UITapGestureRecognizer alloc]initWithTarget:target action:originImage];
    
    [_downloadView addGestureRecognizer:tapDownload];
    [_originImageView addGestureRecognizer:tapOriginImage];
    
    _downloadView.userInteractionEnabled = YES;
    _originImageView.userInteractionEnabled = YES;
    
}

- (void)RemoveOriginImageView{
    _originImageViewHeight.constant = 0;
    _originImageView.hidden = YES;
    CGRect frame = self.frame;
    frame.size.height -= 60;
    self.frame = frame;
}
@end
