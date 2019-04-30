//
//  ChooseView.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/30.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "ChooseView.h"

@interface ChooseView()
@end

@implementation ChooseView

- (IBAction)yesEvent:(id)sender {
    if (_yesEvent) {
        _yesEvent();
    }
}
- (IBAction)cancelEvent:(id)sender {
    if (_cancelEvent) {
        _cancelEvent();
    }
}

@end
