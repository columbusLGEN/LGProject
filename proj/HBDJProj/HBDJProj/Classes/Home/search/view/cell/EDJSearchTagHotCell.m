//
//  EDJSearchTagHotCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJSearchTagHotCell.h"

@interface EDJSearchTagHotCell ()
@property (weak, nonatomic) IBOutlet UIButton *tagButton;


@end

@implementation EDJSearchTagHotCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tagButton setBackgroundColor:[UIColor EDJMainColor]];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.tagButton cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:self.tagButton.height * 0.5];
    /// TODO: 想在初始化阶段就确定按钮的样式,但是初始化阶段并不知道 数据的类型是 热门标签 还是 历史记录
    /// 使用继承呢? 父类cell 作为抽象类存在,管理cell
    
}

@end
