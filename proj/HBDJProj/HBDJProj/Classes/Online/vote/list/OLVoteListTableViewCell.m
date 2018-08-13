//
//  OLVoteListTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteListTableViewCell.h"
#import "OLVoteListModel.h"

static NSString * const ob_key_poth = @"votestatus";

@interface OLVoteListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *vote;


@end

@implementation OLVoteListTableViewCell

- (void)setModel:(OLVoteListModel *)model{
    _model = model;
    if (model.votestatus == 1) {
        _vote.text = @"已投票";
        _vote.textColor = [UIColor EDJGrayscale_66];
    }else if (model.votestatus == 0){
        _vote.text = @"待投票";
        _vote.textColor = [UIColor EDJColor_57C6FF];
    }else if(model.votestatus == 3){
        _vote.text = @"已结束";
        _vote.textColor = [UIColor EDJGrayscale_C2];
    }else{
        /// 未开始
        
    }
    _title.text = model.title;
    if (model.starttime.length > length_timeString_1) {
        model.starttime = [model.starttime substringToIndex:length_timeString_1];
    }
    _time.text = model.starttime;
    
    [model addObserver:self forKeyPath:ob_key_poth options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:ob_key_poth] && object == _model) {
        if (_model.votestatus == 1) {
            _vote.text = @"已投票";
            _vote.textColor = [UIColor EDJGrayscale_66];
        }else if (_model.votestatus == 0){
            _vote.text = @"待投票";
            _vote.textColor = [UIColor EDJColor_57C6FF];
        }else if(_model.votestatus == 3){
            _vote.text = @"已结束";
            _vote.textColor = [UIColor EDJGrayscale_C2];
        }else{
            /// 未开始
            
        }
    }
}

- (void)dealloc{
    [_model removeObserver:self forKeyPath:ob_key_poth];
    
}

@end
