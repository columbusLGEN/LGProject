//
//  ECRReadMonster.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/19.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRReadMonster.h"
#import "ECRHomeRMCell.h"
#import "ECRHeadlineView.h"

@interface ECRReadMonster ()
@property (strong,nonatomic) ECRHeadlineView *headLine;// 标题
/** 容器视图*/
@property (strong,nonatomic) UIView *containerView;

@end

@implementation ECRReadMonster

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.clipsToBounds = YES;
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.tableView];
        [self addSubview:self.headLine];
        
        [self.headLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@36);
        }];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headLine.mas_bottom);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_top);
            make.left.equalTo(self.containerView.mas_left);
            make.right.equalTo(self.containerView.mas_right);
            make.bottom.equalTo(self.containerView.mas_bottom);
        }];

        [self skinWithType:[LGSkinSwitchManager getCurrentUserSkin]];
    }
    return self;
}
- (void)skinWithType:(ECRHomeUIType)type{
    switch (type) {
        case ECRHomeUITypeDefault:{
            self.backgroundColor = [UIColor whiteColor];
        }
            break;
        case ECRHomeUITypeAdultTwo:{
            self.tableView.layer.borderWidth = 1;
            self.tableView.layer.borderColor = [LGSkinSwitchManager homeBorderColor].CGColor;
        }
            break;
        case ECRHomeUITypeKidOne:{
            _headLine.iconImgName = @"icon_headline_duck";
            CGFloat cr = 28;
            self.tableView.layer.cornerRadius = cr;
            self.tableView.layer.masksToBounds = YES;
            self.containerView.layer.cornerRadius = cr;
            self.containerView.layer.masksToBounds = YES;
            [self.containerView unifySetShadow];
        }
            break;
        case ECRHomeUITypeKidtwo:{
            
        }
            break;
    }
    _headLine.iconImgName = @"icon_home_read_mon";
}
- (ECRHeadlineView *)headLine{
    if (_headLine == nil) {
        _headLine = [[ECRHeadlineView alloc] init];
        _headLine.headTitle = @"阅读达人榜";
    }
    return _headLine;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
- (UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}
- (NSString *)tableviewCellId{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return @"ECRHomeRMIpadCell";
    }else{
        return @"ECRHomeRMCell";
    }
}

@end
