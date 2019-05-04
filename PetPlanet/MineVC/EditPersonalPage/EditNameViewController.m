//
//  EditNameViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/4/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "EditNameViewController.h"
#import "ZYSVPManager.h"


@interface EditNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (nonatomic,strong) NSString *oldName;


@end

@implementation EditNameViewController

- (instancetype)initWithString:(NSString *)string{
    if (self = [super init]) {
        _oldName = string;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"Edit Name";
    _name.text = _oldName;
    [_name becomeFirstResponder];
    _name.delegate = self;
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"publish"] style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[fix,save];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[backItem];
}

- (void)save{
    if (_name.text.length == 0) {
        [ZYSVPManager showText:@"Null Name" autoClose:1.5];
        return;
    }
    NSRange range = [_name.text rangeOfString:@" "];
    if (range.location != NSNotFound) {
        [ZYSVPManager showText:@"Can't Have Space" autoClose:1.5];
        return;
    }
    
    if (_block) {
        _block(_name.text);
    }
    [self back];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *newStr = [NSMutableString stringWithString:textField.text];
    [newStr replaceCharactersInRange:range withString:string];
    if (newStr.length < 18) {
        return YES;
    }
    return NO;
}


@end
