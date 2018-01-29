//
//  EmptyView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EmptyView.h"

@interface EmptyView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgEmtpy;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblSubDesc;

@end

@implementation EmptyView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configEmptyView];
}

- (void)configEmptyView
{
    _lblDesc.textColor = [UIColor cm_grayColor__807F7F_1];
    _lblSubDesc.textColor = [UIColor cm_blackColor_666666_1];
    
    _lblDesc.font = [UIFont systemFontOfSize:16.f];
    _lblSubDesc.font = [UIFont systemFontOfSize:16.f];
}

- (void)updateEmptyView
{
    _imgEmtpy.image = _image ? _image : [UIImage imageNamed:@"zan9"];
;
    _lblDesc.text = _strDesc;
    
    _lblSubDesc.hidden = [_strDesc empty];
    _lblSubDesc.text = _strSubDesc;
}

- (void)updateEmptyViewWithType:(ENUM_EmptyResultType)type Image:(UIImage *)image desc:(NSString *)desc subDesc:(NSString *)subDesc
{
    [self updateEmptyViewWithType:type Image:image desc:desc subDesc:subDesc backgroundColor:[UIColor whiteColor]];
}

- (void)updateEmptyViewWithType:(ENUM_EmptyResultType)type Image:(UIImage *)image desc:(NSString *)desc subDesc:(NSString *)subDesc backgroundColor:(UIColor *)color
{
    switch (type) {
        case ENUM_EmptyResultTypeClass:
            image   = image ? image : [UIImage imageNamed:@"img_empty_class"];
            desc    = desc  ? desc  : LOCALIZATION(@"还没有班级啊");
            subDesc = subDesc ? subDesc : LOCALIZATION(@"创建班级之前请先创建教师账号");
            break;
        case ENUM_EmptyResultTypeFriend:
            image   = image ? image : [UIImage imageNamed:@"img_empty_friend"];
            desc    = desc  ? desc  : LOCALIZATION(@"居然没有好友, 还在等什么");
            subDesc = subDesc ? subDesc : @"";
            break;
        case ENUM_EmptyResultTypeData:
            image   = image ? image : [UIImage imageNamed:@"img_empty_view"];
            desc    = desc  ? desc  : LOCALIZATION(@"暂无数据");
            subDesc = subDesc  ? subDesc : @"";
            break;
        case ENUM_EmptyResultTypeSearch:
            image   = image ? image : [UIImage imageNamed:@"img_empty_search"];
            desc    = desc  ? desc  : LOCALIZATION(@"哎呦, 没有找到你想要的");
            subDesc = subDesc ? subDesc : @"";
            break;
        case ENUM_EmptyResultTypeUnknow:
            image   = image ? image : [UIImage imageNamed:@"img_empty_view"];
            desc    = desc  ? desc  : LOCALIZATION(@"无结果");
            subDesc = subDesc ? subDesc : @"";
            break;
        case ENUM_EmptyResultTypeNetwork:
            image   = image ? image : [UIImage imageNamed:@"img_empty_network"];
            desc    = desc  ? desc  : LOCALIZATION(@"链接失败, 请检查你的网络");
            subDesc = subDesc ? subDesc : @"";
            break;
        case ENUM_EmptyResultTypeShopCar:
            image   = image ? image : [UIImage imageNamed:@"img_empty_shop_car"];
            desc    = desc  ? desc  : LOCALIZATION(@"空空如也, 还不去买买买?");
            subDesc = subDesc ? subDesc : LOCALIZATION(@"去书城看看");
            break;
        case ENUM_EmptyResultTypeTeacher:
            image   = image ? image : [UIImage imageNamed:@"img_empty_teacher"];
            desc    = desc  ? desc  : LOCALIZATION(@"没有教师");
            subDesc = subDesc ? subDesc : @"";
            break;
        case ENUM_EmptyResultTypeStudent:
            image   = image ? image : [UIImage imageNamed:@"img_empty_teacher"];
            desc    = desc  ? desc  : LOCALIZATION(@"没有学生");
            subDesc = subDesc ? subDesc : @"";
            break;
        case ENUM_EmptyResultTypeTicket:
            image   = image ? image : [UIImage imageNamed:@"img_empty_ticket"];
            desc    = desc  ? desc  : LOCALIZATION(@"没有可用的卡券, 到领券中心看看吧");
            subDesc = subDesc ? subDesc : @"";
            break;
        default:
            break;
    }
    _imgEmtpy.image  = image;
    _lblDesc.text    = desc;
    _lblSubDesc.text = subDesc;
    
    self.backgroundColor = color;
//    if ([color isEqual:[UIColor clearColor]]) {
//        _lblDesc.backgroundColor = color;
//        _lblSubDesc.backgroundColor = color;
//
//        _lblDesc.textColor = [UIColor whiteColor];
//        _lblSubDesc.backgroundColor = [UIColor whiteColor];
//    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
