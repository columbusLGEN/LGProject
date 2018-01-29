//
//  UCMAddVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UClassManagerEditVC.h"

@interface UClassManagerEditVC () <UITextFieldDelegate, UITextViewDelegate, ZPickViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblDescClassName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescClassNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblDescClassDescribe;
@property (weak, nonatomic) IBOutlet UILabel *lblDescTeacher;
@property (weak, nonatomic) IBOutlet UILabel *lblTeacher;
@property (weak, nonatomic) IBOutlet UILabel *lblRemarkPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxRemarkLength;

@property (weak, nonatomic) IBOutlet UITextField *txtfClassName;
@property (weak, nonatomic) IBOutlet UITextField *txtClassNumber;
@property (weak, nonatomic) IBOutlet UITextView  *txtClassDescribe;

@property (weak, nonatomic) IBOutlet UITableViewCell *cellSelectedTeacher;

@property (weak, nonatomic) IBOutlet UIImageView *imgRightArrow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightClassConstraint;

@property (strong, nonatomic) ZPickView *pickView; // 选择教师

@property (strong, nonatomic) UserModel *teacher; // 教师

@property (strong, nonatomic) NSArray *arrTeacher; // 教师数组

@property (strong, nonatomic) NSMutableArray *arrClass; // 班级

@end

@implementation UClassManagerEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configAddView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"班级信息");
    
    _lblDescClassName.text     = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"班级名称")];
    _lblDescClassNumber.text   = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"班级人数")];
    _lblDescClassDescribe.text = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"班级概况")];
    _lblDescTeacher.text       = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"班主任")];
    _lblRemarkPlaceholder.text = [NSString stringWithFormat:@"%@ %ld", LOCALIZATION(@"字符长度为"), cMaxClassDescLength];
    
    _txtfClassName.placeholder    = LOCALIZATION(@"");
    _txtClassNumber.placeholder   = LOCALIZATION(@"");
}

- (void)configAddView
{
    _lblDescClassName.textColor     = [UIColor cm_blackColor_333333_1];
    _lblDescClassNumber.textColor   = [UIColor cm_blackColor_333333_1];
    _lblDescClassDescribe.textColor = [UIColor cm_blackColor_333333_1];
    _lblDescTeacher.textColor       = [UIColor cm_blackColor_333333_1];
    _lblTeacher.textColor           = [UIColor cm_blackColor_333333_1];
    _lblRemarkPlaceholder.textColor = [UIColor cm_placeholderColor_C7C7CD_1];
    _lblMaxRemarkLength.textColor   = [UIColor cm_blackColor_666666_1];
    
    _lblRemarkPlaceholder.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblMaxRemarkLength.font   = [UIFont systemFontOfSize:cFontSize_14];
    
    UIColor *color = _classType == ENUM_UpdateTypeNo ? [UIColor cm_grayColor__807F7F_1] : [UIColor cm_blackColor_333333_1];
    _imgRightArrow.image = [UIImage imageNamed:@"icon_arrow_right"];
    _imgRightArrow.hidden = _classType == ENUM_UpdateTypeNo;
    _rightClassConstraint.constant = _classType == ENUM_UpdateTypeNo ? 15.f : 35.f;
    _lblRemarkPlaceholder.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblMaxRemarkLength.hidden = _classType == ENUM_UpdateTypeNo;
    _lblRemarkPlaceholder.hidden = _classType == ENUM_UpdateTypeNo;
    
    _lblTeacher.textColor        = color;
    _txtfClassName.textColor     = color;
    _txtClassNumber.textColor    = color;
    _txtClassDescribe.textColor  = color;
    
    if (_classType > 0) {
        [self configNavigationItem];
    }
    
    if ([self.classInfo.teacherName notEmpty]) {
        _lblTeacher.text = _classInfo.teacherName;
    }
    else {
        NSArray *arrTeacher = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_TeacherList];
        [arrTeacher enumerateObjectsUsingBlock:^(UserModel *teacher, NSUInteger idx, BOOL * _Nonnull stop) {
            if (_classInfo.teacherId == teacher.userId) {
                _lblTeacher.text = teacher.name;
                *stop = YES;
            }
        }];
    }
    
    _txtfClassName.text    = _classInfo.className;
    _txtClassNumber.text   = _classInfo.studentNum > 0 ? [NSString stringWithFormat:@"%ld", _classInfo.studentNum] : @"";
    _txtClassDescribe.text = _classInfo.synopsis;
    _lblRemarkPlaceholder.hidden = _txtClassDescribe.text.length > 0;

    _lblMaxRemarkLength.text =  [NSString stringWithFormat:@"%ld/%ld", _txtClassDescribe.text.charLength, cMaxClassDescLength];
    _cellSelectedTeacher.selectionStyle = _classType == ENUM_UpdateTypeNo ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
}

- (void)configNavigationItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"保存") style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}

#pragma mark - 保存班级信息
- (void)save
{
    // 班级信息检查
    if (_classInfo.teacherId == 0) {
        [self presentFailureTips:LOCALIZATION(@"请选择班主任")];
        return;
    }
    if ([_txtfClassName.text empty]) {
        [self presentFailureTips:LOCALIZATION(@"请输入班级名")];
        return;
    }
    if (![_txtClassNumber.text isNumber]) {
        [self presentFailureTips:LOCALIZATION(@"学生人数请输入数字")];
        return;
    }
    if (_txtfClassName.text.charLength > cMaxClassNameLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"班级名称"),LOCALIZATION(@"字符长度为"), cMaxClassNameLength]];
        return;
    }
    if (_txtClassDescribe.text.charLength > cMaxClassDescLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"班级概况"),LOCALIZATION(@"字符长度为"), cMaxClassDescLength]];
        return;
    }
    if ([NSString stringContainsEmoji:_txtfClassName.text] ||
        [NSString stringContainsEmoji:_txtClassDescribe.text]) {
        [self presentFailureTips:LOCALIZATION(@"不能输入emoji表情")];
        return;
    }
    
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] updateClassInfoWithType:_classType
                                                   classId:_classType == ENUM_UpdateTypeAdd ? 0 : _classInfo.classId
                                                 teacherId:_classInfo.teacherId
                                                studentNum:[_txtClassNumber.text integerValue]
                                                 className:_txtfClassName.text
                                                  synopsis:_txtClassDescribe.text
                                                completion:^(id object, ErrorModel *error) {
                                                    StrongSelf(self)
                                                    [self dismissTips];
                                                    if (error) {
                                                        [self presentFailureTips:error.message];
                                                    }
                                                    else {
                                                        if (self.classType == ENUM_UpdateTypeAdd) {
                                                            self.arrClass = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_ClassesList];
                                                            
                                                            ClassModel *classInfo = [ClassModel new];
                                                            NSArray *classInfos   = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
                                                            classInfo.classId     = [[classInfos firstObject][@"classId"] integerValue];
                                                            classInfo.iconUrl     = [classInfos firstObject][@"iconUrl"];
                                                            classInfo.teacherId   = self.classInfo.teacherId;
                                                            classInfo.teacherName = self.classInfo.teacherName;
                                                            classInfo.studentNum  = self.txtClassNumber.text.integerValue;
                                                            classInfo.className   = self.txtfClassName.text;
                                                            classInfo.synopsis    = self.txtClassDescribe.text;
                                                            classInfo.teacherName = self.lblTeacher.text;
                                                            
                                                            [self.arrClass addObject:classInfo];
                                                            [[CacheDataSource sharedInstance] setCache:self.arrClass withCacheKey:CacheKey_ClassesList];
                                                            [[NSNotificationCenter defaultCenter] fk_postNotification:kNotificationUpdateClasses];
                                                        }
                                                        else {
                                                            ClassModel *newClassInfo = [self.classInfo copy];
                                                            
                                                            newClassInfo.teacherId   = self.classInfo.teacherId;
                                                            newClassInfo.teacherName = self.classInfo.teacherName;
                                                            newClassInfo.teacherName = self.lblTeacher.text;
                                                            newClassInfo.studentNum  = self.txtClassNumber.text.integerValue;
                                                            newClassInfo.className   = self.txtfClassName.text;
                                                            newClassInfo.synopsis    = self.txtClassDescribe.text;
                                                            
                                                            self.updateClassSuccess(newClassInfo);
                                                        }
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    }
                                                }];
}

#pragma mark -
/** 教师选择 */
- (void)configPickView
{
    if (_pickView == nil) {
        _pickView = [[ZPickView alloc] initWithFrame:self.view.bounds dataSource:self.arrTeacher selected:0];
        _pickView.delegates = self;
        [self.view addSubview:_pickView];
    }
    [self resignAllFirstResponder];
    [_pickView show];
}

/** 取消所有第一响应者 */
- (void)resignAllFirstResponder
{
    [_txtfClassName    resignFirstResponder];
    [_txtClassNumber   resignFirstResponder];
    [_txtClassDescribe resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row && _classType != ENUM_UpdateTypeNo) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.arrTeacher.count > 0)
            [self configPickView];
        else
            [self presentFailureTips:LOCALIZATION(@"没有教师")];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_pickView.showing == YES) {
        [_pickView hidden];
    }
    
//    if ([textField isEqual:_txtfClassName]) {
//        return _classType > 0;
//    }
//    else if ([textField isEqual:_txtClassNumber]) {
//        return _classType > 0;
//    }
//    else {
        return _classType > 0;
//    }
}

#pragma mark -

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return _classType > 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _lblRemarkPlaceholder.hidden = textView.text.length > 0;
    _lblMaxRemarkLength.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.charLength, cMaxClassDescLength];
}

#pragma mark - ZPickViewDelegate

- (void)ZPickerViewCancel:(ZPickView *)picker
{
    [_pickView hidden];
}

/** 选择教师 */
- (void)ZPickerView:(ZPickView *)picker makeSureIndex:(NSInteger)index
{
    _teacher = index > 0 ? _arrTeacher[index] : _arrTeacher.firstObject;
    _lblTeacher.text       = _teacher.name;
    _classInfo.teacherName = _teacher.name;
    _classInfo.teacherId   = _teacher.userId;
    [_pickView hidden];
}

#pragma mark - 属性

- (NSArray *)arrTeacher
{
    if (_arrTeacher == nil) {
        _arrTeacher = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_TeacherList];
    }
    return _arrTeacher;
}

- (ClassModel *)classInfo
{
    if (_classInfo == nil) {
        _classInfo = [ClassModel new];
    }
    return _classInfo;
}

@end
