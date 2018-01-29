//
//  UCImpowerDescribeVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/19.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCImpowerDescribeVC.h"

#import "UCRecommendManageVC.h"

#import "ECRBookListModel.h"

#import "ZPickDateView.h"

@interface UCImpowerDescribeVC () <UITextViewDelegate, ZPickDateViewDelegate>

@property (strong, nonatomic) UITextView *txtDescribe;  // 推荐的内容
@property (strong, nonatomic) UILabel *lblPlaceHolder;  // 用 label 仿制推荐描述上的 placeHolder
@property (strong, nonatomic) UILabel *lblDescribeLength; // 描述长度

@property (strong, nonatomic) UIView *verLine; // 竖线
@property (strong, nonatomic) UIView *midLine; // 时间分隔线

@property (strong, nonatomic) UILabel *lblDesc; // 授权周期描述
@property (strong, nonatomic) UILabel *lblStartTime; // 授权开始时间
@property (strong, nonatomic) UILabel *lblEndedTime; // 授权截止时间

@property (strong, nonatomic) ZPickDateView *startTimeView; // 授权开始时间
@property (strong, nonatomic) ZPickDateView *endedTimeView; // 授权截止时间

@property (strong, nonatomic) NSString *strStartTime; // 授权开始时间
@property (strong, nonatomic) NSString *strEndedTime; // 授权截止时间

@property (strong, nonatomic) NSDate *startTime; // 授权开始时间
@property (strong, nonatomic) NSDate *endedTime; // 授权截止时间

@property (strong, nonatomic) NSDate *minDate; // 最小授权开始时间
@property (strong, nonatomic) NSDate *maxDate; // 最大授权截止时间

@property (strong, nonatomic) NSDate *now;     // 当前时间

@property (assign, nonatomic) BOOL changeEndTime ; // 改变截止的时间

@end

@implementation UCImpowerDescribeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
}

#pragma mark -

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"授权阅读");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"授权") style:UIBarButtonItemStylePlain target:self action:@selector(submitImpower)];
}

- (void)configView
{
    [self configMinAndMaxDate];
    [self configImpowerCycleView];
    [self configTxtDescribeView];
}

- (void)configImpowerCycleView
{
    _verLine = [[UIView alloc] initWithFrame:CGRectMake(12, 20, 3, 14)];
    _verLine.backgroundColor = [UIColor cm_mainColor];
    [self.view addSubview:_verLine];
    
    _lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(12 + 3 + 10, 0, 80, 54)];
    _lblDesc.text = LOCALIZATION(@"授权周期");
    _lblDesc.textColor = [UIColor cm_blackColor_333333_1];
    _lblDesc.font = [UIFont systemFontOfSize:cFontSize_16];
    [self.view addSubview:_lblDesc];
    
    _lblStartTime = [[UILabel alloc] initWithFrame:CGRectMake(_lblDesc.x + _lblDesc.width + 5, 10, 100, 34)];
    _lblStartTime.textColor = [UIColor cm_blackColor_333333_1];
    _lblStartTime.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblStartTime.textAlignment = NSTextAlignmentCenter;
    _lblStartTime.layer.borderColor = [UIColor cm_blackColor_666666_1].CGColor;
    _lblStartTime.layer.borderWidth = .5f;
    [self.view addSubview:_lblStartTime];
    
    _midLine = [[UIView alloc] initWithFrame:CGRectMake(_lblStartTime.x + _lblStartTime.width + 5, 27, 15, .5f)];
    _midLine.backgroundColor = [UIColor cm_blackColor_666666_1];
    [self.view addSubview:_midLine];
    
    _lblEndedTime = [[UILabel alloc] initWithFrame:CGRectMake(_midLine.x + _midLine.width + 5, 10, 100, 34)];
    _lblEndedTime.textColor = [UIColor cm_blackColor_333333_1];
    _lblEndedTime.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblEndedTime.textAlignment = NSTextAlignmentCenter;
    _lblEndedTime.layer.borderColor = [UIColor cm_blackColor_666666_1].CGColor;
    _lblEndedTime.layer.borderWidth = .5f;
    [self.view addSubview:_lblEndedTime];
    
    _lblStartTime.userInteractionEnabled = YES;
    _lblEndedTime.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapStartTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedStartTime)];
    UITapGestureRecognizer *tapEndedTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedEndedTime)];
    [_lblStartTime addGestureRecognizer:tapStartTime];
    [_lblEndedTime addGestureRecognizer:tapEndedTime];
}

- (void)configTxtDescribeView
{
    _txtDescribe = [[UITextView alloc] initWithFrame:CGRectMake(20, 20 + 44, Screen_Width - 20 * 2, 200)];
    _txtDescribe.textColor = [UIColor cm_blackColor_333333_1];
    _txtDescribe.font = [UIFont systemFontOfSize:14.f];
    _txtDescribe.delegate = self;
    
    _txtDescribe.layer.borderColor = [UIColor cm_blackColor_333333_1].CGColor;
    _txtDescribe.layer.borderWidth = .5f;
    
    _lblPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(26, 26 + 44, 100, 20)];
    _lblPlaceHolder.textColor = [UIColor cm_lineColor_D9D7D7_1];
    _lblPlaceHolder.font = [UIFont systemFontOfSize:14.f];
    _lblPlaceHolder.text = LOCALIZATION(@"请输入授权描述");
    
    _lblDescribeLength = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width - 100, _txtDescribe.y + _txtDescribe.height + 5, 80, 20)];
    _lblDescribeLength.textColor = [UIColor cm_blackColor_666666_1];
    _lblDescribeLength.textAlignment = NSTextAlignmentRight;
    _lblDescribeLength.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblDescribeLength.text = [NSString stringWithFormat:@"%ld/%ld", _txtDescribe.text.charLength, cMaxMessageLength];

    [self.view addSubview:_txtDescribe];
    [self.view addSubview:_lblPlaceHolder];
    [self.view addSubview:_lblDescribeLength];
}

#pragma mark - 配置最大最小授权时间

- (void)configMinAndMaxDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";

    NSDate *date = [NSDate date];
    // 设置最大值
    NSString *max = @"2100-12-31 23:59:59 +0800";
    NSDate *maxTime = [dateFormatter dateFromString:max];
    
    _minDate = date;
    _maxDate = maxTime;

    for (NSInteger i = 0; i < _arrBooks.count; i ++) {
        BookModel *book = _arrBooks[i];
        NSString *bookEndTime = [book.endTime stringByAppendingString:@" 23:59:59 +0800"];
        NSDate *endedTime = [dateFormatter dateFromString:bookEndTime];
        _maxDate = [endedTime earlierDate:_maxDate];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    _lblPlaceHolder.hidden = textView.text.length > 0;
    _lblDescribeLength.text = [NSString stringWithFormat:@"%ld/%ld", _txtDescribe.text.charLength, cMaxMessageLength];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [_startTimeView hidden];
    [_endedTimeView hidden];
    
    if ([text isEqualToString:@""])
        return YES;
    if (range.length + range.location > textView.text.charLength)
        return NO;

    NSUInteger newLength = [textView.text charLength] + [text length] - range.length;
    
    return newLength <= cMaxRecommendLength;
}

#pragma mark - ZPickDateViewDelegate

- (void)datePickerViewCancel:(ZPickDateView *)picker
{
    [picker hidden];
}

- (void)datePickerView:(ZPickDateView *)picker selectedDate:(NSDate *)aValue
{
    [picker hidden];
    
    NSString *strDate = [NSString stringWithFormat:@"%@", aValue];
    strDate = [strDate substringToIndex:10];
    strDate = [strDate stringByAppendingString:[NSString stringWithFormat:@"%@", _changeEndTime ? @" 23:59:59": @" 00:00:00"]];

    if (_changeEndTime) {
        if ([strDate compare:_strStartTime] == NSOrderedAscending) {
            [self presentFailureTips:LOCALIZATION(@"授权结束时间应晚于授权开始时间")];
            return;
        }
        _lblEndedTime.text = [strDate substringToIndex:10];
        _endedTime = aValue;
        _strEndedTime = strDate;
    }
    else {
        _lblStartTime.text = [strDate substringToIndex:10];
        _startTime = aValue;
        _strStartTime = strDate;
    }
}

#pragma mark - action

/** 选择开始时间 */
- (void)selectedStartTime
{
    [self.view endEditing:YES];
    _changeEndTime = NO;
    
    if (_startTimeView == nil) {
        _startTimeView = [[ZPickDateView alloc] initWithFrame:self.view.bounds getAfterDate:YES selected:nil minDate:_minDate maxDate:_maxDate];
        _startTimeView.delegete = self;
        [self.view addSubview:_startTimeView];
    }
    [_startTimeView show];
}

/** 选择结束时间 */
- (void)selectedEndedTime
{
    [self.view endEditing:YES];
    _changeEndTime = YES;
    if (_endedTimeView == nil) {
        _endedTimeView = [[ZPickDateView alloc] initWithFrame:self.view.bounds getAfterDate:YES selected:_maxDate minDate:_minDate maxDate:_maxDate];
        _endedTimeView.delegete = self;
        [self.view addSubview:_endedTimeView];
    }
    [_endedTimeView show];
}

/** 提交推荐阅读的内容 */
- (void)submitImpower
{
    if (_strStartTime.length == 0 || _strStartTime == nil || [_strStartTime isEqualToString:@""]) {
        [self presentFailureTips:LOCALIZATION(@"请选择授权起始时间")];
        return;
    }
    if (_strEndedTime.length == 0 || _strEndedTime == nil || [_strEndedTime isEqualToString:@""]) {
        [self presentFailureTips:LOCALIZATION(@"请选择授权结束时间")];
        return;
    }
    if ([_strEndedTime compare:_strStartTime] == NSOrderedAscending) {
        [self presentFailureTips:LOCALIZATION(@"授权结束时间应晚于授权开始时间")];
        return;
    }
    if (_arrBooks.count == 0) {
        [self presentFailureTips:LOCALIZATION(@"请选择授权图书")];
        return;
    }
    if (_arrUsers.count == 0) {
        [self presentFailureTips:LOCALIZATION(@"请选择授权的人员")];
        return;
    }
    // 检查 emoji
    if ([NSString stringContainsEmoji:_txtDescribe.text]) {
        [self presentFailureTips:LOCALIZATION(@"不能输入emoji表情")];
        return;
    }
    // 检查字符超限
    if (_txtDescribe.text.charLength > cMaxRecommendLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"授权"),LOCALIZATION(@"字符长度为"), cMaxRecommendLength]];
        return;
    }
    
    NSString *strBookIds = @"";
    NSString *strUserIds = @"";
    // 将图书和选中的人数组组成的字符串, 用逗号分隔
    for (NSInteger i = 0; i < _arrBooks.count; i ++) {
        ECRBookListModel *book = _arrBooks[i];
        strBookIds = [strBookIds stringByAppendingString:[NSString stringWithFormat:@"%ld,", book.bookId]];
    }
    for (NSInteger i = 0; i < _arrUsers.count; i ++) {
        UserModel *user = _arrUsers[i];
        strUserIds = [strUserIds stringByAppendingString:[NSString stringWithFormat:@"%ld,", user.userId]];
    }
    // 去掉最后一个逗号
    strBookIds = [strBookIds substringToIndex:strBookIds.length - 1];
    strUserIds = [strUserIds substringToIndex:strUserIds.length - 1];
    
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] impowerBookWithContent:_txtDescribe.text bookIds:strBookIds studentIds:strUserIds startTime:_strStartTime endTime:_strEndedTime completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            [self fk_postNotification:kNotificationReloadImpowers];
            [self popToViewControllerWithController:[UCRecommendManageVC class] completionBlock:^{
                
            }];
        }
    }];
}

@end
