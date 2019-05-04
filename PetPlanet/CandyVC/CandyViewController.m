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
#import "CommentPage/CommentViewController.h"
#import "SearchPage/SearchViewController.h"
#import "NewCandy/NewCandyController.h"

@interface CandyViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *titleView;
@property (weak, nonatomic) IBOutlet JXCategoryListContainerView *listView;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *addCandy;

@end

@implementation CandyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCategoryView];
    
    [_commentButton addTarget:self action:@selector(gotoCommentPage) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapSearch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoSearchPage)];
    [_searchView addGestureRecognizer:tapSearch];
    _searchView.userInteractionEnabled = YES;
    [_addCandy addTarget: self action:@selector(newCandy) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configCategoryView{
    _titleView.titles = @[@"Popular",@"Newest",@"Following"];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _addCandy.hidden = ![ZYUserManager shareInstance].isLogin;
}

- (void)newCandy{
    NewCandyController *new = [NewCandyController new];
    [self.navigationController pushViewController:new animated:YES];
}

- (void)gotoCommentPage{
    CommentViewController *commentVC = [CommentViewController new];
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)gotoSearchPage{
    SearchViewController *searchVC = [SearchViewController new];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - categoryViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 3;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    CandyTableViewController *tableview;
    if (index == 2) {
        tableview = [[CandyTableViewController alloc]initWithCandyListType:CandyListFollowingType superView:self];
    }else if (index == 0){
        tableview = [[CandyTableViewController alloc]initWithCandyListType:CandyListRecommendType superView:self];
    }else if (index == 1){
        tableview = [[CandyTableViewController alloc]initWithCandyListType:CandyListNewsType superView:self];
    }
    return tableview;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}
@end
