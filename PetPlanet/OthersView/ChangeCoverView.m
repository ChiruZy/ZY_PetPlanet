//
//  ChangeCoverView.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ChangeCoverView.h"

@interface ChangeCoverView()

@property (weak, nonatomic) IBOutlet UIView *localUpload;
@property (weak, nonatomic) IBOutlet UIView *takePhotos;

@end

@implementation ChangeCoverView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *local = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(localUploadEvent)];
    _localUpload.userInteractionEnabled = YES;
    [_localUpload addGestureRecognizer:local];
    
    UITapGestureRecognizer *photo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotosEvent)];
    _takePhotos.userInteractionEnabled = YES;
    [_takePhotos addGestureRecognizer:photo];
}

- (void)localUploadEvent{
    if (_local) {
        _local();
    }
}

- (void)takePhotosEvent{
    if (_photo) {
        _photo();
    }
}

@end
