//
//  WelcomeViewController.m
//  KidsPact
//
//  Created by Overloop on 2019/2/28.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AnimateView/WelcomeAnimateView.h"
#import "Common.h"
#import <EllipsePageControl/EllipsePageControl.h>
#import "ZYTabBarController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) EllipsePageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *views;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,assign) NSUInteger pageNumber;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _views = [NSMutableArray new];
    _scrollView.delegate = self;
    _pageNumber = 0;
    
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.button];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self configScrollView];
    [self configSubviews];
}

- (void)viewDidAppear:(BOOL)animated{
    WelcomeAnimateView *welcomeView = _views[0];
    [welcomeView labelAnimate];
}
#pragma mark - private method
- (void)configSubviews{
    _pageControl.frame = CGRectMake((self.view.bounds.size.width - 60)/2, self.view.bounds.size.height - Screen_Height/7, 60, 18);
    _button.frame = CGRectMake((self.view.bounds.size.width - 200)/2, self.view.bounds.size.height - Screen_Height/7-10, 200, 50);
}

- (void)configScrollView{
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*3, _scrollView.bounds.size.height);
    
    NSArray *titleArray = @[@"Report",
                            @"Adopt",
                            @"Share"];
    NSArray *summaryArray = @[@"write a infomation report to owner ",
                              @"adopt you like pet is very easy",
                              @"anytime  share your pet anywhere "];
    
    for (int i = 0; i<3; i++) {
        NSArray *objs = [[NSBundle mainBundle]loadNibNamed:@"WelcomeAnimateView" owner:nil options:nil];
        WelcomeAnimateView *welcomeView = objs.firstObject;
        welcomeView.frame = CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [welcomeView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcomeImg%d",i]] title:titleArray[i] summary:summaryArray[i]];
        [_views addObject:welcomeView];
        [_scrollView addSubview:welcomeView];
    }
}
#pragma mark - scrollView delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    // 如果回弹就返回
    if (targetContentOffset->x /_scrollView.bounds.size.width == _pageNumber) {
        return;
    }
    
    scrollView.scrollEnabled = NO;
    __weak typeof(self) weakSelf = self;
    if (_pageNumber < targetContentOffset->x /_scrollView.bounds.size.width) {
        WelcomeAnimateView *welcomeView = _views[++_pageNumber];
        [welcomeView startAnimateWithDirection:WAViewDirectionRight Completion:^{
            WelcomeAnimateView *oldWelcomeView = weakSelf.views[weakSelf.pageNumber-1];
            [oldWelcomeView refreshAnimate];
            scrollView.scrollEnabled = YES;
        }];
    }else if (_pageNumber > targetContentOffset->x /_scrollView.bounds.size.width) {
        
        WelcomeAnimateView *welcomeView = _views[--_pageNumber];
        [welcomeView startAnimateWithDirection:WAViewDirectionLeft Completion:^{
            WelcomeAnimateView *oldWelcomeView = weakSelf.views[weakSelf.pageNumber+1];
            [oldWelcomeView refreshAnimate];
            scrollView.scrollEnabled = YES;
        }];
    }
    if (_pageControl.currentPage == 2 && _pageNumber == 1) {
        [self changeStartButton:NO];
    }
    if (_pageControl.currentPage == 1 && _pageNumber == 2) {
        [self changeStartButton:YES];
    }
    _pageControl.currentPage = _pageNumber;
    
}

- (void)changeStartButton:(BOOL)isNeed{
    self.button.hidden = !isNeed;
    _pageControl.hidden = isNeed;
}

- (void)start{
    if (self.block) {
        self.block();
    }
}
#pragma mark - lazy load

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton new];
        _button.layer.cornerRadius = 17;
        [_button setTitle:@"start" forState:UIControlStateNormal];
        _button.backgroundColor = HEXCOLOR(0xFF465F);
        _button.hidden = YES;
        _button.titleLabel.font = [UIFont systemFontOfSize:24];
        [_button addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (EllipsePageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[EllipsePageControl alloc] init];
        _pageControl.numberOfPages = 3;
        _pageControl.controlSize = 10;
        _pageControl.controlSpacing = 14;
        _pageControl.currentPage = 0;
        _pageControl.currentColor = HEXCOLOR(0xFF465F);
    }
    return _pageControl;
}


@end
