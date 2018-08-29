//
//  LGSwitchCanEditViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSwitchCanEditViewController.h"
#import "LGSegmentBottomView.h"
#import "LGSegmentScrollView.h"

@interface LGSwitchCanEditViewController ()<LGSegmentBottomViewDelegate>

@end

@implementation LGSwitchCanEditViewController

#pragma mark - LGSegmentBottomViewDelegate
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom{
}
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom{
}

- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit) {
        _allSelecteView.hidden = NO;
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(_allSelecteView.mas_top);
            make.top.equalTo(self.segment.mas_bottom).offset(marginTen);
        }];
    }else{
        _allSelecteView.hidden = YES;
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
            make.top.equalTo(self.segment.mas_bottom).offset(marginTen);
        }];
    }
}

- (void)configUI{
    [super configUI];
    
    LGSegmentBottomView *asv = [LGSegmentBottomView segmentBottom];
    asv.delegate = self;
    [self.view addSubview:asv];
    _allSelecteView = asv;
    CGFloat bottomHeight = [LGSegmentBottomView bottomHeight];
    [asv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(bottomHeight);
    }];
    asv.hidden = YES;
}


@end
