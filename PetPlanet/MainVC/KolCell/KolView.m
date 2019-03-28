//
//  KolView.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/27.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "KolView.h"


@implementation KolView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"KolView" owner:self options:nil]firstObject];
        [self addSubview:view];
    }
    return self;
}

@end
