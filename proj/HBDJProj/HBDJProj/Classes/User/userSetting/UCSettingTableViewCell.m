//
//  UCSettingTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCSettingTableViewCell.h"
#import "UCSettingModel.h"
#import "LGCacheClear.h"
#import "LGUserLimitsManager.h"

static NSString * const keyPath_granted = @"granted";

@interface UCSettingTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UISwitch *onOff;
@property (weak, nonatomic) IBOutlet UILabel *info;


@end

@implementation UCSettingTableViewCell

- (IBAction)switchClick:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(stCellClickSwitchWithModel:sender:)]) {
        [self.delegate stCellClickSwitchWithModel:self.model sender:sender];
    }
}

- (void)setModel:(UCSettingModel *)model{
    _model = model;
    _itemName.text = model.itemName;
    
    if (model.contentType == 1) {
        _info.hidden = YES;
        _onOff.hidden = NO;
        if (model.subType == 0) {
            __weak typeof(self) weakSelf = self;
            [LGUserLimitsManager userUNAuthorizationWith:^(BOOL granted) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    weakSelf.onOff.on = granted;
                }];
            }];
        }
        if (model.subType == 1) {
            _onOff.on = DJUser.sharedInstance.WIFI_playVideo_notice;
        }
        
    }else if (model.contentType == 0){
        _onOff.hidden = YES;
        _info.hidden = NO;
        _info.text = model.content;
        
    }else if (model.contentType == 2){
        _onOff.hidden = YES;
        _info.hidden = NO;
        /// MARK: 计算本地缓存内容大小
        _info.text = [LGCacheClear.new cacheSize];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _onOff.onTintColor = [UIColor EDJMainColor];
//    _onOff.userInteractionEnabled = NO;
}


@end
