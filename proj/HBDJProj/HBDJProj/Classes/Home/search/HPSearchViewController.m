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
#import "HPSearchRequest.h"

@interface HPSearchViewController ()<
LGNavigationSearchBarDelelgate,
UITextFieldDelegate,
HPVoiceSearchViewDelegate>
@property (strong,nonatomic) LGNavigationSearchBar *fakeNavgationBar;
@property (strong,nonatomic) UITextField *textField;
@property (strong,nonatomic) HPVoiceSearchView *vsView;
@property (strong,nonatomic) NSString *searchContent;

@end

@implementation HPSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LGNavigationSearchBar *fakeNavgationBar = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
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
    
    // TODO: 先加一个大白板，搜索到结果后，将大白板删除
    
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

    if (!_textField) {
        navigationSearchBar.isEditing = YES;
        [self.view addSubview:self.textField];
        CGRect frame = navigationSearchBar.fakeSearch.frame;
        frame.size.width -= 25;
        self.textField.frame = frame;
        [self.textField becomeFirstResponder];
    }
}
- (void)leftButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    [self lg_dismissViewController];
}
- (void)voiceButtonClick:(LGNavigationSearchBar *)navigationSearchBar{
    // TODO: 添加语音搜索页面，获取到搜索文字内容之后添加 textField
    NSLog(@"语音搜索 -- ");
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endInput];
}
/** 发送搜索请求 */
- (void)sendSearchRequest{
    [self.view endEditing:YES];
    /// TODO: 发送搜索请求
//    _searchContent
    HPSearchRequest *searchRequest = [[HPSearchRequest alloc] initWithContent:_searchContent type:0 offset:@"0" length:@"1" success:^(id responseObject) {
        NSLog(@"responseObject -- %@",responseObject);
        /// TODO: 刷新子可控制器视图
        
    } failure:^(id faillureObject) {
        NSLog(@"faillureObject -- %@",faillureObject);
    } networkFailure:^(NSError *error) {
        NSLog(@"error -- %@",error);
    }];
    [searchRequest start];
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
