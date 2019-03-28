//
//  CandyViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/26.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CandyViewController.h"
#import "JXCategoryView.h"
#import "CandyTable/CandyTableViewController.h"

@interface CandyViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *titleView;
@property (weak, nonatomic) IBOutlet JXCategoryListContainerView *listView;

@end

@implementation CandyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCategoryView];
}

- (void)configCategoryView{
    _titleView.titles = @[@"Following",@"Recommend",@"News"];
    _titleView.delegate = self;
    _titleView.titleColor = [UIColor whiteColor];
    _titleView.titleSelectedColor = [UIColor whiteColor];
    _titleView.titleColorGradientEnabled = YES;
    _titleView.titleFont = [UIFont boldSystemFontOfSize:14];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor whiteColor];
    lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    _titleView.indicators = @[lineView];
    
    [_listView configWithDelegate:self];
    _titleView.contentScrollView = _listView.scrollView;
}


#pragma mark - categoryViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 3;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    CandyTableViewController *tableview = [[CandyTableViewController alloc]init];
    
    return tableview;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}
@end
