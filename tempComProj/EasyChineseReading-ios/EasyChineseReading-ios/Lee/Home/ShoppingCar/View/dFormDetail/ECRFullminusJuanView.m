//
//  ECRFullminusJuanView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/24.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRFullminusJuanView.h"
#import "ECRFullminusModel.h"

@interface ECRFullminusJuanView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *money;// 减
@property (weak, nonatomic) IBOutlet UILabel *fullMoney;// 满
@property (weak, nonatomic) IBOutlet UILabel *timeLimit;
@property (weak, nonatomic) IBOutlet UILabel *fmDisc;

@end

@implementation ECRFullminusJuanView

- (IBAction)juanClick:(UIButton *)sender {
    NSDictionary *userInfo = @{@"model":self.model};
    [[NSNotificationCenter defaultCenter] postNotificationName:ECRFullminusJuanViewClickNotification object:nil userInfo:userInfo];
}

- (void)setModel:(ECRFullminusModel *)model{
    _model = model;
    [self.bgImg setImage:[UIImage imageNamed:model.bgImgName]];
    _money.text = [NSString stringWithFormat:@"￥%@",model.minusMoney];
//    _fullMoney.text = [NSString stringWithFormat:@"满%.2f可用",model.fullMoney.floatValue];
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

+ (instancetype)fmJuanView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ECRFullminusJuanView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end
