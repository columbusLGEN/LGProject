//
//  UCTeacherEditVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCTeacherInfoVC.h"

@interface UCTeacherInfoVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblDescName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescSex;
@property (weak, nonatomic) IBOutlet UILabel *lblDescAge;
@property (weak, nonatomic) IBOutlet UILabel *lblDescAccount; // 账号 包括 phone/email
@property (weak, nonatomic) IBOutlet UILabel *lblDescRemark;

@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;

@property (weak, nonatomic) IBOutlet UITextField *txtfName;
@property (weak, nonatomic) IBOutlet UITextField *txtfAge;
@property (weak, nonatomic) IBOutlet UILabel     *lblRemark;

@property (strong, nonatomic) NSArray *arrSex;             // 性别数组
@property (strong, nonatomic) NSMutableArray *arrTeachers; // 教师数组

@property (assign, nonatomic) NSInteger sex; // 性别
@property (assign, nonatomic) ENUM_AccountType accountType; // 账号类型

@property (assign, nonatomic) CGFloat heightRemark;

@end

@implementation UCTeacherInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self configData];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"教师信息");
    
    _lblDescName.text       = LOCALIZATION(@"姓名");
    _lblDescSex.text        = LOCALIZATION(@"性别");
    _lblDescAge.text        = LOCALIZATION(@"年龄");
    _lblDescAccount.text    = LOCALIZATION(@"账号");
    _lblDescRemark.text     = LOCALIZATION(@"备注");
    
    [self.tableView reloadData];
}

- (void)configTableView
{
    _lblDescName.textColor    = [UIColor cm_blackColor_333333_1];
    _lblDescSex.textColor     = [UIColor cm_blackColor_333333_1];
    _lblDescAge.textColor     = [UIColor cm_blackColor_333333_1];
    _lblDescAccount.textColor = [UIColor cm_blackColor_333333_1];
    _lblDescRemark.textColor  = [UIColor cm_blackColor_333333_1];
    
    _lblDescName.font     = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescSex.font      = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescAge.font      = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescAccount.font  = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescRemark.font   = [UIFont systemFontOfSize:cFontSize_16];

    _lblSex.textColor     = [UIColor cm_grayColor__807F7F_1];
    _lblAccount.textColor = [UIColor cm_grayColor__807F7F_1];
    _lblRemark.textColor  = [UIColor cm_grayColor__807F7F_1];
    _txtfName.textColor   = [UIColor cm_grayColor__807F7F_1];
    _txtfAge.textColor    = [UIColor cm_grayColor__807F7F_1];
    
    _lblAccount.font     = [UIFont systemFontOfSize:cFontSize_16];
    _lblSex.font         = [UIFont systemFontOfSize:cFontSize_16];
    _lblRemark.font      = [UIFont systemFontOfSize:cFontSize_16];
    _txtfName.font       = [UIFont systemFontOfSize:cFontSize_16];
    _txtfAge.font        = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)configData
{
    _txtfName.text   = _teacher.name;
    _txtfAge.text    = [NSString stringWithFormat:@"%ld", _teacher.age];
    _lblRemark.text  = _teacher.remark;
    
    CGSize size = [self stringSize:_lblRemark.text widthOfFatherView:(Screen_Width - 10*2) textFont:[UIFont systemFontOfSize:cFontSize_16]];
    _heightRemark = size.height + cHeaderHeight_54;
    
    _lblAccount.text = _teacher.phone.length > 0 ? [NSString stringWithFormat:@"+%ld %@", _teacher.areacode, _teacher.phone] : _teacher.email;
    _lblSex.text     = _teacher.sex == ENUM_SexTypeMan ? LOCALIZATION(@"男") : LOCALIZATION(@"女");
}

#pragma mark - UITextFieldDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 4 == indexPath.row ? _heightRemark : cHeaderHeight_44;
}

#pragma mark - text field delegate
 
 - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
 {
     return NO;
 }

#pragma mark -

- (CGSize)stringSize:(NSString *)contentString widthOfFatherView:(CGFloat)width textFont:(UIFont *)font{
    NSDictionary *attributesDic = @{NSFontAttributeName:font};
    CGSize size = [contentString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size;
    return size;
}

#pragma mark - 属性

- (NSArray *)arrSex
{
    if (_arrSex == nil) {
        _arrSex = @[LOCALIZATION(@"男"), LOCALIZATION(@"女")];
    }
    return _arrSex;
}

@end
