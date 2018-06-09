//
//  HPSearchViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPSearchViewController.h"
#import "LGNavigationSearchBar.h"
#import "HPSearchRequest.h"
#import "HPVoiceSearchView.h"
#import "HPSearchHistoryView.h"
#import "LGVoiceRecoganizer.h"
#import "DCSubPartStateTableViewController.h"
#import "HPMicroLessonTableViewController.h"
#import "EDJMicroPartyLessionSubModel.h"
#import "DCSubPartStateModel.h"

#import "LGLocalSearchRecord.h"
#import "LGRecordButtonLoader.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    /// 搜索记录
    self.records = [LGLocalSearchRecord getLocalRecordWithUserid:@"1" part:SearchRecordExePartHome];
    HPSearchHistoryView *hisView = [[HPSearchHistoryView alloc] init];
    
    NSMutableArray *buttonArray = [NSMutableArray array];
//    [self.records enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        UIButton *button = [self buttonWith:obj frame:CGRectZero];
//        [buttonArray addObject:button];
//    }];
    /// testcode
    for (int i = 0; i<300; i++) {
        UIButton *button = [LGRecordButtonLoader buttonWith:@"搜索历史" frame:CGRectZero];
        [buttonArray addObject:button];
    }
    
    [LGRecordButtonLoader addButtonTo:hisView.scrollv viewController:self array:buttonArray.copy action:@selector(recordClick:)];
    
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
    _searchHistory = hisView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lg_endOfSpeech:) name:LGVoiceRecoganizerEndOfSpeechNotification object:nil];
    
    /// 默认进入页面自动响应输入
    [self addTextFieldToNav:_fakeNavgationBar];
    
    [LGLocalSearchRecord sharedInstance];
}
- (void)recordClick:(UIButton *)record{
    
    NSLog(@"clickrecord.title: %@",record.titleLabel.text);
}
- (void)deleteSearchRecord:(UIButton *)sender{
    NSLog(@"删除历史记录: ");
    
}

#pragma mark - notifications
- (void)lg_endOfSpeech:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    NSString *voiceString = dict[LGVoiceRecoganizerTextKey];
    /// 去掉标点符号
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"。，@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *trimmedString = [voiceString stringByTrimmingCharactersInSet:set];
    
    self.textField.text = [NSString stringWithFormat:@"%@%@",self.textField.text,trimmedString];
}
- (void)textFieldTextDidChange:(NSNotification *)notification{
    UITextField *obj = notification.object;
    _searchContent = obj.text;
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
    if (!_vsView) {
        [self.view addSubview:self.vsView];
    }
}
- (void)navRightButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self sendSearchRequest];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self navRightButtonClick:nil];
    return YES;
}

/** 发送搜索请求 */
- (void)sendSearchRequest{
    [self.view endEditing:YES];
    /// TODO: 发送搜索请求
//    _searchContent
    
    /** type: 默认传0
     1:微党课
     2:党建要闻
     */
    
    /// 写入搜索记录 测试数据，测试用户id：1，模块: home
    [LGLocalSearchRecord addNewRecordWithContent:_searchContent part:SearchRecordExePartHome userid:@"1"];
//    [LGLocalSearchRecord addNewRecordWithContent:_searchContent part:SearchRecordExePartDiscovery userid:@"1"];
//
//    [LGLocalSearchRecord addNewRecordWithContent:_searchContent part:SearchRecordExePartHome userid:@"2"];
//    [LGLocalSearchRecord addNewRecordWithContent:_searchContent part:SearchRecordExePartDiscovery userid:@"2"];
    
    [DJNetworkManager homeSearchWithString:_searchContent type:0 offset:0 length:10 sort:0 success:^(id responseObj) {
        /// TODO: 刷新子可控制器视图
        [_searchHistory removeFromSuperview];
        _searchHistory = nil;
        NSArray *classes = responseObj[@"classes"];
        NSArray *news = responseObj[@"news"];
//        NSLog(@"lectureSearch_classes -- %@",classes);
//        NSLog(@"lectureSearch_news -- %@",news);
        
        NSMutableArray *microModels = [NSMutableArray array];
        [classes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EDJMicroPartyLessionSubModel *model = [EDJMicroPartyLessionSubModel mj_objectWithKeyValues:obj];
            [microModels addObject:model];
        }];
        
        HPMicroLessonTableViewController *microvc = self.childViewControllers[0];
        microvc.dataArray = microModels.copy;
        
        NSMutableArray *partyModels = [NSMutableArray array];
        [news enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DCSubPartStateModel *model = [DCSubPartStateModel mj_objectWithKeyValues:obj];
            [partyModels addObject:model];
        }];
        DCSubPartStateTableViewController *partyvc = self.childViewControllers[1];
        partyvc.dataArray = partyModels.copy;
        
    } failure:^(id failureObj) {
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
//        _textField.backgroundColor = [UIColor orangeColor];
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
     DCSubPartStateTableViewController
     DCSubStageTableviewController
     */
    return @[@{LGSegmentItemNameKey:@"微党课",
               LGSegmentItemViewControllerClassKey:@"HPMicroLessonTableViewController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               },
             @{LGSegmentItemNameKey:@"要闻",
               LGSegmentItemViewControllerClassKey:@"DCSubPartStateTableViewController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeCode
               }];
}
- (CGFloat)segmentTopMargin{
    return kNavSingleBarHeight + marginTen;
}

- (void)addTextFieldToNav:(LGNavigationSearchBar *)navigationSearchBar{
    if (!_textField) {
        navigationSearchBar.isEditing = YES;
        [self.view addSubview:self.textField];
        CGRect frame = navigationSearchBar.fakeSearch.frame;
        frame.size.width -= 25;
        self.textField.frame = frame;
        [self.textField becomeFirstResponder];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
