//
//  HPSearchViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPSearchViewController.h"

#import "LGNavigationSearchBar.h"
#import "HPVoiceSearchView.h"
#import "HPSearchHistoryView.h"

#import "HPSearchLessonController.h"
#import "HPSearchBuildPoineNewsController.h"

#import "DJDataBaseModel.h"// 微党课
#import "DCSubPartStateModel.h"// 要闻

#import "LGLocalSearchRecord.h"// 本地历史记录管理者
#import "LGRecordButtonLoader.h"// 本地历史记录按钮加载管理者
#import "LGVoiceRecoganizer.h"// 声音识别管理者

@interface HPSearchViewController ()<
LGNavigationSearchBarDelelgate,
UITextFieldDelegate,
HPVoiceSearchViewDelegate>

@property (strong,nonatomic) LGNavigationSearchBar *fakeNavgationBar;
@property (strong,nonatomic) UITextField *textField;
/** 语音搜索页面 */
@property (strong,nonatomic) HPVoiceSearchView *vsView;
@property (strong,nonatomic) NSString *searchContent;

@property (strong,nonatomic) NSMutableString *voiceString;
@property (weak,nonatomic) HPSearchHistoryView *searchHistory;

/** 本地搜索记录数组 */
@property (strong,nonatomic) NSArray<NSString *> *records;
@property (strong,nonatomic) LGRecordButtonLoader *rbLoader;

@end

@implementation HPSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LGNavigationSearchBar *fakeNavgationBar = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
//    LGNavigationSearchBar *fakeNavgationBar = [[LGNavigationSearchBar alloc] init];
    fakeNavgationBar.leftImgName = @"icon_arrow_left_black";
    fakeNavgationBar.isShowRightBtn = YES;
    fakeNavgationBar.rightButtonTitle = @"搜索";
    fakeNavgationBar.delegate = self;
    [self.view addSubview:fakeNavgationBar];
    _fakeNavgationBar = fakeNavgationBar;
    
    /// 搜索记录view
    HPSearchHistoryView *hisView = [[HPSearchHistoryView alloc] init];
    _searchHistory = hisView;
    
    [self getLocalRecord];
    
    [hisView.deleteRecord addTarget:self
                             action:@selector(deleteSearchRecord:)
                   forControlEvents:UIControlEventTouchUpInside];
    hisView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:hisView];
    [hisView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fakeNavgationBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lg_endOfSpeech:) name:LGVoiceRecoganizerEndOfSpeechNotification object:nil];
    
    /// 默认进入页面自动响应输入
    [self addTextFieldToNav:_fakeNavgationBar];
    
    [LGLocalSearchRecord sharedInstance];
    
    if (_voice) {
        /// 添加语音面板
        if (!_vsView) {
            [self.view addSubview:self.vsView];
        }
    }
    
}
- (void)recordClick:(UIButton *)record{
    NSLog(@"clickrecord.title: %@",record.titleLabel.text);
    _textField.text = record.titleLabel.text;
    [self sendSearchRequest:NO];
}
- (void)deleteSearchRecord:(UIButton *)sender{
//    NSLog(@"删除历史记录: ");
    [LGLocalSearchRecord removeLocalRecord];
    [self getLocalRecord];
}

#pragma mark - notifications
/// MARK: 语音搜索结果回调
- (void)lg_endOfSpeech:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    NSString *voiceString = dict[LGVoiceRecoganizerTextKey];
    /// 去掉标点符号
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"。，@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *trimmedString = [voiceString stringByTrimmingCharactersInSet:set];
    
    self.textField.text = [NSString stringWithFormat:@"%@%@",self.textField.text,trimmedString];
}

#pragma mark - HPVoiceSearchViewDelegate
- (void)voiceViewRecording:(HPVoiceSearchView *)voiceView{
    NSLog(@"开始录入语音 -- ");
}
- (void)voiceViewClose:(HPVoiceSearchView *)voiceView{
    if (_vsView) {
        [_vsView removeFromSuperview];
        _vsView = nil;
    }
}

#pragma - LGNavigationSearchBarDelelgate
- (void)navSearchClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self addTextFieldToNav:navigationSearchBar];
}
- (void)leftButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self lg_dismissViewController];
}
- (void)voiceButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self addTextFieldToNav:navigationSearchBar];
    [self.view endEditing:YES];
    if (!_vsView) {
        [self.view addSubview:self.vsView];
    }
}
- (void)navRightButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self sendSearchRequest:YES];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self navRightButtonClick:nil];
    return YES;
}

- (void)setSearchContent:(NSString *)searchContent{
    _searchContent = searchContent;
    HPSearchLessonController *microvc = self.childViewControllers[0];
    HPSearchBuildPoineNewsController *partyvc = self.childViewControllers[1];
    microvc.searchContent = searchContent;
    partyvc.searchContent = searchContent;
}

/** 发送搜索请求 */
- (void)sendSearchRequest:(BOOL)isaNewRecord{
    [self.view endEditing:YES];
    /** type: 默认传0
     1:微党课
     2:党建要闻
     */
    
    self.searchContent = self.textField.text;
    
    if (isaNewRecord) {
        /// 写入搜索记录 测试数据，测试用户id：1，模块: home
        [LGLocalSearchRecord addNewRecordWithContent:self.searchContent part:SearchRecordExePartHome];
        /// 将新输入的内容添加到界面上
        [self getLocalRecord];
        
    }
    [[LGLoadingAssit sharedInstance] homeAddLoadingViewTo:self.view];
    [DJHomeNetworkManager homeSearchWithString:self.searchContent type:0 offset:0 length:10 sort:0 success:^(id responseObj) {
        /// MARK: 刷新子可控制器视图
        [_vsView removeFromSuperview];
        _vsView = nil;
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        
        NSArray *classes = responseObj[@"classes"];
        NSArray *news = responseObj[@"news"];
        
        HPSearchLessonController *microvc = self.childViewControllers[0];
        if (classes == nil || classes.count == 0) {
            microvc.dataArray = nil;
        }else{
            NSMutableArray *microModels = [NSMutableArray array];
            [classes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DJDataBaseModel *model = [DJDataBaseModel mj_objectWithKeyValues:obj];
                [microModels addObject:model];
            }];
            
            microvc.dataArray = microModels.copy;
        }
        
        HPSearchBuildPoineNewsController *partyvc = self.childViewControllers[1];
        if (news == nil || news.count == 0) {
            partyvc.dataArray = nil;
        }else{
            NSMutableArray *partyModels = [NSMutableArray array];
            [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DCSubPartStateModel *model = [DCSubPartStateModel mj_objectWithKeyValues:obj];
                [partyModels addObject:model];
            }];
            
            partyvc.dataArray = partyModels.copy;
        }
        
        if (classes.count || news.count) {
            _searchHistory.hidden = YES;
        }
        if (classes.count == 0 && news.count == 0) {
            _searchHistory.hidden = NO;
            [self.view presentFailureTips:@"没有搜到想要的内容"];
        }
        

    } failure:^(id failureObj) {
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        NSLog(@"faillureObject -- %@",failureObj);
        
    }];
    
}
/** 退出输入状态 */
- (void)endInput{
    [self.view endEditing:YES];
    _fakeNavgationBar.isEditing = NO;
    [_textField removeFromSuperview];
    _textField = nil;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.delegate = self;
        UIView *margin = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _textField.leftView = margin;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.returnKeyType = UIReturnKeySearch;
    }
    return _textField;
}
- (HPVoiceSearchView *)vsView{
    if (!_vsView) {
        _vsView = [HPVoiceSearchView voiceSearchView];
        _vsView.frame = CGRectMake(0, navHeight(), kScreenWidth, kScreenHeight - navHeight());
        _vsView.delegate = self;
    }
    return _vsView;
}
- (NSArray<NSDictionary *> *)segmentItems{
    /**
     DCQuestionCommunityViewController
     HPSearchBuildPoineNewsController
     
     */
    return @[@{LGSegmentItemNameKey:@"微党课",
               LGSegmentItemViewControllerClassKey:@"HPSearchLessonController",/// HPSearchLessonController
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"要闻",
               LGSegmentItemViewControllerClassKey:@"HPSearchBuildPoineNewsController",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}
- (LGRecordButtonLoader *)rbLoader{
    if (!_rbLoader) {
        _rbLoader = [[LGRecordButtonLoader alloc] init];
    }
    return _rbLoader;
}
- (CGFloat)segmentTopMargin{
    return kNavSingleBarHeight + marginTen;
}
- (void)addTextFieldToNav:(LGNavigationSearchBar *)navigationSearchBar{
    if (!_textField) {
        navigationSearchBar.isEditing = YES;
        CGRect frame = navigationSearchBar.fakeSearch.frame;
        frame.size.width -= 35;
        [self.view addSubview:self.textField];
        self.textField.frame = frame;
        if (!_voice) {
            [self.textField becomeFirstResponder];
        }
        
    }
}
/** 获取本地搜索记录 */
- (void)getLocalRecord{
    self.records = [LGLocalSearchRecord getLocalRecordWithPart:SearchRecordExePartHome];
    NSMutableArray *buttonArray = [NSMutableArray array];
    [self.records enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self.rbLoader buttonWith:obj frame:CGRectZero];
        [buttonArray addObject:button];
    }];
    [self.rbLoader addButtonTo:_searchHistory.scrollv viewController:self array:buttonArray.copy action:@selector(recordClick:)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
