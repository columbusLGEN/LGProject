//
//  UCRStudentSelectedHeaderView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRStudentSelectedHeaderView.h"

@interface UCRStudentSelectedHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblClass;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end

@implementation UCRStudentSelectedHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addGestureRecognizer];
}

- (void)updateSystemLanguage
{
    _lblClass.text  = LOCALIZATION(@"班级");
    _lblName.text   = LOCALIZATION(@"姓名");
    _lblNumber.text = LOCALIZATION(@"序号");
}

- (void)addGestureRecognizer
{
    UITapGestureRecognizer *tapSelected = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgSelected)];
    [_imgSelected addGestureRecognizer:tapSelected];
}

- (void)tapImgSelected
{
    _selectedAll = !_selectedAll;
    [self.delegate selectedAllUser];
}

- (void)setSelectedAll:(BOOL)selectedAll
{
    _imgSelected.image = selectedAll ? [UIImage imageNamed:cImageSelected] : [UIImage imageNamed:cImageUnSelected];
}

@end
