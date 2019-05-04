//
//  CandyDetailController.m
//  PetPlanet
//
//  Created by Overloop on 2019/5/1.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "CandyDetailController.h"
#import "CandyDetailCell.h"
#import "CandyDetailNetwork.h"
#import "CandyReplyCell.h"
#import "HPGrowingTextView.h"
#import "PersonalViewController.h"
#import "ZYSVPManager.h"
#import <MJRefresh.h>

@interface CandyDetailController ()<UITableViewDelegate,UITableViewDataSource,CandyDetailCellDelegate,HPGrowingTextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputHeight;
@property (weak, nonatomic) IBOutlet HPGrowingTextView *textView;

@property (nonatomic,strong) CandyModel *model;
@property (nonatomic,assign) CGFloat detailHeight;
@property (nonatomic,strong) NSMutableDictionary *heightDic;
@property (nonatomic,strong) CandyDetailNetwork *network;
@property (nonatomic,assign) BOOL isCollection;
@property (nonatomic,assign) BOOL deleting;
@property (nonatomic,assign) BOOL collectioning;
@property (nonatomic,assign) BOOL liking;
@property (nonatomic,assign) BOOL needEdit;
@end

@implementation CandyDetailController

- (instancetype)initWithCandyModel:(CandyModel *)model{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    self.navigationItem.title = @"Moment";
    _detailHeight = 0;
    
    _textView.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    if (![ZYUserManager shareInstance].isLogin) {
        [_textView setEditable:NO];
        _textView.placeholder = @"Did Not Login In";
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _textView.minNumberOfLines = 1;
        _textView.maxNumberOfLines = 4;
        _textView.delegate = self;
        _textView.tintColor = HEXCOLOR(0xA09EEC);
        _textView.placeholder = @"Input Here";
    }
    
   // [self configNavigationItems];
    
    [self reloadData];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_needEdit) {
        [_textView becomeFirstResponder];
        _needEdit = NO;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PublicMethod
- (void)edit{
    _needEdit = YES;
}

#pragma mark - PrivateMethod
- (void)configHeaderAndFooter{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"UFO_0"];
    [header setImages:@[image] forState:MJRefreshStatePulling];
    [header setImages:[Common getUFOImage] forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    _tableView.mj_footer = footer;
}

- (void)configNavigationItems{
    UIBarButtonItem *item;
    if ([_model.authorID isEqualToString:[ZYUserManager shareInstance].userID]) {
        item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bin"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteEvent)];
    }else{
        UIImage *image = [UIImage imageNamed:@"collection_btn"];
        _isCollection = NO;
        if ([_network.detailModel.isCollection isEqualToString:@"1"]) {
            image = [UIImage imageNamed:@"collection_btn1"];
            _isCollection = YES;
        }
        item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(collectionEvnet:)];
    }
    UIBarButtonItem *fix = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[fix,item];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[backItem];
}

- (void)collectionEvnet:(UIBarButtonItem *)sender{
    if (![ZYUserManager shareInstance].isLogin) {
        [ZYSVPManager showText:@"Please Login" autoClose:1.5];
        return;
    }
    sender.enabled = NO;
    BOOL isCollection = !_isCollection;
    __weak typeof(self) weakSelf = self;
    [_network collectionWithCid:_model.candyID isCollection:isCollection complete:^{
        weakSelf.isCollection = isCollection;
        sender.enabled = YES;
        sender.image = [UIImage imageNamed:isCollection?@"collection_btn1":@"collection_btn"];
    } fail:^(NSString * _Nonnull error) {
        [ZYSVPManager showText:@"Collection Failed" autoClose:1.5];
        sender.enabled = YES;
    }];
}

- (void)deleteEvent{
    if (_deleting) {
        return;
    }
    _deleting = YES;
    
    __weak typeof(self) weakSelf = self;
    [_network deleteCandyWithCid:_model.candyID complete:^{
        [ZYSVPManager showText:@"Delete Successed" autoClose:1.5];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(NSString * _Nonnull error) {
        weakSelf.deleting = NO;
        [ZYSVPManager showText:@"Delete Failed" autoClose:1.5];
    }];
}

- (void)configTableView{
    _tableView.estimatedRowHeight = 100;
    [_tableView registerNib:[UINib nibWithNibName:@"CandyDetailCell" bundle:nil] forCellReuseIdentifier:@"CandyDetailCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CandyReplyCell" bundle:nil] forCellReuseIdentifier:@"CandyReplyCell"];
    [self configHeaderAndFooter];
}

- (void)gotoPersonalPageWithUid:(NSString *)uid{
    __weak typeof(self) weakSelf = self;
    __block BOOL flag = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PersonalViewController class]]) {
            PersonalViewController *controller = obj;
            if ([controller.uid isEqualToString: uid]) {
                [weakSelf.navigationController popToViewController:obj animated:YES];
                flag = YES;
                *stop = YES;
                return;
            }
        }
    }];
    if (!flag) {
        PersonalViewController *personalVC = [[PersonalViewController alloc]initWithUserID:uid];
        [self.navigationController pushViewController:personalVC animated:YES];
    }
}

- (void)reloadData{
    __weak typeof(self) weakSelf = self;
    [self.network reloadDataWithAid:_model.candyID complete:^{
        weakSelf.detailHeight = 0;
        weakSelf.heightDic = nil;
        [weakSelf configNavigationItems];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf.tableView reloadData];
    } fail:^(NSString * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if ([error isEqualToString:@"30"]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [ZYSVPManager showText:@"Already Delete" autoClose:1.5];
        }
    }];
}

- (void)moreData{
    __weak typeof(self) weakSelf = self;
    [self.network moreReplyWithAid:_model.candyID complete:^(BOOL noMore) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if (noMore) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
    } fail:^(NSString * _Nonnull error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([error isEqualToString:@"15"]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        [ZYSVPManager showText:@"Load Failed" autoClose:1.5];
    }];
}

- (IBAction)replyCandy:(id)sender {
    if (![ZYUserManager shareInstance].isLogin) {
        return;
    }
    
    if (_textView.text.length==0) {
        return;
    }
    
    _textView.editable = NO;
    UIButton *button = sender;
    button.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [_network replyWithContent:_textView.text cid:_model.candyID complete:^{
        [ZYSVPManager showText:@"Reply Successed" autoClose:1.5];
        [weakSelf reloadData];
        button.enabled = YES;
        weakSelf.textView.editable = YES;
        weakSelf.textView.text = @"";
    } fail:^(NSString * _Nonnull error) {
        button.enabled = YES;
        weakSelf.textView.editable = YES;
        [ZYSVPManager showText:@"Reply Failed" autoClose:1.5];
    }];
}

#pragma mark - GrowingTextViewDelegate
-(BOOL)textPasteConfigurationSupporting:(id<UITextPasteConfigurationSupporting>)textPasteConfigurationSupporting shouldAnimatePasteOfAttributedString:(NSAttributedString*)attributedString toRange:(UITextRange*)textRange  API_AVAILABLE(ios(11.0)){
    return NO;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_textView.animationDuration animations:^{
        weakSelf.inputHeight.constant = height +12;
        [weakSelf.view layoutIfNeeded];
    }];
}
#pragma mark - KeyboardEvent
- (void)keyboardWillChangeFrame:(NSNotification*)sender{
    CGFloat duration = [sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat transformY = keyboardFrame.size.height;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.bottomSpace.constant = -transformY;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.bottomSpace.constant = 0;
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - tableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CandyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandyDetailCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell configWithModel:_network.detailModel];
        return cell;
    }
    CandyReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandyReplyCell"];
    [cell configWithModel:_network.replyModels[indexPath.row-1]];
    __weak typeof(self) weakSelf = self;
    cell.replyBlock = ^(CandyReplyModel * _Nonnull model) {
        
    };
    cell.nameOrHeadBlock = ^(NSString * _Nonnull uid) {
        [weakSelf gotoPersonalPageWithUid:uid];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return _detailHeight != 0 ?_detailHeight:420;
    }else{
        if ([self.heightDic objectForKey:@(indexPath.row)]) {
            NSNumber *number = [self.heightDic objectForKey:@(indexPath.row)];
            return number.floatValue;
        }else{
            NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
            attrDict[NSFontAttributeName] = [UIFont fontWithName:@"HelveticaNeue" size:13];
            CandyReplyModel *model = _network.replyModels[indexPath.row-1];
            
            CGSize size = [model.content boundingRectWithSize:CGSizeMake(243 + Screen_Width-375, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;
            CGFloat height = size.height + 64;
            [self.heightDic setObject:@(height) forKey:@(indexPath.row)];
            return height;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_network.detailModel) {
        return 0;
    }
    return _network.replyModels.count +1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - CandyDetailDelegate

- (void)didLoadImage:(CGFloat)imageHeight{
    _detailHeight = imageHeight;
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)didTapImageOrNameWithUid:(NSString *)uid{
    [self gotoPersonalPageWithUid:uid];
}

- (void)didTapWithIsLike:(BOOL)isLike complete:(LikeComplete)block{
    if (![ZYUserManager shareInstance].isLogin) {
        [ZYSVPManager showText:@"Please Login" autoClose:1.5];
    }
    if (_liking) {
        return;
    }
    _liking = YES;
    __weak typeof(self) weakSelf = self;
    [_network likeWithCid:_model.candyID isLike:isLike complete:^{
        block();
        weakSelf.liking = NO;
    } fail:^(NSString * _Nonnull error) {
        weakSelf.liking = NO;
        [ZYSVPManager showText:@"Like Failed" autoClose:1.5];
    }];
}

#pragma mark - Getter & Setter
- (NSMutableDictionary *)heightDic{
    if (!_heightDic) {
        _heightDic = [NSMutableDictionary new];
    }
    return _heightDic;
}

- (CandyDetailNetwork *)network{
    if (!_network) {
        _network = [[CandyDetailNetwork alloc]init];
    }
    return _network;
}
@end
