//
//  SearchViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "SearchViewController.h"
#import "HistoryDelegate.h"
#import "HotDelegate.h"

@interface SearchViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UICollectionView *history;
@property (weak, nonatomic) IBOutlet UICollectionView *hot;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (nonatomic,strong) HistoryDelegate *historyDelegate;
@property (nonatomic,strong) HotDelegate *hotDelegate;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchField.delegate = self;
    [_cancel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self configHistory];
}

- (void)configHistory{
     __weak typeof(self) weakSelf = self;
    
    [[NSUserDefaults standardUserDefaults] setObject:@[@"sddsd",@"dsddddd"] forKey:@"search_history"];
    
    _historyDelegate = [[HistoryDelegate alloc]initWithNeedRefreshBlock:^(BOOL flag) {
        weakSelf.historyView.hidden = !flag;
        [weakSelf.history reloadData];
    }];
    _historyDelegate.block = ^(NSString * _Nullable content) {
        weakSelf.searchField.text = content;
    };
    _history.delegate = _historyDelegate;
    _history.dataSource = _historyDelegate;
    [_history registerNib:[UINib nibWithNibName:@"HistoryCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryCell"];
    
    _hotDelegate = [HotDelegate new];
    _hotDelegate.block = ^(NSString * _Nullable content) {
        weakSelf.searchField.text = content;
    };
    _hotDelegate.noData = ^{
        weakSelf.hotView.hidden = YES;
    };
    _hot.delegate = _hotDelegate;
    _hot.dataSource = _hotDelegate;
    [_hot registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellWithReuseIdentifier:@"HotCell"];
}

- (void)back{
    [self.navigationController popViewControllerAnimated: YES];
}

@end
