//
//  TCSearchViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/8.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCSearchViewController.h"
#import "LGNavigationSearchBar.h"   /// 导航视图
#import "HPSearchHistoryView.h"     /// 搜索历史 视图
#import "LGLocalSearchRecord.h"     /// 历史记录本地管理
#import "LGRecordButtonLoader.h"    /// 加载历史记录按钮的管理
#import "TCErrorViewController.h"   /// 错误视图
#import "TCBookListDataHandler.h"   /// 数据请求 + 解析
#import "TCSchoolBookTableViewController.h"  /// 列表控制器(学校书橱)
#import "TCMyCollectionViewController.h"     /// 书架控制器(我的书橱)
#import "TCSearchListCountView.h"   /// 显示搜索条数

@interface TCSearchViewController ()<
LGNavigationSearchBarDelelgate,
UITextFieldDelegate,
TCErrorViewControllerDelegate>
@property (weak,nonatomic) LGNavigationSearchBar *fakeNavgationBar;
@property (strong,nonatomic) UITextField *textField;
/** 搜索历史 */
@property (strong,nonatomic) HPSearchHistoryView *searchHistory;/// search history
/** 本地搜索记录数组 */
@property (strong,nonatomic) NSArray<NSString *> *records;
@property (strong,nonatomic) LGRecordButtonLoader *rbLoader;
@property (strong,nonatomic) NSString *searchContent;

/** 数据请求 + 解析 */
@property (strong,nonatomic) TCBookListDataHandler *dataHandler;
/** 搜索数据条数 */
@property (strong,nonatomic) TCSearchListCountView *dcv;
/** 列表样式数据 控制器 */
@property (strong,nonatomic) TCSchoolBookTableViewController *schoolListvc;
/** 我的书橱 视图控制器 */
@property (strong,nonatomic) TCMyCollectionViewController *myBookrackvc;
/** 错误view 控制器 */
@property (strong,nonatomic) TCErrorViewController *errorvc;

@end

@implementation TCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

/// 发送搜索请求
- (void)sendSearchRequest:(BOOL)isaNewRecord{
    [self.view endEditing:YES];
    
    self.searchContent = self.textField.text;
    if (self.searchContent == nil || [self.searchContent isEqualToString:@""]) {
        //        [self presentFailureTips:@"请输入要搜索的内容"];
        return;
    }
    
    if (isaNewRecord) {
        /// 写入搜索记录
        [LGLocalSearchRecord addNewRecordWithContent:self.searchContent part:self.blrType];
        /// 将新输入的内容添加到界面上
        [self getLocalRecord];
        
    }
    
    NSDictionary *param = @{addParamKey_page:@(0),
                            addParamKey_length:@(10)
                            };
    
    [self.dataHandler requestDataWithType:self.blrType addParam:param success:^(id  _Nonnull resobj) {
        NSLog(@"搜索成功回调: %@",resobj);
        /// TODO: 搜索成功结果顶部添加 搜索结果条数
        /// 隐藏历史记录视图
        self.searchHistory.hidden = YES;
        /// 移除错误视图
        [self removeErrorView];
        
        /// 展示相应的列表视图
        [self showSearchResult];
        
    } failure:^(id  _Nonnull errobj) {
        NSLog(@"搜索失败回调: %@",errobj);
        /// 隐藏历史记录视图
        self.searchHistory.hidden = YES;
        /// 展示错误视图
        [self createErrorViewWithType:1 hidden:NO];
    }];
}

#pragma mark - target
/// MARK: 点击搜索历史
- (void)recordClick:(UIButton *)record{
    _textField.text = record.titleLabel.text;
    
    /// 发起搜索请求
    [self sendSearchRequest:NO];
    
}

#pragma mark - delegate
- (void)errorvcRealodData:(TCErrorViewController *)errorvc{
    NSLog(@"错误页面刷新数据");
}

- (void)showSearchResult{
    if (self.blrType == 0) {
        /// 我的书橱
        self.myBookrackvc.view.hidden = NO;
    }
    
    if (self.blrType == 1) {
        /// 学校书橱
        self.schoolListvc.view.hidden = NO;
    }
    self.dcv.hidden = NO;
}

- (void)configUI{
    
    self.dataHandler = TCBookListDataHandler.new;
    
    LGNavigationSearchBar *fakeNavgationBar = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, navHeight())];
    fakeNavgationBar.leftImgName = @"icon_arrow_left_white";
    fakeNavgationBar.delegate = self;
    [self.view addSubview:fakeNavgationBar];
    _fakeNavgationBar = fakeNavgationBar;
    
    [self addTextFieldToNav:_fakeNavgationBar];
    
    /// 展示搜索历史
    _searchHistory = [[HPSearchHistoryView alloc] init];
    
    [self.view addSubview:_searchHistory];
    [_searchHistory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fakeNavgationBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    /// testcode
    [LGLocalSearchRecord addNewRecordWithContent:@"黄梅戏" part:self.blrType];
    [LGLocalSearchRecord addNewRecordWithContent:@"封神演义" part:self.blrType];
    [LGLocalSearchRecord addNewRecordWithContent:@"红楼梦之蓝" part:self.blrType];
    [LGLocalSearchRecord addNewRecordWithContent:@"傲慢与偏见" part:self.blrType];
    [LGLocalSearchRecord addNewRecordWithContent:@"西游记" part:self.blrType];
    
    [self getLocalRecord];
    
    /// 显示搜索条数
    self.dcv = TCSearchListCountView.new;
    [self.view addSubview:self.dcv];
    [self.dcv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fakeNavgationBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.view.mas_right);
    }];
    self.dcv.hidden = YES;
    
    /// 搜索结果 列表
    self.schoolListvc = TCSchoolBookTableViewController.new;
    self.schoolListvc.firstCellHiddenLine = YES;
    [self.view addSubview:self.schoolListvc.view];
    [self addChildViewController:self.schoolListvc];
    [self.schoolListvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dcv.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    self.schoolListvc.view.hidden = YES;
    
    /// 错误视图
//    [self createErrorViewWithType:1 hidden:YES];
    
    /// 搜索结果 书架
    self.myBookrackvc = TCMyCollectionViewController.new;
    [self.view addSubview:self.myBookrackvc.view];
    [self addChildViewController:self.myBookrackvc];
    [self.myBookrackvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dcv.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    self.myBookrackvc.view.hidden = YES;
}
/** type 0: 网络异常;1: 没有搜到结果 */
- (void)createErrorViewWithType:(NSInteger)type hidden:(BOOL)hidden{
    /// TODO: 请求失败 or 没有搜索到任何内容时展示
    if (self.errorvc) {
        self.errorvc = nil;
    }
    self.errorvc = [TCErrorViewController errorvcWithType:type delegate:self noticeText:kNoticeWordNetLost];
    
    [self.view addSubview:self.errorvc.view];
    [self addChildViewController:self.errorvc];
    MJWeakSelf
    [self.errorvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(weakSelf.fakeNavgationBar.mas_bottom);
    }];
    self.errorvc.view.hidden = hidden;
}
- (void)removeErrorView{
    if (self.errorvc) {
        [self.errorvc.view removeFromSuperview];
        self.errorvc = nil;
    }
}

/// 获取本地搜索记录
- (void)getLocalRecord{
    self.records = [LGLocalSearchRecord getLocalRecordWithPart:self.blrType];
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    [self.records enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self.rbLoader buttonWithText:obj frame:CGRectZero];
        [buttonArray addObject:button];
    }];
    [self.rbLoader addButtonToScrollView:_searchHistory.scrollv viewController:self array:buttonArray.copy action:@selector(recordClick:)];
}

/// 添加输入框
- (void)addTextFieldToNav:(LGNavigationSearchBar *)navigationSearchBar{
    if (!_textField) {
        navigationSearchBar.isEditing = YES;
        CGRect frame = navigationSearchBar.fakeSearch.frame;
        frame.size.width -= 35;
        [self.view addSubview:self.textField];
        self.textField.frame = frame;
        [self.textField becomeFirstResponder];
    }
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = UITextField.new;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.delegate = self;
        UIView *margin = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _textField.leftView = margin;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.returnKeyType = UIReturnKeySearch;
    }
    return _textField;
}
- (LGRecordButtonLoader *)rbLoader{
    if (!_rbLoader) {
        _rbLoader = [[LGRecordButtonLoader alloc] init];
    }
    return _rbLoader;
}
- (void)leftButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
