//
//  NotConnectView.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "NotConnectView.h"

@implementation NotConnectView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"NotConnectView" owner:self options:nil]firstObject];
        [self addSubview:view];
    }
    return self;
}
@end

