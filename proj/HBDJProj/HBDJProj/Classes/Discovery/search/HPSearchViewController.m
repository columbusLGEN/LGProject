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

#import "DCQuestionSearchResultVc.h"
#import "DCBranchSearchResultVc.h"
#import "DCPyqSearchResultVc.h"
#import "UCQuestionModel.h"// 学习问答
#import "DCSubPartStateModel.h"// 支部动态
#import "DCSubStageModel.h"// 党员舞台

#import "LGLocalSearchRecord.h"// 本地历史记录管理者
#import "LGRecordButtonLoader.h"// 本地历史记录按钮加载管理者
#import "LGVoiceRecoganizer.h"// 声音识别管理者
#import "LGUserLimitsManager.h"// 隐私权限检查
#import "LGVoiceRecoAssist.h"// 语音识别辅助
#import "EDJSearchTagModel.h"
#import "DJDsSearchTagView.h"
#import "DJDiscoveryNetworkManager.h"
#import "DJDsSearchChildVcDelegate.h"

@interface HPSearchViewController ()<
LGNavigationSearchBarDelelgate,
UITextFieldDelegate,
HPVoiceSearchViewDelegate,
LGVoiceRecoAssistDelegate,
DJDsSearchChildVcDelegate>

@property (strong,nonatomic) LGNavigationSearchBar *fakeNavgationBar;
@property (strong,nonatomic) UITextField *textField;
/** 语音搜索页面 */
@property (strong,nonatomic) HPVoiceSearchView *vsView;

@property (strong,nonatomic) NSString *searchContent;
@property (strong,nonatomic) EDJSearchTagModel *searchTagModel;

@property (strong,nonatomic) NSMutableString *voiceString;
@property (strong,nonatomic) DJDsSearchTagView *searchHistory;

/** 本地搜索记录数组 */
@property (strong,nonatomic) NSArray<NSString *> *records;
@property (strong,nonatomic) LGRecordButtonLoader *rbLoader;
@property (strong,nonatomic) NSArray *hotTags;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
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
    DCQuestionSearchResultVc *qavc = self.childViewControllers[0];
    DCBranchSearchResultVc *brvc = self.childViewControllers[1];
    DCPyqSearchResultVc *pyqvc = self.childViewControllers[2];
    qavc.delegate = self;
    brvc.delegate = self;
    pyqvc.delegate = self;
    qavc.searchContent = searchContent;
    brvc.searchContent = searchContent;
    pyqvc.searchContent = searchContent;
    
}
- (void)setSearchTagModel:(EDJSearchTagModel *)searchTagModel{
    _searchTagModel = searchTagModel;
    DCQuestionSearchResultVc *qavc = self.childViewControllers[0];
    DCBranchSearchResultVc *brvc = self.childViewControllers[1];
    DCPyqSearchResultVc *pyqvc = self.childViewControllers[2];
    qavc.delegate = self;
    brvc.delegate = self;
    pyqvc.delegate = self;
    qavc.tagId = searchTagModel.seqid;
    brvc.tagId = searchTagModel.seqid;
    pyqvc.tagId = searchTagModel.seqid;
}

#pragma mark - target
/// MARK: 点击热门标签
- (void)hotTagClick:(UIButton *)button{
    NSInteger index = button.tag;
    EDJSearchTagModel *hotTagModel = _hotTags[index];
//    self.searchContent = nil;
    self.textField.text = hotTagModel.name;
    self.searchTagModel = hotTagModel;
    [self sendSearchRequest:NO isTagSearch:YES];
}
/// MARK: 点击搜索历史
- (void)recordClick:(UIButton *)record{
    _textField.text = record.titleLabel.text;
    self.searchTagModel = nil;
    [self sendSearchRequest:NO isTagSearch:NO];
}
/// MARK: 点击搜索按钮
- (void)navRightButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    BOOL isTag = NO;
    if (self.searchTagModel) {
        isTag = YES;
        _textField.text = self.searchTagModel.name;
    }else{
        
    }
    [self sendSearchRequest:YES isTagSearch:isTag];
    
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

/// MARK: 输入框 UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self navRightButtonClick:nil];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.searchHistory.hidden) {
        self.searchHistory.hidden = NO;
    }
}
- (void)textFieldDidChanged:(NSNotification *)noti{
    if (self.searchTagModel) {
        self.searchTagModel = nil;
    }
}

- (void)childVcDidScroll{
    [self.view endEditing:YES];
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

    return @[@{LGSegmentItemNameKey:@"学习问答",
               LGSegmentItemViewControllerClassKey:@"DCQuestionSearchResultVc",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"支部动态",
               LGSegmentItemViewControllerClassKey:@"DCBranchSearchResultVc",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"党员舞台",
               LGSegmentItemViewControllerClassKey:@"DCPyqSearchResultVc",///
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}
- (CGFloat)segmentTopMargin{
    return kNavSingleBarHeight + marginTen;
}

#pragma mark - private method
/// MARK: 发送搜索请求
- (void)sendSearchRequest:(BOOL)isaNewRecord isTagSearch:(BOOL)isTagSearch{
    [self.view endEditing:YES];
    /** type:
     默认传
     1:学习问答
     2:支部动态
     3:党员舞台
     */
    
    NSInteger tagId = 0;
    self.searchContent = self.textField.text;
    if (!isTagSearch) {/// 此分支 不是标签搜索，所以要记录历史记录
        BOOL scHasNoValue = (self.searchContent == nil || [self.searchContent isEqualToString:@""]);
        if (scHasNoValue) {
            [self presentFailureTips:@"请输入要搜索的内容或选择标签"];
            return;
        }
        
        if (isaNewRecord) {
            /// 写入搜索记录 测试数据，测试用户id：1，模块: home
            [LGLocalSearchRecord addNewRecordWithContent:self.searchContent part:SearchRecordExePartHome];
            /// 将新输入的内容添加到界面上
            [self getLocalRecord];
            
        }
    }else{
        /// 标签搜索不做历史记录
        if (_searchTagModel) {
            tagId = _searchTagModel.seqid;
        }
    }
    
    [DJDiscoveryNetworkManager.sharedInstance frontIndex_findSearchWithContent:self.searchContent label:tagId offset:0 type:0 success:^(id responseObj) {
        /// MARK: 刷新子可控制器视图
        [_vsView removeFromSuperview];
        _vsView = nil;
        [[LGLoadingAssit sharedInstance] homeRemoveLoadingView];
        
        if ([responseObj isKindOfClass:[NSArray class]] || [responseObj isKindOfClass:[NSNull class]]) {
            return;
        }
        
        NSArray *questionanswer = responseObj[@"questionanswer"];// 学习问答
        NSArray *branch = responseObj[@"branch"];// 支部动态
        NSArray *ugc = responseObj[@"ugc"];// 朋友圈
        
        /// 学习问答
        DCQuestionCommunityViewController *qavc = self.childViewControllers[0];
        NSMutableArray *arrmu_qa = NSMutableArray.new;
        for (NSInteger i = 0; i < questionanswer.count; i++) {
            /// 字典转模型
            UCQuestionModel *model = [UCQuestionModel mj_objectWithKeyValues:questionanswer[i]];
            [arrmu_qa addObject:model];
        }
        qavc.dataArray = arrmu_qa.copy;
        
        /// 支部动态
        DCSubPartStateTableViewController *branchvc = self.childViewControllers[1];
        NSMutableArray *arrmu_br = NSMutableArray.new;
        for (NSInteger i = 0; i < branch.count; i++) {
            DCSubPartStateModel *model = [DCSubPartStateModel mj_objectWithKeyValues:branch[i]];
            [arrmu_br addObject:model];
        }
        branchvc.dataArray = arrmu_br.copy;
        
        /// 党员舞台
        DCSubStageTableviewController *pyqvc = self.childViewControllers[2];
        NSMutableArray *arrmu_pyq = NSMutableArray.new;
        for (NSInteger i = 0; i < ugc.count; i++) {
            DCSubStageModel *model = [DCSubStageModel mj_objectWithKeyValues:ugc[i]];
            [arrmu_pyq addObject:model];
        }
        pyqvc.dataArray = arrmu_pyq.copy;
        
        if (ugc.count || questionanswer.count || branch.count) {
            self.searchHistory.hidden = YES;
        }
        if (ugc.count == 0 && questionanswer.count == 0 && branch.count == 0) {
            self.searchHistory.hidden = NO;
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
    
//        NSMutableArray *arrmu = NSMutableArray.new;
//        for (NSInteger i = 0; i < 50; i++) {
//            NSString *str = [NSString stringWithFormat:@"测试比起爱三十多家%ld",i];
//            [arrmu addObject:str];
//        }
//        self.records = arrmu.copy;
    
    [DJDiscoveryNetworkManager.sharedInstance frontLabel_selectWithSuccess:^(id responseObj) {
        
        NSArray *array = responseObj;
        if (array == nil || array.count == 0) {
        }else{
            NSMutableArray *arrmu = NSMutableArray.new;
            for (NSInteger i = 0; i < array.count; i++) {
                EDJSearchTagModel *model = [EDJSearchTagModel mj_objectWithKeyValues:array[i]];
                [arrmu addObject:model];
            }
            self.hotTags = arrmu.copy;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                /// 热门标签
                NSMutableArray *buttonArray1 = [NSMutableArray array];
                [self.hotTags enumerateObjectsUsingBlock:^(EDJSearchTagModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIButton *button = [self.rbLoader hotButtonWithText:obj.name frame:CGRectZero];
                    button.tag = idx;
                    [buttonArray1 addObject:button];
                }];
                [self.rbLoader addButtonToContainerView:self.searchHistory.conHot viewController:self array:buttonArray1 action:@selector(hotTagClick:)];
                
            }];
        }
        
    } failure:^(id failureObj) {
        
    }];
    
    /// 历史记录
    NSMutableArray *buttonArray2 = [NSMutableArray array];
    [self.records enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self.rbLoader buttonWithText:obj frame:CGRectZero];
        [buttonArray2 addObject:button];
    }];
    [self.rbLoader addButtonToContainerView:self.searchHistory.hisConView viewController:self array:buttonArray2 action:@selector(recordClick:)];
    

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
            [self.textField becomeFirstResponder];
        }
        
    }
}

- (void)viewSwitched:(NSInteger)index{
    [self.view endEditing:YES];
}

#pragma mark - system method

- (void)dealloc{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (DJDsSearchTagView *)searchHistory{
    if (!_searchHistory) {
        _searchHistory = DJDsSearchTagView.new;
        [_searchHistory.removeHis addTarget:self action:@selector(deleteSearchRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchHistory;
}

@end
