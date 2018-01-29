
//
//  UCSManageDetailVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/13.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCStudentInfoVC.h"

@interface UCStudentInfoVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblDescClass;
@property (weak, nonatomic) IBOutlet UILabel *lblDescName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescSex;
@property (weak, nonatomic) IBOutlet UILabel *lblDescAge;
@property (weak, nonatomic) IBOutlet UILabel *lblDescAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblDescRemark;

@property (weak, nonatomic) IBOutlet UILabel *lblClass;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark;
@property (weak, nonatomic) IBOutlet UIImageView *imgRightArrow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLblClassConstraint;

@property (assign, nonatomic) NSInteger classIndex; // 班级

@end

@implementation UCStudentInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"修改学生");
    
    _lblDescClass.text   = LOCALIZATION(@"所属班级");
    _lblDescName.text    = LOCALIZATION(@"姓名");
    _lblDescSex.text     = LOCALIZATION(@"性别");
    _lblDescAge.text     = LOCALIZATION(@"年龄");
    _lblDescAccount.text = LOCALIZATION(@"账号");
    _lblDescRemark.text  = LOCALIZATION(@"备注");
}

- (void)configTableView
{
    UIColor *descTextColor = [UIColor cm_blackColor_333333_1];
    UIColor *textColor = [UIColor cm_grayColor__807F7F_1];
    UIFont *font = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblDescClass.textColor   = descTextColor;
    _lblDescName.textColor    = descTextColor;
    _lblDescSex.textColor     = descTextColor;
    _lblDescAge.textColor     = descTextColor;
    _lblDescAccount.textColor = descTextColor;
    _lblDescRemark.textColor  = descTextColor;
    
    _lblName.textColor      = textColor;
    _lblSex.textColor       = textColor;
    _lblAge.textColor       = textColor;
    _lblAccount.textColor   = textColor;
    _lblClass.textColor     = textColor;
    _lblRemark.textColor    = textColor;
    
    _lblDescClass.font   = font;
    _lblDescName.font    = font;
    _lblDescSex.font     = font;
    _lblDescAge.font     = font;
    _lblDescAccount.font = font;
    _lblDescRemark.font  = font;
    
    _lblClass.font   = font;
    _lblSex.font     = font;
    _lblName.font    = font;
    _lblAge.font     = font;
    _lblAccount.font = font;
    _lblRemark.font  = font;
    
    _lblName.text    = _student.name;
    _lblSex.text     = [NSString stringWithFormat:@"%@", _student.sex == ENUM_SexTypeMan ? LOCALIZATION(@"男") : LOCALIZATION(@"女")];
    _lblAge.text     = [NSString stringWithFormat:@"%ld", _student.age];
    _lblAccount.text = _student.phone.length > 0 ? [NSString stringWithFormat:@"+%ld %@", _student.areacode, _student.phone] : _student.email;
    _lblRemark.text  = _student.remark;
    _lblClass.text   = _student.className;
    
    _rightLblClassConstraint.constant = 15;
    _imgRightArrow.hidden = YES;
}

@end
