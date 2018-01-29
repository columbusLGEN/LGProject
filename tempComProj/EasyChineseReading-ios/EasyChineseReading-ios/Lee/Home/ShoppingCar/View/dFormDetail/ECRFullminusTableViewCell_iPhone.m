//
//  ECRFullminusTableViewCell_iPhone.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/15.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRFullminusTableViewCell_iPhone.h"
#import "ECRFullminusModel.h"

@interface ECRFullminusTableViewCell_iPhone ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *money;// 减
@property (weak, nonatomic) IBOutlet UILabel *fullMoney;// 满
@property (weak, nonatomic) IBOutlet UILabel *timeLimit;
@property (weak, nonatomic) IBOutlet UILabel *fmDisc;

@end

@implementation ECRFullminusTableViewCell_iPhone

- (void)setModel:(ECRFullminusModel *)model{
    _model = model;
    [self.bgImg setImage:[UIImage imageNamed:model.bgImgName]];
    _money.text = [NSString stringWithFormat:@"￥%@",model.minusMoney];
    _fullMoney.text = model.fullminusTypeName;
    _fmDisc.text = model.memo;
    NSString *stime;
    if (model.starttime.length > 10) {
        stime = [model.starttime substringToIndex:10];
    }
    NSString *etime;
    if (model.endtime.length > 10) {
        etime = [model.endtime substringToIndex:10];
    }
    if ([model.endtime isEqualToString:@""]) {
        _timeLimit.text = @"该卡券异常";
    }else{
        _timeLimit.text = [NSString stringWithFormat:@"%@ -- %@",stime,etime];
    }
    
    if (model.isAva) {
    }else{
        self.userInteractionEnabled = NO;
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)cellHeight{
    if ([ECRMultiObject userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 150;
    }else{
        return 130;
    }
}

@end
