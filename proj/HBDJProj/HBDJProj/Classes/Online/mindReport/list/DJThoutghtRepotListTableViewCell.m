//
//  DJThoutghtRepotListTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoutghtRepotListTableViewCell.h"
#import "DJThoutghtRepotListModel.h"
#import "DJBanIndicateView.h"

@interface DJThoutghtRepotListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeading;
@property (weak,nonatomic) DJBanIndicateView *banin;

@end

@implementation DJThoutghtRepotListTableViewCell

- (void)setModel:(DJThoutghtRepotListModel *)model{
    _model = model;
    
    [self assiDataWithModel:model];
}

- (void)setUcmuModel:(DJThoutghtRepotListModel *)ucmuModel{
    _ucmuModel = ucmuModel;
    [self assiDataWithModel:ucmuModel];
    if (ucmuModel.edit) {
        /// 编辑状态
        [self.contentView addSubview:self.seButon];
        [self.seButon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(marginFifteen);
            make.top.equalTo(self.title.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(marginFifteen);
        }];
        self.seButon.selected = ucmuModel.select;
        self.titleLeading.constant = 38;
        
    }else{
        [self.seButon removeFromSuperview];
        self.titleLeading.constant = 15;
    }
    
    if (ucmuModel.auditstate == 0) {
        _banin.hidden = NO;
        [self.contentView bringSubviewToFront:_banin];
    }else{
        _banin.hidden = YES;
    }
    
    [ucmuModel addObserver:self forKeyPath:select_key options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:select_key] && object == self.ucmuModel) {
        self.seButon.selected = self.ucmuModel.select;
    }
}

- (void)assiDataWithModel:(DJThoutghtRepotListModel *)model{
    _title.text = model.title;
    if (model.createdtime.length > length_timeString_1) {
        _time.text = [model.createdtime substringToIndex:(length_timeString_1 + 1)];
    }else{
        _time.text = model.createdtime;
    }
    _author.text = [@"上传者: " stringByAppendingString:model.uploader];
    [_image sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJPlaceholderImage];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    DJBanIndicateView *banin = DJBanIndicateView.new;
    [self.contentView addSubview:banin];
    _banin = banin;
    banin.hidden = YES;
    
    [banin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)dealloc{
    [self.ucmuModel removeObserver:self forKeyPath:select_key];
}

@end
