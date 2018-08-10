//
//  OLExamCollectionViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamCollectionViewCell.h"
#import "OLExamSingleModel.h"
#import "OLExamSingleViewController.h"

@interface OLExamCollectionViewCell ()
@property (strong,nonatomic) OLExamSingleViewController *controller;

@end

@implementation OLExamCollectionViewCell

- (void)setModel:(OLExamSingleModel *)model{
    _model = model;
    self.controller.backLook = _backLook;
    self.controller.model = model;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.controller.tableView];
        self.controller.tableView.frame = self.contentView.bounds;
    }
    return self;
}

- (OLExamSingleViewController *)controller{
    if (!_controller) {
        _controller = [OLExamSingleViewController new];
    }
    return _controller;
}

@end
