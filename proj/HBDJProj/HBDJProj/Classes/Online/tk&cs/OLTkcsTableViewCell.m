//
//  OLTkcsTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLTkcsTableViewCell.h"
#import "OLTkcsModel.h"

static NSString * const teststatus_keyPath = @"teststatus";

@interface OLTkcsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *count;


@end

@implementation OLTkcsTableViewCell

- (void)setModel:(OLTkcsModel *)model{
    _model = model;
    _title.text = model.subjecttitle;
    if (model.tkcsType == 0) {
        /// 题库列表 显示题目数量
        _count.text = [NSString stringWithFormat:@"%ld题",(long)model.subcount];
    }else{
        /// 测试列表 显示状态 
        _count.text = self.model.statusDesc;
        _count.textColor = self.model.statusDescColor;
        
        [model addObserver:self forKeyPath:teststatus_keyPath options:NSKeyValueObservingOptionNew context:nil];
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.model && [keyPath isEqualToString:teststatus_keyPath]) {
        _count.text = self.model.statusDesc;
        _count.textColor = self.model.statusDescColor;
    }
}

- (void)dealloc{
    [self.model removeObserver:self forKeyPath:teststatus_keyPath];
}


@end
