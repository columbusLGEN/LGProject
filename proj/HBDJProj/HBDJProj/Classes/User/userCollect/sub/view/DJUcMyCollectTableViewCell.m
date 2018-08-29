//
//  DJUcMyCollectTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectTableViewCell.h"
#import "DJUcMyCollectModel.h"

static NSString * keyPath_select = @"select";

@implementation DJUcMyCollectTableViewCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//
//    }
//    return self;
//}
- (void)setCollectModel:(DJUcMyCollectModel *)collectModel{
    _collectModel = collectModel;
    [collectModel addObserver:self forKeyPath:keyPath_select options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:keyPath_select] && object == self.collectModel) {
        self.seButon.selected = self.collectModel.select;
    }
}

- (UIButton *)seButon{
    if (!_seButon) {
        _seButon = UIButton.new;
        [_seButon setImage:[UIImage imageNamed:@"uc_icon_upload_edit_normal"] forState:UIControlStateNormal];
        [_seButon setImage:[UIImage imageNamed:@"uc_icon_upload_edit_selected"] forState:UIControlStateSelected];
    }
    return _seButon;
}

- (void)dealloc{
    [self.collectModel removeObserver:self forKeyPath:keyPath_select];
}

@end
