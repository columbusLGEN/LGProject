//
//  HPBookInfoBriefCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBookInfoBriefCell.h"
#import "HPBookInfoModel.h"

@interface HPBookInfoBriefCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end

@implementation HPBookInfoBriefCell

@synthesize model = _model;

- (void)setModel:(HPBookInfoModel *)model{
    _model = model;
    
    _itemTitle.text = model.itemTitle;
    _contentLabel.text = model.content;
}

- (IBAction)showAllClick:(UIButton *)sender {
    if (_model.showAll) {
        _model.showAll = NO;
        _arrow.transform = CGAffineTransformIdentity;
    }else{
        _model.showAll = YES;
        _arrow.transform = CGAffineTransformMakeRotation(M_PI);
    }
    sender.selected = !sender.isSelected;
    
//    if ([self.delegate respondsToSelector:@selector(bibCellShowAllButtonClick:)]) {
//        [self.delegate bibCellShowAllButtonClick:self];
//    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
