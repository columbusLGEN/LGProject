//
//  UInfoVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserInfoVC.h"

#import "ZPickView.h"
#import "ZPickDateView.h"

#import "UserInfoAddressVC.h"

#import "ZNetworkRequest.h"

@interface UserInfoVC () <UITextFieldDelegate, UITextViewDelegate, ZPickDateViewDelegate, ZPickViewDelegate>

// 描述
@property (weak, nonatomic) IBOutlet UILabel *lblDescAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblDescName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescLive;
@property (weak, nonatomic) IBOutlet UILabel *lblDescSex;
@property (weak, nonatomic) IBOutlet UILabel *lblDescLanguage;
@property (weak, nonatomic) IBOutlet UILabel *lblDescCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblDesclearnyear;
@property (weak, nonatomic) IBOutlet UILabel *lblDescInsterest;
@property (weak, nonatomic) IBOutlet UILabel *lblDescBirthday;
@property (weak, nonatomic) IBOutlet UILabel *lblDescSchool;
// 占位文字
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholderAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholderInterest;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholderSchool;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
// 昵称
@property (weak, nonatomic) IBOutlet UITextField *txtfName;
// 地址
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
// 兴趣爱好
@property (weak, nonatomic) IBOutlet UITextView *txtInterest;
// 学校
@property (weak, nonatomic) IBOutlet UITextView *txtSchool;

@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UILabel *lblLanguage;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
// 学习汉语年限
@property (weak, nonatomic) IBOutlet UILabel *lbllearnyear;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;

@property (weak, nonatomic) IBOutlet UILabel *lblAddressLength;
@property (weak, nonatomic) IBOutlet UILabel *lblInterestLength;
@property (weak, nonatomic) IBOutlet UILabel *lblSchoolLength;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
// 头像载体（阴影）
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
// 右箭头
@property (weak, nonatomic) IBOutlet UIImageView *imgRA0;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA4;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA5;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA6;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA7;

/** 临时选中的图片 */
@property (strong, nonatomic) UIImage *tempImage;
/** 性别 */
@property (strong, nonatomic) NSArray *arrSex;
/** 语言 */
@property (strong, nonatomic) NSArray *arrLanguage;
/** 学习年数 */
@property (strong, nonatomic) NSArray *arrLearnYear;

/** 性别选择 */
@property (strong, nonatomic) ZPickView *pickViewSex;
/** 母语选择 */
@property (strong, nonatomic) ZPickView *pickViewLanguage;
/** 学习年数选择 */
@property (strong, nonatomic) ZPickView *pickViewLearnYear;
/** 时间选择器 */
@property (strong, nonatomic) ZPickDateView *dateView;

/** 用户信息 */
@property (strong, nonatomic) UserModel *user;

/** table 偏移 */
@property (assign, nonatomic) CGFloat oldOffset;

@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUserInfoView];
    [self configUserInfoData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self addNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置 用户信息界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"我的信息");
    
    _lblDescAvatar.text     = LOCALIZATION(@"头像");
    _lblDescName.text       = LOCALIZATION(@"昵称");
    _lblDescLive.text       = LOCALIZATION(@"居住地");
    _lblDescSex.text        = LOCALIZATION(@"性别");
    _lblDescLanguage.text   = LOCALIZATION(@"母语");
    _lblDescCountry.text    = LOCALIZATION(@"所在国家或地区");
    _lblDesclearnyear.text  = LOCALIZATION(@"学习汉语年数");
    _lblDescInsterest.text  = LOCALIZATION(@"兴趣爱好");
    _lblDescBirthday.text   = LOCALIZATION(@"生日");
    _lblDescSchool.text     = LOCALIZATION(@"学校名称");
    
    _lblPlaceholderAddress.text  = LOCALIZATION(@"请输入居住地址");
    _lblPlaceholderInterest.text = LOCALIZATION(@"请输入兴趣爱好");
    _lblPlaceholderSchool.text   = LOCALIZATION(@"请输入学校名");
    
    [_btnSave setTitle:LOCALIZATION(@"保存") forState:UIControlStateNormal];
}

- (void)configUserInfoView
{
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = 44;
    
    _imgAvatar.backgroundColor = [UIColor whiteColor];
    
    _imgAvatar.layer.borderColor   = [UIColor whiteColor].CGColor;
    _imgAvatar.layer.borderWidth   = 3.f;
    _imgAvatar.layer.cornerRadius  = _imgAvatar.height/2;
    _imgAvatar.layer.masksToBounds = YES;
    
    _viewShadow.layer.shadowRadius  = 1.f;
    _viewShadow.layer.shadowOpacity = .5f;
    _viewShadow.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    _viewShadow.backgroundColor     = [UIColor clearColor];
    
    _btnSave.layer.masksToBounds = YES;
    _btnSave.layer.cornerRadius  = _btnSave.height/2;
    
    _txtfName.font    = [UIFont systemFontOfSize:cFontSize_16];
    _txtInterest.font = [UIFont systemFontOfSize:cFontSize_16];
    _txtAddress.font  = [UIFont systemFontOfSize:cFontSize_16];
    _txtSchool.font   = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblPlaceholderSchool.font   = [UIFont systemFontOfSize:cFontSize_16];
    _lblPlaceholderInterest.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblPlaceholderAddress.font  = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblAddressLength.textColor = [UIColor cm_blackColor_666666_1];
    _lblAddressLength.font      = [UIFont systemFontOfSize:cFontSize_14];
    _lblAddressLength.text      = [NSString stringWithFormat:@"0/%ld", cMaxAddressLength];
    
    _lblSchoolLength.textColor = [UIColor cm_blackColor_666666_1];
    _lblSchoolLength.font      = [UIFont systemFontOfSize:cFontSize_14];
    _lblSchoolLength.text      = [NSString stringWithFormat:@"0/%ld", cMaxSchoolLength];
    
    _lblInterestLength.textColor = [UIColor cm_blackColor_666666_1];
    _lblInterestLength.font      = [UIFont systemFontOfSize:cFontSize_14];
    _lblInterestLength.text      = [NSString stringWithFormat:@"0/%ld", cMaxInterestLength];
    
    _lblPlaceholderSchool.textColor   = [UIColor cm_grayColor__807F7F_1];
    _lblPlaceholderInterest.textColor = [UIColor cm_grayColor__807F7F_1];
    _lblPlaceholderAddress.textColor  = [UIColor cm_grayColor__807F7F_1];
    
    _txtfName.textColor    = [UIColor cm_blackColor_666666_1];
    _txtSchool.textColor   = [UIColor cm_blackColor_333333_1];
    _txtAddress.textColor  = [UIColor cm_blackColor_333333_1];
    _txtInterest.textColor = [UIColor cm_blackColor_333333_1];
    
    _btnSave.backgroundColor = [UIColor cm_mainColor];
    [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _imgRA0.image = _imgRA4.image = _imgRA5.image = _imgRA6.image = _imgRA7.image = [UIImage imageNamed:@"icon_arrow_right"];
}

- (void)configUserInfoData
{
    _user = [[UserRequest sharedInstance].user copy];

    _txtfName.text = _user.name.length > 0 ? _user.name : [NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"昵称"), LOCALIZATION(@"字符长度为"), cMaxNameLength];
    
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:_user.iconUrl] placeholderImage:[UIImage imageNamed:@"img_avatar_placeholder"]];
    
    _txtAddress.text  = _user.address;
    _txtInterest.text = _user.interest;
    _txtSchool.text   = _user.school;
    
    _lblPlaceholderSchool.hidden   = _txtSchool.text.length > 0;
    _lblPlaceholderInterest.hidden = _txtInterest.text.length > 0;
    _lblPlaceholderAddress.hidden  = _txtAddress.text.length > 0;
    
    _lblSex.text       = [NSString stringWithFormat:@"%@", self.arrSex[_user.sex]];
    _lblLanguage.text  = [NSString stringWithFormat:@"%@", self.arrLanguage[_user.motherTongue]];
    _lblCountry.text   = _user.countryName;
    _lbllearnyear.text = [NSString stringWithFormat:@"%ld", _user.learnYears];
    _lblBirthday.text  = _user.birthday.length > 0 ? [_user.birthday substringToIndex:10] : @"";
    
    _lblAddressLength.text  = [NSString stringWithFormat:@"%ld/%ld", _user.address.charLength,  cMaxAddressLength];
    _lblInterestLength.text = [NSString stringWithFormat:@"%ld/%ld", _user.interest.charLength, cMaxInterestLength];
    _lblSchoolLength.text   = [NSString stringWithFormat:@"%ld/%ld", _user.school.charLength,   cMaxSchoolLength];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:UITextFieldTextDidChangeNotification];
}

#pragma mark - UIPickerView

/** 性别选择 */
- (void)configPickViewSex
{
    if (_pickViewSex == nil) {
        _pickViewSex = [[ZPickView alloc] initWithFrame:self.view.bounds dataSource:self.arrSex selected:0];
        _pickViewSex.delegates = self;
        [self.view addSubview:_pickViewSex];
    }
    [_pickViewSex show];
}

/** 母语选择 */
- (void)configPickViewLanguage
{
    if (_pickViewLanguage == nil) {
        _pickViewLanguage = [[ZPickView alloc] initWithFrame:self.view.bounds dataSource:self.arrLanguage selected:0];
        _pickViewLanguage.delegates = self;
        [self.view addSubview:_pickViewLanguage];
    }
    [_pickViewLanguage show];
}

/** 学习年限选择 */
- (void)configPickViewlearnyear
{
    if (_pickViewLearnYear == nil) {
        _pickViewLearnYear = [[ZPickView alloc] initWithFrame:self.view.bounds dataSource:self.arrLearnYear selected:0];
        _pickViewLearnYear.delegates = self;
        [self.view addSubview:_pickViewLearnYear];
    }
    [_pickViewLearnYear show];
}

/** 生日 */
- (void)configDateView
{
    if (_dateView == nil) {
        _dateView = [[ZPickDateView alloc] initWithFrame:self.view.bounds getAfterDate:NO selected:nil];
        _dateView.delegete = self;
        [self.view addSubview:_dateView];
    }
    [_dateView show];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resignAllFirstResponder];
    switch (indexPath.row) {
        case 0: [self camera];                  break;
        case 3: [self configPickViewSex];       break;
        case 4: [self configPickViewLanguage];  break;
        case 5: [self toSelectCountry];         break;
        case 6: [self configPickViewlearnyear]; break;
        case 9: [self seletcedBirthday];        break;
        default:                                break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCellSeparatorInset:UIEdgeInsetsZero];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChanged:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if ([textField isEqual: _txtfName]) {
        _user.name = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignAllFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 判断系统的emoji表情，禁止输入emoji
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}

#pragma mark - text delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView isEqual:_txtAddress]) {
        _lblPlaceholderAddress.hidden = textView.text.length > 0;
        _user.address = textView.text;
        _lblAddressLength.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.charLength, cMaxAddressLength];
    }
    else if ([textView isEqual:_txtInterest]) {
        _lblPlaceholderInterest.hidden = textView.text.length > 0;
        _user.interest = textView.text;
        _lblInterestLength.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.charLength, cMaxInterestLength];
    }
    else if ([textView isEqual:_txtSchool]) {
        _lblPlaceholderSchool.hidden = textView.text.length > 0;
        _user.school = textView.text;
        _lblSchoolLength.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.charLength, cMaxSchoolLength];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self resignAllFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //如果当前位移大于缓存位移，说明scrollView向下滑动
        if (scrollView.contentOffset.y < _oldOffset)
            [self resignAllFirstResponder];
        //将当前位移变成缓存位移
        _oldOffset = scrollView.contentOffset.y;
    }
}

- (void)resignAllFirstResponder
{
    if ([_txtfName isFirstResponder])         { [_txtfName resignFirstResponder]; }
    else if ([_txtSchool isFirstResponder])   { [_txtSchool resignFirstResponder]; }
    else if ([_txtAddress isFirstResponder])  { [_txtAddress resignFirstResponder]; }
    else if ([_txtInterest isFirstResponder]) { [_txtInterest resignFirstResponder]; }
}

#pragma mark - ZPickDateViewDelegate

/** 取消选择 */
- (void)datePickerViewCancel:(ZPickDateView *)picker
{
    [picker hidden];
}

/** 选择生日 */
- (void)datePickerView:(ZPickDateView *)picker selectedDate:(NSDate *)aValue
{
    [picker hidden];
    NSString *strDate = [NSString stringWithFormat:@"%@", aValue];
    strDate = [strDate substringToIndex:10];
    _lblBirthday.text = strDate;
    _user.birthday = strDate;
}

#pragma mark - ZPickViewDelegate

/** 取消选择 */
- (void)ZPickerViewCancel:(ZPickView *)picker;
{
    [picker hidden];
}

/**
 选中选项

 @param picker 选择器
 @param index  选择的数据
 */
- (void)ZPickerView:(ZPickView *)picker makeSureIndex:(NSInteger)index
{
    if (picker == _pickViewSex) {
        _user.sex = index;
        _lblSex.text = _arrSex[index];
    }
    if (picker == _pickViewLanguage) {
        _user.motherTongue = index;
        _lblLanguage.text = _arrLanguage[index];
    }
    if (picker == _pickViewLearnYear) {
        _user.learnYears = index;
        NSNumber *num = _arrLearnYear[index];
        _lbllearnyear.text = [NSString stringWithFormat:@"%@", num];
    }
    [picker hidden];
}

#pragma mark - action

/** 选择国家 */
- (void)toSelectCountry
{
    UserInfoAddressVC *addressVC = [[UserInfoAddressVC alloc] init];
    addressVC.language = [UserRequest sharedInstance].language;
    addressVC.country  = [UserRequest sharedInstance].user.country;
    WeakSelf(self)
    addressVC.selectedCountryBlock = ^(CountryModel *country) {
        StrongSelf(self)
        self.user.country = country.id;
        self.user.countryName = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? country.zh_name : country.en_name;
        self.lblCountry.text = self.user.countryName.length > 0 ? self.user.countryName : [self getCountryWithCode:self.user.country];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

/** 选择生日 */
- (void)seletcedBirthday
{
    [self configDateView];
}

#pragma mark - 保存用户信息

/** 点击保存 */
- (IBAction)click_btnSave:(id)sender {
    [self checkUserInfo];
}

/** 检查用户信息的正确性 */
- (void)checkUserInfo
{
    if ([NSString stringContainsEmoji:_user.name] ||
        [NSString stringContainsEmoji:_user.address] ||
        [NSString stringContainsEmoji:_user.interest] ||
        [NSString stringContainsEmoji:_user.school]) {
        [self presentFailureTips:LOCALIZATION(@"不能输入emoji表情")];
        return;
    }
    if ([NSString stringContainsIllegalCharacter:_user.name] && _user.name.length > 0) {
        [self presentFailureTips:LOCALIZATION(@"昵称不能输入特殊符号")];
        return;
    }
    if (_user.name.charLength > cMaxNameLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"昵称"),LOCALIZATION(@"字符长度为"), cMaxNameLength]];
        return;
    }
    if (_user.address.charLength > cMaxAddressLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"居住地"),LOCALIZATION(@"字符长度为"), cMaxAddressLength]];
        return;
    }
    if (_user.interest.charLength > cMaxInterestLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"兴趣爱好"),LOCALIZATION(@"字符长度为"), cMaxInterestLength]];
        return;
    }
    if (_user.school.charLength > cMaxSchoolLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"学校名称"),LOCALIZATION(@"字符长度为"), cMaxSchoolLength]];
        return;
    }
    // 如果更换了头像则先上传头像
    if (_tempImage)
        [self uploadAvatarImage];
    // 没有变更头像就直接更新用户信息
    else
        [self saveUserInfo];
}

/** 保存用户信息 */
- (void)saveUserInfo {
    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] updateUserInfoWithName:_user.name
                                                 address:_user.address
                                                     sex:[NSString stringWithFormat:@"%ld", _user.sex]
                                                language:[NSString stringWithFormat:@"%ld", _user.motherTongue]
                                                 country:[NSString stringWithFormat:@"%ld", _user.country]
                                               learnyear:[NSString stringWithFormat:@"%ld", _user.learnYears]
                                                interest:_user.interest
                                                birthday:_user.birthday
                                                 iconUrl:_user.iconUrl
                                                  school:_user.school
                                             countryName:_lblCountry.text
                                              completion:^(id object, ErrorModel *error) {
                                                  StrongSelf(self)
                                                  [self dismissTips];
                                                  if (error) {
                                                      [self presentFailureTips:error.message];
                                                  }
                                                  else {
                                                      [UserRequest sharedInstance].user = self.user;
                                                      [[UserRequest sharedInstance] saveCache];
                                                      [self presentSuccessTips:LOCALIZATION(@"保存成功")];
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      });
                                                  }
                                              }];
}

#pragma mark - 更换头像

/** 拍照 */
- (void)camera
{
    [self showAlertForSystemPhotoWithTitle:nil];
}

/**
 选择照片
 
 @param image 照片
 */
- (void)handleImgWith:(UIImage *)image
{
    _imgAvatar.image = image;
    _tempImage = image;
}

/** 上传头像 */
- (void)uploadAvatarImage
{
    NSData *data = UIImageJPEGRepresentation(_tempImage, .5f);
    
    [self showWaitTips];
    WeakSelf(self)
    [ZNetworkRequest uploadImg:data urlString:[NSString stringWithFormat:@"%@/%@", AppServerBaseURL, @"user/uploadPictures"] parameters:nil callBack:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self dismissTips];
            [self presentFailureTips:error.message];
        }
        else {
            // 上传成功以后保存用户信息
            NSString *iconUrl = object;
            self.user.iconUrl = iconUrl;
            [self saveUserInfo];
        }
    }];
}

#pragma mark - 获取国家

/**
 根据国家编码获取国家名

 @param code 国家编码
 @return 国家名
 */
- (NSString *)getCountryWithCode:(NSInteger)code
{
    NSArray *arrCountry = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_CountryList];
    __block NSString *strCountry = @"";
    [arrCountry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CountryModel *country = [CountryModel mj_objectWithKeyValues:obj];
        if (country.id == code) {
            strCountry = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? country.zh_name : country.en_name;
            *stop = YES;
        }
    }];
    return strCountry;
}

#pragma mark - 属性

- (NSArray *)arrSex
{
    if (_arrSex == nil) {
        _arrSex = @[LOCALIZATION(@"男"), LOCALIZATION(@"女")];
    }
    return _arrSex;
}

- (NSArray *)arrLanguage
{
    if (_arrLanguage == nil) {
        _arrLanguage = @[LOCALIZATION(@"中文"), LOCALIZATION(@"英文")];
    }
    return _arrLanguage;
}

- (NSArray *)arrLearnYear
{
    if (_arrLearnYear == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < 50; i ++) {
            [array addObject:@(i)];
        }
        _arrLearnYear = [NSMutableArray arrayWithArray:array];
    }
    return _arrLearnYear;
}

@end
