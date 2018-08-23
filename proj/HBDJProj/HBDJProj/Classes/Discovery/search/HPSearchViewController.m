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

#import "HPSearchLessonController.h"
#import "HPSearchBuildPoineNewsController.h"

#import "DJDataBaseModel.h"// 微党课
#import "EDJMicroBuildModel.h"// 要闻

#import "LGLocalSearchRecord.h"// 本地历史记录管理者
#import "LGRecordButtonLoader.h"// 本地历史记录按钮加载管理者
#import "LGVoiceRecoganizer.h"// 声音识别管理者
#import "LGUserLimitsManager.h"// 隐私权限检查
#import "LGVoiceRecoAssist.h"// 语音识别辅助
#import "EDJSearchTagModel.h"

#import "DJDsSearchTagView.h"

@interface HPSearchViewController ()<
LGNavigationSearchBarDelelgate,
UITextFieldDelegate,
HPVoiceSearchViewDelegate,
LGVoiceRecoAssistDelegate>

@property (strong,nonatomic) LGNavigationSearchBar *fakeNavgationBar;
@property (strong,nonatomic) UITextField *textField;
/** 语音搜索页面 */
@property (strong,nonatomic) HPVoiceSearchView *vsView;
@property (strong,nonatomic) NSString *searchContent;

@property (strong,nonatomic) NSMutableString *voiceString;
@property (strong,nonatomic) DJDsSearchTagView *searchHistory;

/** 本地搜索记录数组 */
@property (strong,nonatomic) NSArray<NSString *> *records;
@property (strong,nonatomic) LGRecordButtonLoader *rbLoader;
@property (strong,nonatomic) NSArray *hisTagModels;

@property (strong,nonatomic) LGUserLimitsManager *limitsMgr;
@property (strong,nonatomic) LGVoiceRecoAssist *voiceAssist;

/** 是否正在识别,默认为NO */
@property (assign,nonatomic) BOOL speaking;

@end

@implementation HPSearchViewController

#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI_sub];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)configUI_sub{
    _speaking = NO;
    
    LGNavigationSearchBar *fakeNavgationBar = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
    fakeNavgationBar.leftImgName = @"icon_arrow_left_black";
    fakeNavgationBar.isShowRightBtn = YES;
    fakeNavgationBar.rightButtonTitle = @"搜索";
    fakeNavgationBar.delegate = self;
    [self.view addSubview:fakeNavgationBar];
    _fakeNavgationBar = fakeNavgationBar;
    
    /// 获取本地历史记录数据
    [self getLocalRecord];
    
    [self.view addSubview:self.searchHistory];
    [self.searchHistory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fakeNavgationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    /// 监听语音识别结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lg_endOfSpeech:) name:LGVoiceRecoganizerEndOfSpeechNotification object:nil];
    
    /// 默认进入页面自动响应输入
    [self addTextFieldToNav:_fakeNavgationBar];
    
    if (_voice) {
        /// 添加语音面板
        if (!_vsView) {
            [self.view addSubview:self.vsView];
        }
    }
}

#pragma mark - settter
- (void)setSearchContent:(NSString *)searchContent{
    _searchContent = searchContent;
    HPSearchLessonController *microvc = self.childViewControllers[0];
    HPSearchBuildPoineNewsController *partyvc = self.childViewControllers[1];
    microvc.searchContent = searchContent;
    partyvc.searchContent = searchContent;
}

#pragma mark - target
/// MARK: 点击搜索历史
- (void)recordClick:(UIButton *)record{
    _textField.text = record.titleLabel.text;
    [self sendSearchRequest:NO];
}
/// MARK: 删除历史记录
- (void)deleteSearchRecord:(UIButton *)sender{
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


/// MARK: 语音搜索视图 HPVoiceSearchViewDelegate
- (void)voiceViewRecording:(HPVoiceSearchView *)voiceView{
    /// 检查网络状态
    [[LGNetworkManager sharedInstance] checkNetworkStatusWithBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown ||
            status == AFNetworkReachabilityStatusNotReachable) {
            [self presentFailureTips:@"网络异常，无法进行语音识别"];
        }else{
            if (!_speaking) {
                /// 检查用户 麦克风权限
                [self.limitsMgr microPhoneLimitCheck:^{
                    [self.voiceAssist start];
                    
                } denied:^{
                    UIAlertController *alertVc = [self.limitsMgr showSetMicroPhoneAlertView];
                    [self presentViewController:alertVc animated:YES completion:nil];
                }];
                _speaking = YES;
            }
        }
    }];
    
}
- (void)voiceViewClose:(HPVoiceSearchView *)voiceView{
    [_vsView.icon setImage:[UIImage imageNamed:@"home_voice_begin"]];
    _speaking = NO;
    
    if (_vsView) {
        [_vsView removeFromSuperview];
        _vsView = nil;
    }
}

/// MARK: 声音识别辅助对象 LGVoiceRecoAssistDelegate
- (void)voiceRecoAssistRecoganizing:(NSInteger)second{
    [_vsView.icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_voice_searching_%ld",(long)second]]];
}
- (void)voiceRecoAssistEndRecoganize{
    [self voiceViewClose:_vsView];
}

/// MARK: 搜索bar LGNavigationSearchBarDelelgate
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

/// MARK: 输入框 UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self navRightButtonClick:nil];
    return YES;
}

#pragma mark - lazy load & getter
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
        _vsView.vc = self;
    }
    return _vsView;
}
- (LGRecordButtonLoader *)rbLoader{
    if (!_rbLoader) {
        _rbLoader = [[LGRecordButtonLoader alloc] init];
    }
    return _rbLoader;
}
- (LGUserLimitsManager *)limitsMgr{
    if (!_limitsMgr) {
        _limitsMgr = [LGUserLimitsManager new];
    }
    return _limitsMgr;
}
- (LGVoiceRecoAssist *)voiceAssist{
    if (!_voiceAssist) {
        _voiceAssist = [LGVoiceRecoAssist new];
        _voiceAssist.delegate = self;
    }
    return _voiceAssist;
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
- (CGFloat)segmentTopMargin{
    return kNavSingleBarHeight + marginTen;
}

#pragma mark - private method
/// MARK: 发送搜索请求
- (void)sendSearchRequest:(BOOL)isaNewRecord{
    [self.view endEditing:YES];
    /** type: 默认传0
     1:微党课
     2:党建要闻
     */
    
    self.searchContent = self.textField.text;
    if (self.searchContent == nil || [self.searchContent isEqualToString:@""]) {
        [self presentFailureTips:@"请输入要搜索的内容"];
        return;
    }
    
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
            
            for (int i = 0; i < classes.count; i++) {
                id obj = classes[i];
                DJDataBaseModel *model = [DJDataBaseModel mj_objectWithKeyValues:obj];
                [microModels addObject:model];
            }
            
            microvc.dataArray = microModels.copy;
        }
        
        HPSearchBuildPoineNewsController *partyvc = self.childViewControllers[1];
        if (news == nil || news.count == 0) {
            partyvc.dataArray = nil;
        }else{
            NSMutableArray *partyModels = [NSMutableArray array];
            
            for (int i = 0; i < news.count; i++) {
                id obj = news[i];
                EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:obj];
                [partyModels addObject:model];
            }
            
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
        if ([failureObj isKindOfClass:[NSError class]]) {
            [self presentFailureTips:@"网络异常"];
        }else{
            [self presentFailureTips:@"没有数据"];
        }
    }];
    
}
/// 获取搜索历史记录
- (void)getLocalRecord{
    self.records = [LGLocalSearchRecord getLocalRecordWithPart:SearchRecordExePartHome];
    
    //    NSMutableArray *arrmu = NSMutableArray.new;
    //    for (NSInteger i = 0; i < 50; i++) {
    //        NSString *str = [NSString stringWithFormat:@"测试比起爱三十多家%ld",i];
    //        [arrmu addObject:str];
    //    }
    //    self.records = arrmu.copy;
    
    /// TODO: hot & his 测试数据
    
    NSMutableArray *arrmu = [NSMutableArray array];
    for (NSInteger i = 0; i < self.records.count; i++) {
        EDJSearchTagModel *model = EDJSearchTagModel.new;
        model.name = self.records[i];
        model.isHis = YES;
        [arrmu addObject:model];
    }
    _hisTagModels = arrmu.copy;
    
    /// TODO: hot & his 创建button
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    [self.records enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self.rbLoader buttonWithText:obj frame:CGRectZero];
        [buttonArray addObject:button];
    }];

    /// 热门标签
//    [self.rbLoader addButtonToContainerView:<#(UIView *)#> viewController:<#(UIViewController *)#> array:<#(NSArray<UIButton *> *)#> action:<#(SEL)#>
    
    /// 历史记录
//    [self.rbLoader addButtonToContainerView:<#(UIView *)#> viewController:<#(UIViewController *)#> array:<#(NSArray<UIButton *> *)#> action:<#(SEL)#>
    

}
/// 添加输入框
- (void)addTextFieldToNav:(LGNavigationSearchBar *)navigationSearchBar{
    if (!_textField) {
        navigationSearchBar.isEditing = YES;
        CGRect frame = navigationSearchBar.fakeSearch.frame;
        frame.size.width -= 35;
        [self.view addSubview:self.textField];
        self.textField.frame = frame;
        if (!_voice) {
//            [self.textField becomeFirstResponder];
        }
        
    }
}
/// 退出输入状态
- (void)endInput{
    [self.view endEditing:YES];
    _fakeNavgationBar.isEditing = NO;
    [_textField removeFromSuperview];
    _textField = nil;
}

#pragma mark - system method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (DJDsSearchTagView *)searchHistory{
    if (!_searchHistory) {
        _searchHistory = DJDsSearchTagView.new;
    }
    return _searchHistory;
}

@end
